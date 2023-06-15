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

  def collection_url
    if collection_id.present?
      search_catalog_path(search_field: "in_collection", q: "\"#{collection_id}\"")
    end
  end

  def parent_url
    if parent.present?
      solr_document_path(id: parent.first[:id])
    else
      "#"
    end
  end

  def parent_collection_url
    if parent_id.present?
      search_catalog_path(search_field: "in_collection", q: "\"#{parent_id}\"")
    end
  end

  def formatted_collection_count
    count = child_count
    number_with_delimiter(count, locale: I18n.locale)
  end

  def formatted_sibling_count
    count = sibling_count
    number_with_delimiter(count, locale: I18n.locale)
  end

  delegate :collection_name, :collection_id, :parent, :parent_id, :child_count, :sibling_count, to: :value

  def hierarchy_class
    if value.has_parent? && value.has_children?
      "related-three-level"
    else
      "related-two-level"
    end
  end

  def icon_class
    if value.has_parent? && value.has_children?
      "three-level-child"
    elsif value.has_children?
      "two-level-parent"
    else
      "two-level-child"
    end
  end

  def collection_text
    text = []

    if value.has_parent? && value.has_children?
      text << helpers.t("related_records.parent_child_collection", url: parent_url, collection_name: collection_name)
      text << helpers.t("related_records.related_collection_total", url: parent_collection_url, total: formatted_sibling_count)
      text << helpers.t("related_records.collection_total", url: collection_url, total: formatted_collection_count)
    elsif value.has_children?
      text << helpers.t("related_records.parent_collection")
      text << helpers.t("related_records.collection_total", url: collection_url, total: formatted_collection_count)
    else
      text << helpers.t("related_records.child_collection", url: parent_url, collection_name: collection_name)
      text << helpers.t("related_records.collection_total", url: parent_collection_url, total: formatted_sibling_count)
    end

    # rubocop:disable Rails/OutputSafety
    text.join("<br>").html_safe
    # rubocop:enable Rails/OutputSafety
  end

  def base_icon
    if value.has_parent? && value.has_children?
      helpers.svg("related-records/3-child")
    elsif value.has_children?
      helpers.svg("related-records/2-parent")
    else
      helpers.svg("related-records/2-child")
    end
  end
end
