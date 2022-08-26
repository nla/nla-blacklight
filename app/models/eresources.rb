# frozen_string_literal: true

require "json"

class Eresources
  include ActiveModel::Model

  attr_accessor :entries

  def initialize
    file = File.open "#{::Rails.root}/config/eresources.cfg"
    @entries ||= JSON.load_file file
    file.close
  end

  def url_append(url, param)
    url + (url.include?("?") ? "&#{param}" : "?#{param}")
  end

  def known_url(url)
    result = {}
    @entries.each do |entry|
      entry["urlstem"].each do |stem|
        stem = stem.gsub(/\/+$/, "")
        if url.start_with?(stem)
          result = if entry["remoteurl"].empty?
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
end
