# frozen_string_literal: true

class Eresources
  attr_reader :entries

  def self.http_uri(url)
    return unless url.is_a?(String)

    uri = URI.parse(url)
    uri if uri.is_a?(URI::HTTP) && uri.host.present? && uri.userinfo.nil?
  rescue URI::InvalidURIError
    nil
  end

  def initialize
    @entries = Rails.cache.fetch("eresources_config", expires_in: 4.hours) do
      EresourcesConfigService.new.fetch_config
    end
  end

  def url_append(url, param)
    url + (url.include?("?") ? "&#{param}" : "?#{param}")
  end

  def known_url(url)
    uri = self.class.http_uri(url)
    return {} unless uri

    result = {}
    @entries&.each do |entry|
      entry["urlstem"].each do |stem|
        stem = stem.strip
        if url.start_with?(stem) && self.class.http_uri(stem)&.origin == uri.origin
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
