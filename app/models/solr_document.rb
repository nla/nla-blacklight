require "traject"
# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
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
  def get_marc_derived_field(spec, delimiter = ",")
    @marc_rec ||= to_marc
    extractor = Traject::MarcExtractor.cached(spec)
    extractor.extract(@marc_rec) * delimiter
  end

  def get_marc_derived_field_as_array(spec)
    @marc_rec ||= to_marc
    extractor = Traject::MarcExtractor.cached(spec)
    extractor.extract(@marc_rec)
  end

  def bib_id
    get_marc_derived_field("001")
  end

  def description
    date_fields_array = get_marc_derived_field_as_array("2603abc:264|*0|3abc:264|*1|3abc:264|*2|3abc:264|*4|3abc")
    description_fields_array = get_marc_derived_field_as_array("300abcefg:507ab:753abc:755axyz")
    date_fields_array.each do |s|
      s.gsub!(/[, .\\;]*$|^[, .\/;]*/, "")
    end
    date_fields_array.push(*description_fields_array) * ", "
  end
end
