# frozen_string_literal: true

class Eresources
  include ActiveModel::Model

  attr_accessor :entries

  def initialize
    @entries = Rails.cache.fetch("eresources_config", expires_in: 4.hours) do
      fetch_config
    end
  end

  def url_append(url, param)
    url + (url.include?("?") ? "&#{param}" : "?#{param}")
  end

  def known_url(url)
    result = {}
    @entries&.each do |entry|
      entry["urlstem"].each do |stem|
        if url.start_with?(stem.strip)
          result = if entry["remoteurl"].blank?
            {type: "ezproxy", url: url, entry: entry}
          else
            {type: "remoteurl", url: url_append(entry["remoteurl"], "NLAOriginalUrl=#{url}"), entry: entry}
          end
          break
        end
      end
    end
    result
  end

  private

  def fetch_config
    res = Faraday.get(ENV["ERESOURCES_CONFIG_URL"], nil, {content_type: "application/json", accept: "application/json"})
    if res.status == 200
      if res.body.present?
        JSON.parse(res.body)
      end
    else
      Rails.logger.error "Failed to retrieve eResources config"
      nil
    end
  rescue => e
    Rails.logger.error "Failed to retrieve eResources config: #{e.message}"
    nil
  end
end
