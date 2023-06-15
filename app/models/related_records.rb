class RelatedRecords
  include ActiveModel::Model
  include Blacklight::Configurable

  attr_reader :document, :collection_id
  attr_accessor :parent_id, :subfield

  def initialize(document, collection_id)
    @document = document
    @collection_id = collection_id
  end

  def in_collection?
    (@collection_id.present? && has_children?) || @parent_id.present?
  end

  def collection_name
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

    title.join("")
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

  private

  def fetch_count(id)
    search_service = Blacklight.repository_class.new(blacklight_config)
    response = search_service.search(
      q: "parent_id_ssi:\"#{id}\"",
      rows: 0
    )
    if response.present? && response["response"].present?
      response["response"]["numFound"]
    else
      0
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
      search_service = Blacklight.repository_class.new(blacklight_config)
      response = search_service.search(
        q: "collection_id_ssi:\"#{@parent_id}\"",
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
