# frozen_string_literal: true

require "digest"
require "erb"
require "blacklight/solr_cloud/repository"

class CatalogController < ApplicationController
  include BlacklightAdvancedSearch::Controller
  include Blacklight::Catalog
  include BlacklightRangeLimit::ControllerOverride
  include Blacklight::Marc::Catalog

  configure_blacklight do |config|
    # default advanced config values
    config.advanced_search ||= Blacklight::OpenStructWithHashAccess.new
    # config.advanced_search[:qt] ||= 'advanced'
    config.advanced_search[:url_key] ||= "advanced"
    config.advanced_search[:query_parser] ||= "dismax"
    config.advanced_search[:form_solr_parameters] ||= {}

    ## Class for sending and receiving requests from a search index
    if ENV["ZK_HOST"].present? && ENV["SOLR_COLLECTION"].present?
      config.repository_class = Blacklight::SolrCloud::Repository
    end
    #
    ## Class for converting Blacklight's url parameters to into request parameters for the search index
    # config.search_builder_class = ::SearchBuilder

    ## Model that maps search index responses to the blacklight response model
    config.response_model = Nla::Solr::Response

    ## Should the raw solr document endpoint (e.g. /catalog/:id/raw) be enabled
    config.raw_endpoint.enabled = false

    ## Default parameters to send to solr for all search-like requests. See also SearchBuilder#processed_parameters
    config.default_solr_params = {
      rows: 10
    }

    # solr path which will be added to solr base url before the other solr params.
    # config.solr_path = 'select'
    # config.document_solr_path = 'get'

    # items to show per page, each number in the array represent another option to choose from.
    # config.per_page = [10,20,50,100]

    # solr field configuration for search results/index views
    config.index.title_field = "title_tsim"
    config.index.display_type_field = "format"
    config.index.thumbnail_field = "thumbnail_path_ss"
    config.index.thumbnail_presenter = NlaThumbnailPresenter

    config.add_results_document_tool(:bookmark, partial: "bookmark_control", if: :render_bookmarks_control?)

    config.add_results_collection_tool(:sort_widget)
    config.add_results_collection_tool(:per_page_widget)
    config.add_results_collection_tool(:view_type_group)

    config.add_show_tools_partial(:bookmark, partial: "bookmark_control", if: :render_bookmarks_control?)
    config.add_show_tools_partial(:citation)

    config.add_nav_action(:bookmark, partial: "blacklight/nav/bookmark", if: :render_bookmarks_control?)

    # solr field configuration for document/show views
    config.show.title_field = "title_tsim"
    config.show.display_type_field = "format"

    # scxxx Thumbnails
    config.show.thumbnail_field = "thumbnail_path_ss"
    config.show.thumbnail_presenter = NlaThumbnailPresenter
    config.show.partials.insert(1, :thumbnail) # thumbnail after show_header

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    #
    # set :index_range to true if you want the facet pagination view to have facet prefix-based navigation
    #  (useful when user clicks "more" on a large facet and wants to navigate alphabetically across a large set of results)
    # :index_range can be an array or range of prefixes that will be used to create the navigation (note: It is case sensitive when searching values)

    config.add_facet_field "format", label: "Format", limit: 20
    config.add_facet_field "pub_date_ssim", label: "Publication Year", single: true
    config.add_facet_field "author_ssim", label: "Author", limit: true, index_range: "A".."Z"
    config.add_facet_field "subject_ssim", label: "Subject", limit: 20, index_range: "A".."Z"
    config.add_facet_field "language_ssim", label: "Language", limit: true
    config.add_facet_field "austlang_ssim", label: "Aboriginal and Torres Strait Islander Language", limit: 10
    config.add_facet_field "lc_1letter_ssim", label: "Call Number"
    config.add_facet_field "geographic_name_ssim", label: "Geographic", limit: true, index_range: "A".."Z"
    config.add_facet_field "series_ssim", label: "Series", limit: true, index_range: "A".."Z", single: true
    config.add_facet_field "subject_era_ssim", label: "Era"
    config.add_facet_field "access_ssim", label: "Access"
    config.add_facet_field "decade_isim",
      label: "Decade",
      include_in_advanced_search: false,
      range: {
        num_segments: 6,
        assumed_boundaries: nil,
        segments: true,
        maxlength: 4
      }

    # config.add_facet_field "example_pivot_field", label: "Pivot Field", pivot: %w[format language_ssim], collapsing: true

    config.add_facet_field "example_query_facet_field", label: "Publish Date", query: {
      years_5: {label: "within 5 Years", fq: "pub_date_ssim:[#{Time.zone.now.year - 5} TO *]"},
      years_10: {label: "within 10 Years", fq: "pub_date_ssim:[#{Time.zone.now.year - 10} TO *]"},
      years_25: {label: "within 25 Years", fq: "pub_date_ssim:[#{Time.zone.now.year - 25} TO *]"}
    }

    config.add_facet_field "parent_id_ssi", label: "In Collection", limit: true, include_in_simple_select: false, include_in_advanced_search: false, show: false
    config.add_facet_field "collection_id_ssi", label: "Collection", limit: true, include_in_simple_select: false, include_in_advanced_search: false, show: false

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field "title_tsim", label: "Title"
    config.add_index_field "author_with_relator_ssim", label: "Author"
    config.add_index_field "format", label: "Format"
    config.add_index_field "language_ssim", label: "Language"
    config.add_index_field "call_number_ssim", label: "Call number"

    # scxxx
    # test display addition
    # config.add_index_field "subject-nla_tsim", label: "NLA Subject on results"
    # config.add_index_field "650ayzv", label: "Subjectus", field: "id", helper_method: :from_marc
    # config.add_index_field 'availability', label: 'Availability', helper_method: :available?

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    config.add_show_field "id", label: "Bib ID", field: "id"
    config.add_show_field field: "format", label: "Format"
    config.add_show_field "form_of_work", label: "Form of work", accessor: :form_of_work, helper_method: :list
    config.add_show_field "author", field: "author_with_relator_ssim", label: "Author", helper_method: :author_search_list
    config.add_show_field "translated_title", label: "Translated Title", accessor: :translated_title
    config.add_show_field "uniform_title", label: "Uniform Title", accessor: :uniform_title
    config.add_show_field "online_access", label: "Online Access", accessor: :online_access, helper_method: :url_list
    config.add_show_field "map_search", label: "Online Version", accessor: :map_search, helper_method: :map_search
    config.add_show_field "copy_access", label: "Online Version", accessor: :copy_access, helper_method: :url_list
    config.add_show_field "related_access", label: "Related Online Resources", accessor: :related_access, helper_method: :url_list
    config.add_show_field "edition", label: "Edition", accessor: :edition, helper_method: :list
    config.add_show_field "access_conditions", label: "Access Conditions", accessor: :access_conditions, helper_method: :emphasized_list
    config.add_show_field "scale", label: "Scale", accessor: :scale
    config.add_show_field "printer", label: "Printer", accessor: :printer, helper_method: :unstyled_list
    config.add_show_field label: "Description", field: "description", accessor: :description, helper_method: :unstyled_list
    config.add_show_field "isbn", label: "ISBN", accessor: :isbn, helper_method: :unstyled_list
    config.add_show_field "invalid_isbn", label: "Invalid ISBN", accessor: :invalid_isbn, helper_method: :unstyled_list
    config.add_show_field "issn", label: "ISSN", accessor: :issn
    config.add_show_field "invalid_issn", label: "Invalid ISSN", accessor: :invalid_issn, helper_method: :unstyled_list
    config.add_show_field "ismn", label: "ISMN", accessor: :ismn
    config.add_show_field "invalid_ismn", label: "Invalid ISMN", accessor: :invalid_ismn, helper_method: :unstyled_list
    config.add_show_field "series", label: "Series", accessor: :series, helper_method: :list
    config.add_show_field "technical_details", label: "Technical Details", accessor: :technical_details, helper_method: :unstyled_list
    config.add_show_field "summary", label: "Summary", accessor: :summary, helper_method: :paragraphs
    config.add_show_field "full_contents", label: "Full contents", accessor: :full_contents, helper_method: :list
    config.add_show_field "partial_contents", label: "Partial contents", accessor: :partial_contents, helper_method: :list
    config.add_show_field "incomplete_contents", label: "Incomplete contents", accessor: :incomplete_contents, helper_method: :list
    config.add_show_field "credits", label: "Credits", accessor: :credits, helper_method: :unstyled_list
    config.add_show_field "performers", label: "Performer", accessor: :performers, helper_method: :unstyled_list
    config.add_show_field "biography_history", label: "Biography/History", accessor: :biography_history, helper_method: :paragraphs
    config.add_show_field "numbering_note", label: "Numbering Note", accessor: :numbering_note, helper_method: :list
    config.add_show_field "data_quality", label: "Data Quality", accessor: :data_quality, helper_method: :unstyled_list
    config.add_show_field "notes", label: "Notes", accessor: :notes, helper_method: :notes
    config.add_show_field "binding", label: "Binding", accessor: :binding_information, helper_method: :unstyled_list
    config.add_show_field "related_material", label: "Related Material", accessor: :related_material, helper_method: :list
    config.add_show_field "provenance", label: "Source of Acquisition", accessor: :provenance, helper_method: :unstyled_list
    config.add_show_field "cited_in", label: "Cited In", accessor: :cited_in, helper_method: :unstyled_list
    config.add_show_field "reproduction", label: "Reproduction", accessor: :reproduction, helper_method: :unstyled_list
    config.add_show_field "has_supplement", label: "Has Supplement", accessor: :has_supplement, helper_method: :unstyled_list
    config.add_show_field "supplement_to", label: "Supplement To", accessor: :supplement_to, helper_method: :unstyled_list
    config.add_show_field "has_subseries", label: "Has Sub-series", accessor: :has_subseries, helper_method: :list
    config.add_show_field "subseries_of", label: "Sub-series Of", accessor: :subseries_of, helper_method: :unstyled_list
    config.add_show_field "later_title", label: "Later Title", accessor: :new_title, helper_method: :unstyled_list
    config.add_show_field "former_title", label: "Former Title", accessor: :old_title, helper_method: :unstyled_list
    config.add_show_field "related_title", label: "Related Title", accessor: :related_title, helper_method: :unstyled_list
    config.add_show_field "issued_with", label: "Issued With", accessor: :issued_with, helper_method: :unstyled_list
    config.add_show_field "frequency", label: "Frequency", accessor: :frequency, helper_method: :list
    config.add_show_field "previous_frequency", label: "Previous Frequency", accessor: :previous_frequency, helper_method: :list
    config.add_show_field "index_finding_aid_note", label: "Index/Finding Aid Note", accessor: :index_finding_aid_note, helper_method: :list
    config.add_show_field "awards", label: "Awards", accessor: :awards, helper_method: :unstyled_list
    config.add_show_field "subjects", label: "Subjects", field: "subject_ssim", helper_method: :subject_search_list
    config.add_show_field "occupation", label: "Occupation", accessor: :occupation, helper_method: :occupation_search_list
    config.add_show_field "genre", label: "Form/genre", accessor: :genre, helper_method: :genre_search_list
    config.add_show_field "place", label: "Place", accessor: :place, helper_method: :list
    config.add_show_field "other_authors", label: "Other authors/contributors", accessor: :other_authors, helper_method: :other_author_search_list
    config.add_show_field "also_titled", label: "Also Titled", accessor: :also_titled, helper_method: :list
    config.add_show_field "terms_of_use", label: "Terms of Use", accessor: :terms_of_use, helper_method: :emphasized_list
    config.add_show_field "available_from", label: "Available From", accessor: :available_from, helper_method: :unstyled_list
    config.add_show_field "acknowledgement", label: "Acknowledgement", accessor: :acknowledgement, helper_method: :unstyled_list
    config.add_show_field "exhibited", label: "Exhibited", accessor: :exhibited, helper_method: :list
    config.add_show_field "govt_doc_number", label: "Govt. Doc. Number", accessor: :govt_doc_number, helper_method: :list
    config.add_show_field "music_publisher_number", label: "Music Publisher Number", accessor: :music_publisher_number, helper_method: :list
    config.add_show_field "related_records", label: "Related Records", accessor: :related_records, helper_method: :render_related_records_component
    config.add_show_field "rights_information", label: "Rights information", accessor: :rights_information, helper_method: :url_list, component: StaffOnlyComponent
    config.add_show_field "copyright_info", label: "Copyright", accessor: :copyright_status, helper_method: :render_copyright_component
    # config.add_show_field "title_tsim", label: "Title"
    # config.add_show_field "title_vern_ssim", label: "Title"
    # config.add_show_field "subtitle_tsim", label: "Subtitle"
    # config.add_show_field "subtitle_vern_ssim", label: "Subtitle"
    # config.add_show_field "author_vern_ssim", label: "Author"
    # config.add_show_field "url_fulltext_ssim", label: "URL"
    # config.add_show_field "url_suppl_ssim", label: "More Information"
    # config.add_show_field "language_ssim", label: "Language"
    # config.add_show_field "published_ssim", label: "Published"
    # config.add_show_field "published_vern_ssim", label: "Published"
    # config.add_show_field "lc_callnum_ssim", label: "Call number"
    # config.add_show_field "isbn_ssim", label: "ISBN"

    # scxxx
    # test display addition - TODO pull into extension module
    # config.add_show_field 'subject-nla_tsim', label: 'NLA Subject on single'
    # config.add_show_field "245abnps", label: "Full title", field: "id", helper_method: :from_marc
    # config.add_show_field "650ayzv", label: "Subjectus", field: "id", helper_method: :from_marc
    # config.add_show_field "020aq", label: "ISBN", field: "id", helper_method: :from_marc
    # config.add_show_field "880aq", label: "ISBN (880)", field: "id", helper_method: :from_marc
    # config.add_show_field "856u", label: "Link", field: "id", helper_method: :from_marc

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field "all_fields", label: "All Fields"

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    config.add_search_field("title") do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        "spellcheck.dictionary": "title",
        qf: "title_search_tsim",
        pf: "title_search_tsim"
      }
    end

    config.add_search_field("author") do |field|
      field.solr_parameters = {
        "spellcheck.dictionary": "author",
        qf: "author_search_tesim",
        pf: "author_search_tesim"
      }
    end

    config.add_search_field("subject_ssim") do |field|
      field.label = "Subject"
      field.qt = "search"
    end

    config.add_search_field("call_number") do |field|
      field.label = "Call Number"
      field.solr_parameters = {
        qf: "call_number_tsim",
        pf: "call_number_tsim"
      }
    end

    config.add_search_field("isbn") do |field|
      field.label = "ISBN/ISSN"
      field.solr_parameters = {
        qf: "isbn_tsim",
        pf: "isbn_tsim"
      }
    end

    config.add_search_field("id") do |field|
      field.label = "Bib Id"
      field.solr_parameters = {
        qf: "id",
        pf: "id"
      }
    end

    config.add_search_field("occupation") do |field|
      field.label = "Occupation"
      field.solr_parameters = {
        qf: "occupation_tesim",
        pf: "occupation_tesim"
      }
    end

    config.add_search_field("genre") do |field|
      field.label = "Genre"
      field.solr_parameters = {
        qf: "genre_tesim",
        pf: "genre_tesim"
      }
    end

    config.add_search_field("in_collection") do |field|
      field.label = "In Collection"
      field.solr_parameters = {
        qf: "parent_id_ssi",
        pf: "parent_id_ssi"
      }
      field.include_in_simple_select = false
      field.include_in_advanced_search = false
    end

    config.add_search_field("collection") do |field|
      field.label = "Collection"
      field.solr_parameters = {
        qf: "collection_id_ssi",
        pf: "collection_id_ssi"
      }
      field.include_in_simple_select = false
      field.include_in_advanced_search = false
    end

    # scxxx
    # config.add_search_field("subject-nla") do |field|
    #   field.solr_parameters = {
    #     # 'spellcheck.dictionary': 'subject',
    #     qf: "${subject-nla_qf}",
    #     pf: "${subject-nla_pf}"
    #   }
    # end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the Solr field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case). Add the sort: option to configure a
    # custom Blacklight url parameter value separate from the Solr sort fields.
    config.add_sort_field "score desc, pub_date_ssim desc, title_ssim asc", label: "relevance"
    config.add_sort_field "pub_date_ssim desc, title_ssim asc", label: "year"
    config.add_sort_field "author_si asc, title_ssim asc", label: "author"
    config.add_sort_field "title_ssim asc, pub_date_ssim desc", label: "title"

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    #
    # The spelling component uses a "less than or equal to" comparison against this number,
    # so it actually needs to be 1 less than the lowest number of results otherwise, suggestions
    # will be shown.
    config.spell_max = 0

    # Configuration for autocomplete suggester
    config.autocomplete_enabled = true
    config.autocomplete_path = "suggest"
    # if the name of the solr.SuggestComponent provided in your solrconfig.xml is not the
    # default 'mySuggester', uncomment and provide it below
    # config.autocomplete_suggester = 'mySuggester'
  end

  def offsite
    url = params[:url]

    unless url.match?(/^https?:\/\/.*/)
      raise t("offsite.invalid_url", url: url)
    end

    @eresource = Eresources.new.known_url(url)

    if @eresource.present?
      if helpers.user_type == :local || helpers.user_type == :staff
        # let them straight through
        return redirect_to url, allow_other_host: true
      elsif @eresource[:entry]["remoteaccess"] == "yes"
        # already logged in
        if current_user.present?
          return redirect_to @eresource[:url], allow_other_host: true if @eresource[:type] == "remoteurl"

          # sorry for this.  EZProxy really needs a URL rewrite function.
          return redirect_to EzproxyUrl.new("http://yomiuri:1234/rekishikan/").url, allow_other_host: true if url == "https://database.yomiuri.co.jp/rekishikan/"

          return redirect_to EzproxyUrl.new(@eresource[:url]).url, allow_other_host: true
        else
          info_msg = if @eresource[:entry]["title"].strip.casecmp? "ebsco"
            t("offsite.ebsco")
          else
            t("offsite.other", title: @eresource[:entry]["title"].strip)
          end

          return redirect_to new_user_session_url, flash: {alert: info_msg}
        end
      else
        @requested_url = url
        @record_url = solr_document_path(id: params[:id])
        return render "onsite_only"
      end
    end

    # if all else fails, redirect back to the same catalogue record page
    redirect_to solr_document_path(id: params[:id])
  end
end
