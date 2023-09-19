# frozen_string_literal: true

class RelatedRecords
  prepend MemoWise

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
    (@collection_id.present? && has_children?) || @parent_id.present?
  end
  memo_wise :in_collection?

  def collection_name
    @collection_name = derive_collection_name
  end
  memo_wise :collection_name

  def derive_collection_name
    title = []

    if @subfield == "773"
      title_773 = document.get_marc_derived_field("773abdghkmnopqrstuxyz34678w")
      title_773.each do |t|
        if t.include?(@parent_id)
          title << t.delete_suffix(" #{@parent_id}")
        end
      end
    end

    if @subfield == "973"
      title_973 = document.get_marc_derived_field("973abdghkmnopqrstuxyz34678w")
      title_973.each do |t|
        if t.include?(@parent_id)
          title << t.delete_suffix(" #{@parent_id}")
        end
      end
    end

    title.compact_blank.join.presence
  end

  def has_parent?
    parent.present?
  end

  def has_children?
    child_count > 0
  end

  def parent
    @parent ||= fetch_parent
  end

  def child_count
    @child_count ||= fetch_child_count
  end

  def sibling_count
    @sibling_count ||= fetch_sibling_count
  end

  def clean_id(id)
    id&.gsub(/[[:space:]]/, "")
  end

  private

  def fetch_count(id)
    Rails.cache.fetch("related_records_count/#{id}", expires_in: 15.minutes) do
      search_service = Blacklight.repository_class.new(blacklight_config)
      response = search_service.search(
        q: "parent_id_ssim:\"#{clean_id(id)}\"",
        rows: 0
      )
      if response.present? && response["response"].present?
        response["response"]["numFound"]
      else
        0
      end
    end
  end

  def fetch_child_count
    fetch_count(@collection_id)
  end

  def fetch_sibling_count
    fetch_count(@parent_id)
  end

  def fetch_parent
    if @parent_id.present?
      Rails.cache.fetch("related_records_parent/#{@parent_id}", expires_in: 15.minutes) do
        search_service = Blacklight.repository_class.new(blacklight_config)
        response = search_service.search(
          q: "collection_id_ssim:\"#{clean_id(@parent_id)}\"",
          fl: "id,title_tsim",
          sort: "score desc, pub_date_si desc, title_si asc",
          rows: 1
        )
        if response.present? && response["response"].present?
          response["response"]["docs"].map do |doc|
            {id: doc["id"], title: doc["title_tsim"]}
          end
        end
      end
    end
  end
end
