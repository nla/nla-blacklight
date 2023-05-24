require "nokogiri"
require "httpclient"
require "multi_json"
require "http_client_patch/include_client"

#
# For EBSCO Discovery Service. You will need a license to use.
#
# == Required Configuration
#
# user_id, password: As given be EBSCO for access to EDS API (may be an admin account in ebscoadmin? Not sure).
# profile: As given by EBSCO, might be "edsapi"?
#
# == Highlighting
#
# EDS has a query-in-context highlighting feature. It is used by defualt, set
# config 'highlighting' to false to disable.
# If turned on, you may get <b class="bento_search_highlight"> tags
# in title and abstract output if it's on, marked html_safe.
#
#
# == Linking
#
# The link to record in EBSCO interface delivered as "PLink" will be listed
# as record main link. If the record includes a node at `./FullText/Links/Link/Type[text() = 'pdflink']`,
# the `plink` will be marked as fulltext. (There may be other cases of fulltext, but
# this seems to be all EDS API tells us.)
#
# Any links listed under <CustomLinks> will be listed as other_links, using
# configured name provided by EBSCO for CustomLink. Same with links listed
# as `<Item><Group>URL</Group>`.
#
# As always, you can customize links and other_links with Item Decorators.
#
# == Custom Data
#
# If present, subjects are stored in custom_data[:subjects] as the full subject string.
#
# == Technical Notes and Difficulties
#
# This API is pretty difficult to work with, and the response has many
# idiosyncratic undocumented parts.  We think we are currently
# getting fairly complete citation detail out, at least for articles, but may be missing
# some on weird edge cases, books/book chapters, etc)
#
# Auth issues may make this slow -- you need to spend a (not too speedy) HTTP
# request making a session for every new end-user -- as we have no way to keep
# track of end-users, we do it on every request in this implementation.
#
# An older version of the EDS API returned much less info, and we tried
# to scrape out what we could anyway. Much of this logic is still there
# as backup. In the older version, not enough info was there for an
# OpenURL link, `configuration.assume_first_custom_link_openurl` was true
# by default, and used to create an OpenURL link. It now defaults to false,
# and should no longer be neccessary.
#
# Title and abstract data seems to be HTML with tags and character entities and
# escaped special chars. We're trusting it and passing it on as html_safe.
#
# Paging can only happen on even pages, with 'page' rather than 'start'. But
# you can pass in 'start' to bento_search, it'll be converted to closest page.
#
# == Authenticated Users
#
# EDS allows searches by unauthenticated users, but the results come back with
# weird blank hits. In such a case, the BentoSearch adapter will return
# records with virtually no metadata, but a title e
# (I18n at bento_search.eds.record_not_available ). Also no abstracts
# are available from unauth search.
#
# By default the engine will search as 'guest' unauth user. But config
# 'auth' key to true to force all searches to auth (if you are protecting your
# app) or pass :auth => true as param into #search method.
#
# == EDS docs:
#
# * Console App to demo requests: <
# * EDS Wiki: http://edswiki.ebscohost.com/EDS_API_Documentation
# * You'll need to request an account to the EDS wiki, see: http://support.ebsco.com/knowledge_base/detail.php?id=5990
#

class BentoSearch::EdsPublicationEngine < BentoSearch::EdsEngine
  include BentoSearch::SearchEngine

  # Can't change http timeout in config, because we keep an http
  # client at class-wide level, and config is not class-wide.
  # We used to keep in constant, but that's not good for custom setting,
  # we now use class_attribute, but in a weird backwards-compat way for
  # anyone who might be using the constant.
  HTTP_TIMEOUT = 4

  class_attribute :http_timeout, instance_writer: false
  def self.http_timeout
    defined?(@http_timeout) ? @http_timeout : HTTP_TIMEOUT
  end

  extend HTTPClientPatch::IncludeClient
  include_http_client do |client|
    client.connect_timeout = client.send_timeout = client.receive_timeout = http_timeout
  end

  @@remembered_auth = nil
  @@remembered_auth_lock = Mutex.new
  # Class variable to save current known good auth
  # uses a mutex to be threadsafe. sigh.
  def self.remembered_auth
    @@remembered_auth_lock.synchronize do
      @@remembered_auth
    end
  end

  # Set class variable with current known good auth.
  # uses a mutex to be threadsafe.
  def self.remembered_auth=(token)
    @@remembered_auth_lock.synchronize do
      @@remembered_auth = token
    end
  end

  def self.required_configuration
    %w[user_id password profile]
  end

  def construct_search_url(args)
    query = "AND,"
    if args[:search_field]
      query += "#{args[:search_field]}:"
    end
    # Can't have any commas in query, it turns out, although
    # this is not documented.
    query += args[:query].gsub(",", " ")

    url = "#{configuration.publication_base_url}search?view=detailed&query=#{CGI.escape query}"

    url += "&highlight=#{configuration.highlighting ? "y" : "n"}"

    if args[:per_page]
      url += "&resultsperpage=#{args[:per_page]}"
    end
    if args[:page]
      url += "&pagenumber=#{args[:page]}"
    end

    if args[:sort]
      if (defn = sort_definitions[args[:sort]]) &&
          (value = defn[:implementation])
        url += "&sort=#{CGI.escape value}"
      end
    end

    if configuration.only_source_types.present?
      # facetfilter=1,SourceType:Research Starters,SourceType:Books
      url += "&facetfilter=" + CGI.escape("1," + configuration.only_source_types.collect { |t| "SourceType:#{t}" }.join(","))
    end

    url
  end

  def search_implementation(args)
    results = BentoSearch::Results.new

    end_user_auth = authenticated_end_user? args

    begin
      with_session(end_user_auth) do |session_token|
        url = construct_search_url(args)

        response = get_with_auth(url, session_token)

        results = BentoSearch::Results.new

        if (hits_node = at_xpath_text(response, "./PublicationSearchResponseMessageGet/SearchResult/Statistics/TotalHits"))
          results.total_items = hits_node.to_i
        end

        response.xpath("./PublicationSearchResponseMessageGet/SearchResult/Data/Records/Record").each do |record_xml|
          item = BentoSearch::ResultItem.new

          item.title = prepare_eds_payload(element_by_group(record_xml, "Ti"), true)

          # To get a unique id, we need to pull out db code and accession number
          # and combine em with colon, accession number is not unique by itself.
          db = record_xml.at_xpath("./Header/DbId").try(:text)
          accession = record_xml.at_xpath("./Header/An").try(:text)
          if db && accession
            item.unique_id = "#{db}:#{accession}"
          end

          if item.title.nil? && !end_user_auth
            item.title = I18n.t("bento_search.eds.record_not_available")
          end

          item.abstract = prepare_eds_payload(element_by_group(record_xml, "Ab"), true)

          # PLink is main inward facing EBSCO link, put it as
          # main link.
          if (direct_link = record_xml.at_xpath("./PLink"))
            item.link = direct_link.text

            fulltext_holdings = record_xml.xpath("./FullTextHoldings/FullTextHolding")
            if fulltext_holdings.size > 0
              item.link_is_fulltext = true
            end
          end

          # Other links may be found in FullTextHoldings
          record_xml.xpath("./FullTextHoldings/FullTextHolding").each do |fulltext_holding|
            item.other_links << BentoSearch::Link.new(
              url: fulltext_holding.at_xpath("./URL").text,
              label: fulltext_holding.at_xpath("./Name").text
            )
          end

          # Format.
          item.format_str = at_xpath_text record_xml, "./Header/ResourceType"

          # For some EDS results, we have actual citation information,
          # for some we don't.
          container_xml = record_xml.at_xpath("./RecordInfo/BibRecord/BibEntity")
          if container_xml
            item.issn = at_xpath_text(container_xml, "./Identifiers/Identifier[child::Type[text()='issn-print']]/Value")
            item.custom_data[:subjects] = at_xpath_text(container_xml, "./Subjects/Subject[child::Type[text()='general']]/SubjectFull")
          end

          results << item
        end
      end

      results
    rescue EdsCommException => e
      results.error ||= {}
      results.error[:exception] = e
      results.error[:http_status] = e.http_status
      results.error[:http_body] = e.http_body
      results
    end
  end
end
