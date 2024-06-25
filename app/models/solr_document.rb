# frozen_string_literal: true

require "traject"

# Represents a single document returned from Solr
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Configurable
  include ActiveSupport::Rescuable

  rescue_from KeyError, with: :key_error_handler

  # The following shows how to setup this blacklight document to display marc documents
  extension_parameters[:marc_source_field] = :marc_ss
  extension_parameters[:marc_format_type] = :marcxml
  use_extension(Nla::Marc::DocumentExtension) do |document|
    document.key?(SolrDocument.extension_parameters[:marc_source_field])
  end

  field_semantics.merge!(
    title: "title_tsim",
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
    Rails.cache.fetch("mlt/#{id}", expires_in: 1.day) do
      params = {
        q: "{!mlt qf=call_number_tsim,title_tsim,author_search_tsim,subject_tsimv,published_ssim,language_ssim boost=true}#{id}",
        fl: "id,title_tsim,format",
        indent: "off",
        rows: 5
      }
      search_repository = Blacklight.repository_class.new(blacklight_config)
      search_response = search_repository.search(params)

      response = search_response["response"]
      if response.present?
        if response["numFound"] > 0
          response["docs"].map do |doc|
            {id: doc["id"], title: doc["title_tsim"].first}
          end
        end
      end
    end
  end

  def marc_rec
    @marc_rec ||= to_marc
  end

  def marc_xml
    @marc_xml ||= Nokogiri::XML.parse(fetch("marc_ss")).remove_namespaces!
  end

  delegate :related_access_urls, :copy_access_urls, :online_access_urls, :map_search_urls, :has_eresources?, to: :access
  delegate :valid_isbn, :invalid_isbn, :isbn_list, :issn_list, to: :isbn

  attribute :acknowledgement, :array, "acknowledgement_tsim"
  attribute :all_authors, :array, "author_search_tsim"
  attribute :also_titled, :array, "also_titled_tsim"
  attribute :anchored_title, :string, "anchored_title_only_tsi"
  attribute :available_from, :array, "available_from_tsim"
  attribute :awards, :array, "awards_tsim"
  attribute :binding_information, :array, "binding_tsim"
  attribute :biography_history, :array, "biography_history_tsim"
  attribute :callnumber, :array, "call_number_tsim"
  attribute :cited_authors, :array, "cited_authors_tsim"
  attribute :cited_in, :array, "cited_in_tsim"
  attribute :copyright_info, :array, "copyright_ssim"
  attribute :credits, :array, "credits_tsim"
  attribute :data_quality, :array, "data_quality_tsim"
  attribute :description_date, :array, "description_date_tsim"
  attribute :description_fields, :array, "description_tsim"
  attribute :edition, :array, "edition_tsim"
  attribute :exhibited, :array, "exhibited_tsim"
  attribute :finding_aid_url, :string, "finding_aid_url_ssim"
  attribute :form_of_work, :array, "form_of_work_tsim"
  attribute :frequency, :array, "frequency_tsim"
  attribute :full_contents, :array, "full_contents_tsim"
  attribute :genre, :array, "genre_tsim"
  attribute :govt_doc_number, :array, "govt_doc_number_tsim"
  attribute :has_subseries, :array, "has_subseries_tsim"
  attribute :has_supplement, :array, "has_supplement_tsim"
  attribute :incomplete_contents, :array, "incomplete_contents_tsim"
  attribute :index_finding_aid_note, :array, "index_finding_aid_note_tsim"
  attribute :invalid_issn, :array, "invalid_issn_ssim"
  attribute :issn, :array, "issn_display_ssim"
  attribute :issued_with, :array, "issued_with_tsim"
  attribute :language, :array, "language_ssim"
  attribute :life_dates, :array, "life_dates_tsim"
  attribute :music_publisher_number, :array, "music_publisher_number_tsim"
  attribute :new_title, :array, "new_title_tsim"
  attribute :notes, :array, "notes_tsim"
  attribute :numbering_note, :array, "numbering_note_tsim"
  attribute :occupation, :array, "occupation_ssim"
  attribute :old_title, :array, "old_title_tsim"
  attribute :other_authors, :array, "additional_author_with_relator_ssim"
  attribute :partial_contents, :array, "partial_contents_tsim"
  attribute :performers, :array, "performers_tsim"
  attribute :pi, :string, "nlaobjid_ss"
  attribute :place, :array, "place_tsim"
  attribute :previous_frequency, :array, "previous_frequency_tsim"
  attribute :printer, :array, "printer_tsim"
  attribute :provenance, :array, "provenance_tsim"
  attribute :publication_date, :array, "display_publication_date_ssim"
  attribute :publisher, :array, "publisher_tsim"
  attribute :related_material, :array, "related_material_tsim"
  attribute :related_title, :array, "related_title_tsim"
  attribute :reproduction, :array, "reproduction_tsim"
  attribute :scale, :array, "scale_tsim"
  attribute :series, :array, "series_tsim"
  attribute :subseries_of, :array, "subseries_of_tsim"
  attribute :summary, :array, "summary_tsim"
  attribute :supplement_to, :array, "supplement_to_tsim"
  attribute :system_control_number, :array, "system_control_number_tsim"
  attribute :technical_details, :array, "technical_details_tsim"
  attribute :terms_of_use, :array, "terms_of_use_tsim"
  attribute :time_coverage_multiple, :array, "time_coverage_multiple_ssim"
  attribute :time_coverage_ranged, :array, "time_coverage_range_ssim"
  attribute :time_coverage_single, :array, "time_coverage_single_ssim"
  attribute :title_start, :array, "title_start_tsim"
  attribute :translated_title, :array, "translated_title_ssim"
  attribute :uniform_title, :array, "uniform_title_ssim"

  def access_conditions
    unless has_eresources?
      fetch("access_conditions_ssim", nil)
    end
  end

  def broken_links
    @search_link ||= SearchLink.new(self).value.presence
  end

  def copyright_status
    # If no copyright info returned from the SOA
    # don't show the component.
    @copyright_status ||= CopyrightStatus.new(self).value.presence
  end

  def description
    Description.new(self).value.presence
  end

  def invalid_ismn
    values = []

    fetch("invalid_ismn_ssim", nil)&.each do |ismn|
      values += ismn.split(" ")
    end

    values.presence
  end

  def ismn
    values = []

    fetch("ismn_ssim", nil)&.each do |ismn|
      values += ismn.split(" ")
    end

    values.presence
  end

  def lccn
    fetch("lccn_ssim", nil)&.map do |lccn|
      lccn.strip
    end
  end

  def publication_place
    @publication_place ||= PublicationPlace.new(self).value.presence
  end

  def related_records
    Collection.new(self).value.presence
  end

  def rights_information
    [{text: "View in Sprightly", href: "https://sprightly.nla.gov.au/works/#{id}?source=catalogue"}]
  end

  def time_coverage
    if time_coverage_single.present?
      clean_time_coverage(time_coverage_single)
    elsif time_coverage_multiple.present?
      [clean_time_coverage(time_coverage_multiple).join(", ")]
    elsif time_coverage_ranged.present?
      [clean_time_coverage(time_coverage_ranged).join("-")]
    end
  end

  protected

  def key_error_handler
    nil
  end

  private

  def access
    @access ||= Access.new(self)
  end

  def isbn
    @isbn ||= Isbn.new(self)
  end

  def clean_time_coverage(dates)
    dates&.map do |date|
      date&.delete_prefix("d")&.[](0..3)
    end
  end
end
