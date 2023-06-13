# frozen_string_literal: true

require "traject"
require "rexml/document"
require "rexml/xpath"

require Rails.root.join("lib", "mapsearch", "map_search")

class SolrDocument
  include Blacklight::Solr::Document
  include REXML
  include Blacklight::Configurable
  include Nla::Citations

  attribute :callnumber, Blacklight::Types::Array, "lc_callnum_ssim"

  # The following shows how to setup this blacklight document to display marc documents
  extension_parameters[:marc_source_field] = :marc_ss
  extension_parameters[:marc_format_type] = :marcxml
  use_extension(Nla::Marc::DocumentExtension) do |document|
    document.key?(SolrDocument.extension_parameters[:marc_source_field])
  end

  field_semantics.merge!(
    title: "title_ssm",
    author: "author_ssm",
    language: "language_ssim",
    format: "format"
  )

  # self.unique_key = 'id'

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Overrides Blacklight::Document#more_like_this. Uses the MLT query parser because the request
  # handler doesn't search across shards in Solr 8.7.
  # TODO: In Solr 8.8 the request handler searches across shards and this logic should be updated when Solr is upgraded.
  def more_like_this
    params = {
      q: "{!mlt qf=call_number_tsim,title_tsim,author_search_tsim,subject_tsimv,published_ssim,language_ssim boost=true}#{id}",
      fl: "id,title_tsim,format",
      indent: "off",
      rows: 5
    }
    search_repository = Blacklight.repository_class.new(blacklight_config)
    search_response = search_repository.search(params)

    result = []
    response = search_response["response"]
    if response.present?
      if response["numFound"] > 0
        response["docs"].each do |doc|
          result << SolrDocument.new(doc)
        end
      end
    end
    result
  end

  # Get data from the full marc record contained in the solr document using a Traject spec.
  def get_marc_derived_field(spec, options: {separator: " "}, merge_880: true)
    @marc_rec ||= to_marc
    extractor = Traject::MarcExtractor.cached(spec, options)
    data = extractor.extract(@marc_rec)
    if merge_880
      data = merge_880 data
    end
    data
  end

  # `get_marc_derived_fields` when finding linked 880 fields, will prefix the
  # results array with the tag name and subfields.
  # We don't want to display the tag and subfields in the UI, so this will look for the first
  # space in the string after the prefix and strip the prefixes from all the elements in the
  # results array.
  # Results which don't have linked 880 fields will not have the prefix, so we
  # return the datafields as a single dimensional array.
  def merge_880(datafields)
    if datafields.find { |d| d.start_with? "880" }.present?
      datafields.map do |d|
        d[d.index(" ")...-1].strip
      end
    else
      [*datafields]
    end
  end

  def marc_xml
    @marc_xml ||= to_marc_xml
  end

  def title_start
    get_marc_derived_field("245a", options: {alternate_script: false}).first
  end

  def description
    date_fields_array = get_marc_derived_field("2603abc:264|*0|3abc:264|*1|3abc:264|*2|3abc:264|*4|3abc")
    description_fields_array = get_marc_derived_field("300abcefg:507ab:753abc:755axyz")
    date_fields_array.each do |s|
      s.gsub!(/[, .\\;]*$|^[, .\/;]*/, "")
    end
    date_fields_array.push(*description_fields_array) * ", "
  end

  def online_access
    get_online_access_urls
  end

  def copy_access
    get_copy_urls
  end

  def related_access
    get_related_urls
  end

  def broken_links
    get_search_links
  end

  def has_broken_links?
    broken_links.present?
  end

  def map_search
    get_map_search_url
  end

  def get_marc_datafields_from_xml(xpath, xml_doc = marc_xml)
    REXML::XPath.match(xml_doc, xpath)
  end

  def series
    Series.new(self).values
  end

  def notes
    Notes.new(self).values
  end

  def copyright_status
    copyright_info ||= get_copyright_status

    # If no copyright info returned from the SOA
    # don't show the component.
    if copyright_info.info.present?
      copyright_info
    end
  end

  def form_of_work
    get_marc_derived_field("380a")
  end

  def translated_title
    get_marc_derived_field("242abchnp")
  end

  def uniform_title
    get_uniform_title
  end

  def edition
    get_edition
  end

  def access_conditions
    if has_eresources?
      []
    else
      get_marc_derived_field("506a3bcde", options: {alternate_script: false})
    end
  end

  def scale
    get_marc_derived_field("255abcdefg", options: {alternate_script: false})
  end

  def isbn
    get_isbn(tag: "020", sfield: "a", qfield: "q", use_880: true)
  end

  def isbn_list
    result = []
    if isbn.present?
      isbn.each do |isn|
        result << clean_isn(isn)
      end
    end
    result
  end

  def invalid_isbn
    get_isbn(tag: "020", sfield: "z", qfield: "q", use_880: true)
  end

  def issn
    get_marc_derived_field("022a", options: {alternate_script: false})
  end

  def invalid_issn
    get_marc_derived_field("022z", options: {alternate_script: false})
  end

  def ismn
    get_marc_derived_field("024|2*|a", options: {alternate_script: false})
  end

  def invalid_ismn
    get_marc_derived_field("024|2*|z", options: {alternate_script: false})
  end

  def related_records
    get_related_records
  end

  def printer
    get_marc_derived_field("260efg:264|*3|3abc")
  end

  def full_contents
    data = get_marc_derived_field("505|0*|agrtu:505|8*|agrtu")

    format_contents data
  end

  def technical_details
    get_marc_derived_field("538au", options: {alternate_script: false})
  end

  def summary
    get_marc_derived_field("520ab")
  end

  def partial_contents
    data = get_marc_derived_field("505|2*|agrtu")

    format_contents data
  end

  def incomplete_contents
    data = get_marc_derived_field("505|1*|agrtu")

    format_contents data
  end

  def credits
    get_marc_derived_field("508a", options: {alternate_script: false})
  end

  def performers
    get_marc_derived_field("511a", options: {alternate_script: false})
  end

  def biography_history
    get_marc_derived_field("545ab", options: {alternate_script: false})
  end

  def numbering_note
    get_marc_derived_field("515a", options: {alternate_script: false})
  end

  def data_quality
    get_marc_derived_field("514abcdefghijkmuz", options: {alternate_script: false})
  end

  def rights_information
    [{text: "View in Sprightly", href: "https://sprightly.nla.gov.au/works/#{id}?source=catalogue"}]
  end

  def binding_information
    get_marc_derived_field("563a")
  end

  def related_material
    get_marc_derived_field("544", options: {alternate_script: false})
  end

  def provenance
    get_marc_derived_field("541abcdefhno368:5613au", options: {alternate_script: false})
  end

  def govt_doc_number
    get_marc_derived_field("086a", options: {alternate_script: false})
  end

  def music_publisher_number
    get_marc_derived_field("028a", options: {alternate_script: false})
  end

  def exhibited
    get_marc_derived_field("5853a", options: {alternate_script: false})
  end

  def acknowledgement
    get_marc_derived_field("936a", options: {alternate_script: false})
  end

  def cited_in
    get_marc_derived_field("510abc")
  end

  def reproduction
    get_marc_derived_field("533abcdefmn")
  end

  def has_subseries
    get_marc_derived_field("762abistx", options: {alternate_script: false})
  end

  def subseries_of
    get_marc_derived_field("760abistx", options: {alternate_script: false})
  end

  def available_from
    get_marc_derived_field("037b", options: {alternate_script: false})
  end

  def awards
    get_marc_derived_field("586a", options: {alternate_script: false})
  end

  def related_title
    get_marc_derived_field("787abdistx")
  end

  def issued_with
    get_marc_derived_field("777abdistxz", options: {alternate_script: false})
  end

  def frequency
    get_marc_derived_field("310ab")
  end

  def previous_frequency
    get_marc_derived_field("321ab")
  end

  def index_finding_aid_note
    get_marc_derived_field("555a", options: {alternate_script: false})
  end

  def occupation
    get_marc_derived_field("656a", options: {alternate_script: false})
  end

  def genre
    get_marc_derived_field("655a", options: {alternate_script: false})
  end

  def place
    get_marc_derived_field("752abcd", options: {alternate_script: false})
  end

  def has_supplement
    get_marc_derived_field("770abistxz")
  end

  def supplement_to
    get_marc_derived_field("772abistxz")
  end

  def new_title
    get_marc_derived_field("785abdistxz")
  end

  def old_title
    get_marc_derived_field("247abfghnpx:780abdistx")
  end

  def also_titled
    get_marc_derived_field("246abfghinp")
  end

  def terms_of_use
    get_marc_derived_field("5403abcd", options: {alternate_script: false})
  end

  def other_authors
    fetch("additional_author_with_relator_ssim")
  rescue KeyError
    []
  end

  def lccn
    get_marc_derived_field("010a", options: {alternate_script: false})
  end

  def has_eresources?
    eresource_urls = []

    online_access_urls = get_online_access_urls
    online_access_urls.each do |url|
      eresource_urls << url if Eresources.new.known_url(url[:href]).present?
    end

    map_url = get_map_search_url
    if map_url.present?
      eresource_urls << map_url if Eresources.new.known_url(map_url[:href]).present?
    end

    copy_urls = get_copy_urls
    copy_urls.each do |url|
      eresource_urls << url if Eresources.new.known_url(url[:href]).present?
    end

    related_urls = get_related_urls
    related_urls.each do |url|
      eresource_urls << url if Eresources.new.known_url(url[:href]).present?
    end

    eresource_urls.present?
  end

  def clean_isn(isn)
    isn = isn.gsub(/[\s-]+/, '\1')
    isn.gsub(/^.*?([0-9]+).*?$/, '\1')
  end

  def publication_place
    data = get_marc_derived_field("260a", options: {alternate_script: false}) || get_marc_derived_field("264a", options: {alternate_script: false})
    if data.present?
      publication_place = data.join(" ")
      if publication_place.end_with?(":")
        publication_place = publication_place.chop.strip
      end
      publication_place
    end
  end

  def publisher
    data = get_marc_derived_field("260b", options: {alternate_script: false}) || get_marc_derived_field("264b", options: {alternate_script: false})
    if data.present?
      publisher = data.join(" ")
      if publisher.end_with?(",")
        publisher = publisher.chop.strip
      end
      publisher
    end
  end

  private

  def get_online_access_urls
    elements = get_marc_datafields_from_xml("//datafield[@tag='856' and @ind2='0']")
    make_url(elements)
  end

  def get_copy_urls
    elements = get_marc_datafields_from_xml("//datafield[@tag='856' and (@ind2='1' or (@ind2!='0' and @ind2!='2'))]")
    make_url(elements)
  end

  def get_related_urls
    elements = get_marc_datafields_from_xml("//datafield[@tag='856' and @ind2='2']")
    make_url(elements)
  end

  def get_map_search_url
    url = MapSearch.new.determine_url(id: id, format: fetch("format"))
    if url.present?
      [url]
    else
      []
    end
  rescue KeyError
    Rails.logger.info "Record #{id} has no 'format'"
    []
  end

  def to_marc_xml
    @marc_rec ||= to_marc
    @marc_rec.to_xml
  end

  def make_url(elements)
    urls = []
    elements.each do |el|
      url_hash = {text: "", href: ""}
      el.children.each do |subfield|
        subfield_code = subfield.attribute("code").value
        if subfield_code == "3" || subfield_code == "z"
          url_hash[:text] = subfield.text if url_hash[:text].empty?
        elsif subfield_code == "u"
          url_hash[:href] = subfield.text
        end
      end
      if url_hash[:text].empty?
        url_hash[:text] = url_hash[:href]
      end
      urls << url_hash unless url_hash[:href].empty?
    end
    urls
  end

  def get_search_links
    SearchLink.new(self).links
  end

  def get_copyright_status
    CopyrightStatus.new(self)
  end

  def get_uniform_title
    get_marc_derived_field("130aplskfmnor:240adfghklmnoprs")
  end

  def get_edition
    get_marc_derived_field("250")
  end

  def get_isbn(tag:, sfield:, qfield:, use_880: false)
    elements = get_marc_datafields_from_xml("//datafield[@tag='#{tag}' and subfield[@code='#{sfield}']]")
    isbn = [*extract_isbn(elements: elements, tag: tag, sfield: sfield, qfield: qfield)]
    if use_880
      elements_880 = get_marc_datafields_from_xml("//datafield[@tag='880' and subfield[@code='6' and starts-with(.,'#{tag}-')]]")
      isbn += [*extract_isbn(elements: elements_880, tag: tag, sfield: sfield, qfield: qfield)]
    end
    isbn.compact_blank
  end

  # Extracts ISBNs from MARC. The MARCXML must be read sequentially, where a single 020 tag may contain subfields like:
  # [$a, $q, $q, $z, $q] and only the first sequence of [$a, $q, $q] should be extracted.
  # The `sfield` parameter is the primary subfield and the `qfield` provides a qualifier field.
  def extract_isbn(elements:, tag: "020", sfield: "a", qfield: "q")
    if elements.present?
      isbn = []
      elements.each do |el|
        text = []
        primary_found = false
        prev_subfield_code = ""
        el.children.each do |subfield|
          subfield_code = subfield.attribute("code").value
          if subfield_code != sfield && subfield_code != qfield
            primary_found = false
            next
          elsif subfield_code == sfield
            if prev_subfield_code == subfield_code
              isbn << text.join(" ")
              text = []
            end
            # strip extra punctuation and spaces
            clean_text = subfield.text[/^.*?([0-9X]+).*?$/, 1]
            text << (clean_text.presence || subfield.text)
            primary_found = true
          elsif primary_found && qfield.present? && subfield_code == qfield
            # strip extra punctuation and spaces, then wrap with parentheses
            clean_text = subfield.text[/^\s*(\w*)\s*:*\s*$/, 1]
            text << if clean_text.present?
              "(#{clean_text})"
            else
              "(#{subfield.text})"
            end
          end
          prev_subfield_code = subfield_code
        end
        isbn << text.join(" ")
      end
      isbn
    else
      []
    end
  end

  def get_related_records
    related = RelatedRecords.new(self)
    related.in_collection? ? related : []
  end

  def format_contents(data)
    contents = []

    data&.each do |content|
      contents += content.split("--").map(&:strip)
    end

    contents
  end
end
