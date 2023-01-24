# frozen_string_literal: true

class RelatedRecordsComponent < ViewComponent::Base
  def initialize(records:)
    @related_records = records
  end

  def value
    @related_records
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
    if parent_record.present?
      solr_document_path(id: parent_record.first[:id])
    end
  end

  def collection_records_url
    if collection_id.present?
      search_catalog_path(search_field: "in_collection", q: "\"#{collection_id}\"")
    end
  end
end
