# frozen_string_literal: true

class Eresources
  include ActiveModel::Model

  attr_accessor :entries

  def initialize
    @entries = Rails.cache.fetch("eresources_config", expires_in: 4.hours) do
      EresourcesConfigService.new.fetch_config
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
          result = if entry["remoteurl"].present?
            {type: "remoteurl", url: url_append(entry["remoteurl"], "NLAOriginalUrl=#{url}"), entry: entry}
          else
            {type: "ezproxy", url: url, entry: entry}
          end
          break
        end
      end
    end
    result
  end
end
