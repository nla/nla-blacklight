# frozen_string_literal: true

class Eresources
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
        clean_stem = stem.strip

        # If the urlstem ends with a '/', we need to check if the url to match starts with the
        # urlstem minus the trailing '/' in case it is the root URL.
        # e.g. urlstem = "https://www.example.com/" and url = "https://www.example.com"
        if url.start_with?(clean_stem) ||
            (clean_stem.end_with?("/") && url.start_with?(clean_stem[0..-2]))

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
