# frozen_string_literal: true

require "traject"

# Represents a single document returned from Solr
class SolrDocument
  prepend MemoWise

  include Blacklight::Solr::Document
  include Blacklight::Configurable
  include ActiveSupport::Rescuable

  rescue_from KeyError, with: :key_error_handler

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
          result = []
          response["docs"].each do |doc|
            result << {id: doc["id"], title: doc["title_tsim"].first}
          end
          result
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

  def get_marc_datafields_from_xml(xpath)
    marc_xml.xpath(xpath).presence
  end

  # Get data from the full marc record contained in the solr document using a Traject spec.
  def get_marc_derived_field(spec, options: {})
    data = Traject::MarcExtractor.cached(spec, options).extract(marc_rec)
    data.presence
  end

  attribute :access_conditions, :array, "access_conditions_ssim"
  attribute :acknowledgement, :array, "acknowledgement_tsim"
  attribute :all_authors, :array, "author_search_tsim"
  attribute :also_titled, :array, "also_titled_tsim"
  attribute :anchored_title, :string, "anchored_title_only_tsi"
  attribute :available_from, :array, "available_from_tsim"
  attribute :awards, :array, "awards_tsim"
  attribute :binding_information, :array, "binding_tsim"
  attribute :biography_history, :array, "biography_history_tsim"
  attribute :callnumber, :array, "lc_callnum_ssim"
  attribute :cited_in, :array, "cited_in_tsim"
  attribute :credits, :array, "credits_tsim"
  attribute :data_quality, :array, "data_quality_tsim"
  attribute :description_date, :array, "description_date_tsim"
  attribute :description_fields, :array, "description_tsim"
  attribute :edition, :array, "edition_tsim"
  attribute :exhibited, :array, "exhibited_tsim"
  attribute :form_of_work, :array, "form_of_work_tsim"
  attribute :frequency, :array, "frequency_tsim"
  attribute :full_contents, :array, "full_contents_tsim"
  attribute :genre, :array, "genre_tsim"
  attribute :govt_doc_number, :array, "govt_doc_number_tsim"
  attribute :has_subseries, :array, "has_subseries_tsim"
  attribute :has_supplement, :array, "has_supplement_tsim"
  attribute :incomplete_contents, :array, "incomplete_contents_tsim"
  attribute :indexing_finding_aid_note, :array, "index_finding_aid_note_tsim"
  attribute :invalid_issn, :array, "invalid_issn_ssim"
  attribute :invalid_ismn_ssim, :array, "invalid_ismn_ssim"
  attribute :isbn, :array, "isbn_display_ssim"
  attribute :ismn, :array, "ismn_ssim"
  attribute :issn, :array, "issn_display_ssim"
  attribute :issued_with, :array, "issued_with_tsim"
  attribute :lccn, :array, "lccn_ssim"
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
  attribute :publication_date, :array, "pub_date_ssim"
  attribute :publisher, :array, "publisher_tsim"
  attribute :related_material, :array, "related_material_tsim"
  attribute :related_title, :array, "related_title_tsim"
  attribute :reproduction, :array, "reproduction_tsim"
  attribute :scale, :array, "scale_tsim"
  attribute :series, :array, "series_tsim"
  attribute :subseries_of, :array, "subseries_of_tsim"
  attribute :summary, :array, "summary_tsim"
  attribute :supplement_to, :array, "supplement_to_tsim"
  attribute :technical_details, :array, "technical_details_tsim"
  attribute :terms_of_use, :array, "terms_of_use_tsim"
  attribute :time_coverage_multiple, :array, "time_coverage_multiple_ssim"
  attribute :time_coverage_ranged, :array, "time_coverage_range_ssim"
  attribute :time_coverage_single, :array, "time_coverage_single_ssim"
  attribute :translated_title, :array, "translated_title_ssim"
  attribute :uniform_title, :array, "uniform_title_ssim"

  def broken_links
    get_search_links
  end
  memo_wise :broken_links

  def broken_links?
    broken_links.present?
  end

  def clean_isn(isn)
    isn = isn.gsub(/[\s-]+/, '\1')
    isn = isn.gsub(/^.*?([0-9]+).*?$/, '\1')
    isn.gsub(/\s+/, "")
  end

  def copy_access
    get_copy_urls
  end

  def copyright_status
    # If no copyright info returned from the SOA
    # don't show the component.
    CopyrightStatus.new(self).value.presence
  end
  memo_wise :copyright_status

  def description
    date_fields_array = description_date
    description_fields_array = description_fields
    if date_fields_array.present?
      date_fields_array.map do |s|
        s.gsub!(/[, .\\;]*$|^[, .\/;]*/, "") || s
      end
      if description_fields_array.present?
        date_fields_array.concat(description_fields_array)
      end
      date_fields_array.compact_blank.presence
    elsif description_fields_array.present?
      description_fields_array.compact_blank.presence
    end
  end
  memo_wise :description

  def finding_aid_url
    sub_z = get_marc_derived_field("856z")&.first&.downcase
    sub_3 = get_marc_derived_field("8563")&.first&.downcase
    if (sub_z.present? && sub_z.include?("finding aid")) || (sub_3.present? && sub_3.include?("finding aid"))
      get_marc_derived_field("856u")&.first
    end
  end

  def has_eresources?
    eresource_urls = []

    online_access_urls = get_online_access_urls
    online_access_urls&.each do |url|
      eresource_urls << url if Eresources.new.known_url(url[:href]).present?
    end

    map_url = get_map_search_url
    if map_url.present?
      eresource_urls << map_url.first if Eresources.new.known_url(map_url.first).present?
    end

    copy_urls = get_copy_urls
    copy_urls&.each do |url|
      eresource_urls << url if Eresources.new.known_url(url[:href]).present?
    end

    related_urls = get_related_urls
    related_urls&.each do |url|
      eresource_urls << url if Eresources.new.known_url(url[:href]).present?
    end

    eresource_urls.compact_blank.present?
  end
  memo_wise :has_eresources?

  def invalid_isbn
    get_isbn(tag: "020", sfield: "z", qfield: "q", use_880: true)
  end

  def map_search
    get_map_search_url
  end
  memo_wise :map_search

  def online_access
    get_online_access_urls
  end

  def publication_place
    data = fetch("display_publication_place_ssim", nil)
    if data.present?
      publication_place = data.join(" ")
      if publication_place.end_with?(":")
        publication_place.chop!
      end
      publication_place.strip
    end
  end
  memo_wise :publication_place

  def related_access
    get_related_urls
  end

  def related_records
    get_related_records
  end
  memo_wise :related_records

  def rights_information
    [{text: "View in Sprightly", href: "https://sprightly.nla.gov.au/works/#{id}?source=catalogue"}]
  end

  def time_coverage
    if time_coverage_single.present?
      time_coverage_single
    elsif time_coverage_multiple.present?
      [time_coverage_multiple.join(", ")]
    elsif time_coverage_ranged.present?
      [time_coverage_ranged.join("-")]
    end
  end

  def title_start
    anchored_title&.gsub(/(FINLLFIIJQ|AICULEDSSUL|\[|\]|\s+)/, "")
  end

  protected

  def key_error_handler
    nil
  end

  private

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
    end
  end

  def format_contents(data)
    contents = []

    data&.each do |content|
      content.split("--").map(&:strip).map do |c|
        contents << c
      end
    end

    contents.compact_blank.presence
  end

  def get_copy_urls
    elements = get_marc_datafields_from_xml("//datafield[@tag='856' and (@ind2='1' or (@ind2!='0' and @ind2!='2'))]")
    make_url(elements)
  end

  def get_isbn(tag:, sfield:, qfield:, use_880: false)
    elements = get_marc_datafields_from_xml("//datafield[@tag='#{tag}' and subfield[@code='#{sfield}']]")
    isbn = [*extract_isbn(elements: elements, tag: tag, sfield: sfield, qfield: qfield)]
    if use_880
      elements_880 = get_marc_datafields_from_xml("//datafield[@tag='880' and subfield[@code='6' and starts-with(.,'#{tag}-')]]")
      isbn += [*extract_isbn(elements: elements_880, tag: tag, sfield: sfield, qfield: qfield)]
    end
    isbn.compact_blank.presence
  end

  def get_map_search_url
    url = MapSearchService.new.determine_url(id: id, format: fetch("format"))
    if url.present?
      [url]
    end
  rescue KeyError
    Rails.logger.info "Record #{id} has no 'format'"
    nil
  end

  def get_online_access_urls
    elements = get_marc_datafields_from_xml("//datafield[@tag='856' and @ind2='0']")
    make_url(elements)
  end

  def get_related_records
    ids = get_marc_derived_field("0359")
    collection_id = ids&.first

    related_records = []

    # Check for related collections in the 773 subfield
    related_773_records = []
    related_773 = get_marc_derived_field("773w")
    related_773&.each do |r|
      rec = RelatedRecords.new(self, collection_id, "773", r)
      related_773_records << rec if rec.in_collection?
    end

    # Check for related collections in the 973 subfield
    related_973_records = []
    related_973 = get_marc_derived_field("973w")
    related_973&.each do |r|
      rec = RelatedRecords.new(self, collection_id, "973", r)
      related_973_records << rec if rec.in_collection?
    end

    # If there are no 973 or 773 records, but there is a collection ID, then this could be a
    # parent collection.
    if related_773_records.blank? && related_973_records.blank?
      related_records << RelatedRecords.new(self, collection_id, nil, nil)
    else
      related_records += related_773_records
      related_records += related_973_records
    end

    if related_records.present?
      # Check if any of any of the collections this record belongs to is really a collection,
      # because it's possible for a parent collection not to have any children.
      visible = !related_records.find { |rec| rec.in_collection? }.nil?

      # There is at least one collection, so let's render the Related Records section
      return related_records if visible
    end

    # Record is not part of any collection, return an empty array
    nil
  end

  def get_related_urls
    elements = get_marc_datafields_from_xml("//datafield[@tag='856' and @ind2='2']")
    make_url(elements)
  end

  def get_search_links
    SearchLink.new(self).links
  end

  def make_url(elements)
    if elements.present?
      urls = []
      elements.each do |el|
        url_hash = {}
        el.children.each do |subfield|
          subfield_code = subfield.attribute("code").value
          if subfield_code == "3" || subfield_code == "z"
            url_hash[:text] = subfield.text if url_hash[:text].nil?
          elsif subfield_code == "u"
            url_hash[:href] = subfield.text
          end
        end
        if url_hash[:text].nil?
          url_hash[:text] = url_hash[:href]
        end
        urls << url_hash unless url_hash[:href].nil?
      end
      urls.compact_blank.presence
    end
  end
end
