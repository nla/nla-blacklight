# frozen_string_literal: true

require "blacklight"

class RelatedRecords
  include ActiveModel::Model
  include Blacklight::Configurable

  attr_reader :document, :collection_id
  attr_accessor :parent_id, :subfield

  def initialize(document, collection_id, subfield, parent_id)
    @document = document
    @collection_id = collection_id
    @subfield = subfield
    @parent_id = parent_id
  end

  def in_collection?
    @in_collection ||= (@collection_id.present? && has_children?) || @parent_id.present?
  end

  def collection_name
    @collection_name ||= derive_collection_name.presence
  end

  def has_parent?
    @has_parent ||= parent.present?
  end

  def has_children?
    @has_children ||= child_count > 0
  end

  def parent
    @parent ||= if @parent_id.present?
      RelatedRecordsService.new.fetch_parent(clean_id(@parent_id), blacklight_config)
    end
  end

  def child_count
    @child_count ||= RelatedRecordsService.new.fetch_count(clean_id(@collection_id), blacklight_config)
  end

  def sibling_count
    @sibling_count ||= RelatedRecordsService.new.fetch_count(clean_id(@parent_id), blacklight_config)
  end

  def clean_id(id)
    id&.gsub(/[[:space:]]/, "")
  end

  private

  def derive_collection_name
    collection_name = if @subfield == "773"
      title_773 = @document.fetch("title773_ssim", nil)
      if title_773.present?
        title_773.reduce([]) do |acc, title|
          acc << (title.include?(@parent_id) ? title.delete_suffix(" #{@parent_id}") : title)
        end
      end
    elsif @subfield == "973"
      title_973 = @document.fetch("title973_ssim", nil)
      if title_973.present?
        title_973.reduce([]) do |acc, title|
          acc << (title.include?(@parent_id) ? title.delete_suffix(" #{@parent_id}") : title)
        end
      end
    end

    collection_name&.compact_blank&.join
  end
end
