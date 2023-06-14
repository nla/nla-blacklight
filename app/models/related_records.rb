class RelatedRecords
  include ActiveModel::Model
  include Blacklight::Configurable

  attr_accessor :document

  def initialize(document)
    @document = document
  end

  def collection_id
    @collection_id ||= document.fetch("collection_id_ssi")
  rescue KeyError
    nil
  end

  def parent_id
    @parent_id ||= document.fetch("parent_id_ssi")
  rescue KeyError
    nil
  end

  def in_collection?
    collection_id.present? || parent_id.present?
  end

  def collection_name
    title = document.get_marc_derived_field("773abdghkmnopqrstuxyz34678")
    title = document.get_marc_derived_field("973abdghkmnopqrstuxyz34678") if title.blank?
    title.join
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

  def fetch_sibling_count
    search_service = Blacklight.repository_class.new(blacklight_config)
    response = search_service.search(
      q: "parent_id_ssi:\"#{parent_id}\"",
      rows: 0
    )
    if response.present? && response["response"].present?
      response["response"]["numFound"]
    else
      0
    end
  end

  def fetch_parent
    search_service = Blacklight.repository_class.new(blacklight_config)
    response = search_service.search(
      q: "collection_id_ssi:\"#{parent_id}\"",
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

  # Fetches the first 3 children records of a collection. Filters out the
  # currently viewed record, to avoid redundantly displaying/linking
  # to the current record.
  def fetch_children
    search_service = Blacklight.repository_class.new(blacklight_config)
    response = search_service.search(
      q: "parent_id_ssi:\"#{collection_id}\"",
      fq: ["-filter(id:#{document.id})"],
      fl: "id,title_tsim",
      sort: "score desc, pub_date_si desc, title_si asc",
      rows: 3
    )
    if response.present? && response["response"].present?
      response["response"]["docs"].map do |doc|
        {id: doc["id"], title: doc["title_tsim"]}
      end
    end
  end
end
