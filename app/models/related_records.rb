# frozen_string_literal: true

class RelatedRecords
  include ActiveModel::Model
  include Blacklight::Configurable

  attr_reader :document, :collection_id
  attr_accessor :parent_id, :subfield

  def initialize(marc_rec, collection_id, subfield, parent_id)
    @marc_rec = marc_rec
    @collection_id = collection_id
    @subfield = subfield
    @parent_id = parent_id
  end

  def in_collection?
    @in_collection ||= ((@collection_id.present? && has_children?) || @parent_id.present?)
  end

  def collection_name
    @collection_name ||= derive_collection_name
  end

  def has_parent?
    @has_parent ||= parent.present?
  end

  def has_children?
    @has_children ||= child_count > 0
  end

  def parent
    @parent ||= if @parent_id.present?
      Nla::RelatedRecordsService.new.fetch_parent(clean_id(@parent_id), blacklight_config)
    end
  end

  def child_count
    @child_count ||= Nla::RelatedRecordsService.new.fetch_count(clean_id(@collection_id), blacklight_config)
  end

  def sibling_count
    @sibling_count ||= Nla::RelatedRecordsService.new.fetch_count(clean_id(@parent_id), blacklight_config)
  end

  def clean_id(id)
    id&.gsub(/[[:space:]]/, "")
  end

  private

  def derive_collection_name
    title = []

    if @subfield == "773"
      title_773 = MarcDerivedField.instance.derive(@marc_rec, "773abdghkmnopqrstuxyz34678w")
      title_773.each do |t|
        if t.include?(@parent_id)
          title << t.delete_suffix(" #{@parent_id}")
        end
      end
    end

    if @subfield == "973"
      title_973 = MarcDerivedField.instance.derive(@marc_rec, "973abdghkmnopqrstuxyz34678w")
      title_973.each do |t|
        if t.include?(@parent_id)
          title << t.delete_suffix(" #{@parent_id}")
        end
      end
    end

    title.compact_blank.join.presence
  end
end
