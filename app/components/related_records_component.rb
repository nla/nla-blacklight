class RelatedRecordsComponent < Blacklight::MetadataFieldComponent
  def initialize(field:, layout: nil, show: false)
    super
  end

  def value
    @field.values.first
  end

  def render?
    value.present? && value.in_collection?
  end

  delegate :collection_count, :collection_name, :collection_id, :child_records, :parent_record, to: :value

  def formatted_collection_count
    count = collection_count
    number_with_delimiter(count, locale: I18n.locale)
  end

  def collection_url
    solr_document_path(id: parent_record.first[:id])
  end

  def collection_records_url
    search_catalog_path(search_field: "in_collection", q: "\"#{collection_id}\"")
  end
end
