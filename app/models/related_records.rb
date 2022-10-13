class RelatedRecords
  include ActiveModel::Model

  attr_accessor :document

  def initialize(document)
    @document = document
  end

  def in_collection?
    parent_id.present? || collection_id.present?
  end

  def parent?
    parent_id.nil? && collection_id.present?
  end

  def child?
    parent_id.present? && collection_id.nil?
  end

  def collection_url

  end

  def has_children?
    true
  end

  def collection_name_label
    title = document.get_marc_derived_field("773iabdghkmnopqrstuxyz34678")
    title = document.get_marc_derived_field("973iabdghkmnopqrstuxyz34678") if title.blank?
    title.join
  end

  private

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
end
