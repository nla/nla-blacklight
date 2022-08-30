# frozen_string_literal: true

require "traject"
require "rexml/document"
require "rexml/xpath"

require "#{::Rails.root}/lib/mapsearch/map_search"

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
    @online_access ||= get_online_access_urls
  end

  def copy_access
    @copy_access ||= get_copy_urls
  end

  def related_access
    @related_access ||= get_related_urls
  end

  def broken_links
    @broken_links ||= get_search_links
  end

  def has_broken_links?
    broken_links.present?
  end

  def map_search
    @map_search ||= get_map_search_url
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
    end
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
end
