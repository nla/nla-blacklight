# frozen_string_literal: true

require "traject"
require "rexml/document"
require "rexml/xpath"

require Rails.root.join("lib", "mapsearch", "map_search")

class SolrDocument
  include Blacklight::Solr::Document
  include REXML

  # The following shows how to setup this blacklight document to display marc documents
  extension_parameters[:marc_source_field] = :marc_ss
  extension_parameters[:marc_format_type] = :marcxml
  use_extension(Blacklight::Marc::DocumentExtension) do |document|
    document.key?(SolrDocument.extension_parameters[:marc_source_field])
  end

  field_semantics.merge!(
    title: "title_ssm",
    author: "author_ssm",
    language: "language_ssim",
    format: "format"
  )

  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  ##
  # Get data from the full marc record contained in the solr document using a Traject spec.
  def get_marc_derived_field(spec, options: {separator: " "})
    @marc_rec ||= to_marc
    extractor = Traject::MarcExtractor.cached(spec, options)
    extractor.extract(@marc_rec)
  end

  def marc_xml
    @marc_xml ||= to_marc_xml
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

  def copyright_info
    get_copyright_info
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
    printer = get_marc_derived_field("260efg")
    printer = get_marc_derived_field("2643abc") if printer.empty?
    merge_880 printer
  end

  def full_contents
    get_marc_derived_field("505|0*|agrtu:505|8*|agrtu")
  end

  def credits
    get_marc_derived_field("508a", options: {alternate_script: false})
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

  def get_copyright_info
    CopyrightInfo.new(self)
  end

  def get_uniform_title
    title = get_marc_derived_field("130aplskfmnor")
    title = get_marc_derived_field("240adfghklmnoprs") if title.empty?
    merge_880 title
  end

  def get_edition
    editions = get_marc_derived_field("250")
    merge_880 editions
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

  # `get_marc_derived_fields` when finding linked 880 fields, will prefix the
  # results array with the tag name and subfields.
  # We don't want to display the tag and subfields in the UI, so this will look for the first
  # space in the string after the prefix and strip these form all the elements in the
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
end
