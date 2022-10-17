class RelatedRecords
  include ActiveModel::Model
  include Blacklight::Configurable

  attr_accessor :document

  def initialize(document)
    @document = document
  end

  def parent_id
    document.fetch("parent_id_ssi")
  rescue KeyError
    nil
  end

  def collection_id
    document.fetch("collection_id_ssi")
  rescue KeyError
    nil
  end

  def parent?
    collection_id.present?
  end

  def child?
    parent_id.present?
  end

  def in_collection?
    child? || (parent? && has_children?)
  end

  def has_children?
    @child_count ||= fetch_child_count > 0
  end

  def collection_name_label
    title = document.get_marc_derived_field("773iabdghkmnopqrstuxyz34678")
    title = document.get_marc_derived_field("973iabdghkmnopqrstuxyz34678") if title.blank?
    title.join
  end

  private

  def fetch_child_count
    search_service = Blacklight.repository_class.new(blacklight_config)
    response = search_service.search(
      q: "parent_id_ssi:\"#{collection_id}\"",
      rows: 0
    )
    if response.present? && response["response"].present?
      response["response"]["numFound"]
    else
      0
    end
  end
end
