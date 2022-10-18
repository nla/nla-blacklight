class RelatedRecords
  include ActiveModel::Model
  include Blacklight::Configurable

  attr_accessor :document

  def initialize(document)
    @document = document
  end

  def collection_id
    if child?
      document.fetch("parent_id_ssi")
    else
      document.fetch("collection_id_ssi")
    end
  rescue KeyError
    nil
  end

  def parent?
    document.fetch("collection_id_ssi").present?
  rescue KeyError
    false
  end

  def child?
    document.fetch("parent_id_ssi").present?
  rescue KeyError
    false
  end

  def in_collection?
    child? || (parent? && has_children?)
  end

  def has_children?
    parent? && collection_count > 0
  end

  def collection_name
    title = document.get_marc_derived_field("773abdghkmnopqrstuxyz34678")
    title = document.get_marc_derived_field("973abdghkmnopqrstuxyz34678") if title.blank?
    title.join
  end

  def collection_records
    @children ||= fetch_children
  end

  def collection_count
    @count ||= fetch_count
  end

  private

  def fetch_count
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

  def fetch_children
    search_service = Blacklight.repository_class.new(blacklight_config)
    response = search_service.search(
      q: "parent_id_ssi:\"#{collection_id}\"",
      qf: "parent_id_ssi",
      fq: ["-filter(id:#{document.id})"],
      fl: "id,title_tsim",
      sort: "score desc, pub_date_si desc, title_si asc",
      rows: 3
    )
    if response.present? && response["response"].present?
      response["response"]["docs"].map do |doc|
        {id: doc["id"], title: doc["title_tsim"]}
      end
    else
      []
    end
  end
end
