# frozen_string_literal: true

require "blacklight"
require "nla/solr_cloud/repository"

class RelatedRecordsService
  def fetch_count(id, blacklight_config)
    Rails.cache.fetch("related_records_count/#{id}", expires_in: 15.minutes) do
      search_service = Blacklight.repository_class.new(blacklight_config)
      response = search_service.search(
        q: "parent_id_ssim:\"#{id}\"",
        rows: 0
      )
      if response.present? && response["response"].present?
        response["response"]["numFound"]
      else
        0
      end
    end
  end

  def fetch_parent(id, blacklight_config)
    Rails.cache.fetch("related_records_parent/#{id}", expires_in: 15.minutes) do
      search_service = Blacklight.repository_class.new(blacklight_config)
      response = search_service.search(
        q: "collection_id_ssim:\"#{id}\"",
        fl: "id,title_tsim",
        sort: "score desc, pub_date_si desc",
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
