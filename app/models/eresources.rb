# frozen_string_literal: true

require "json"

class Eresources
  include ActiveModel::Model

  attr_accessor :entries

  def initialize
    file = File.open "#{::Rails.root}/config/eresources.cfg"
    @entries = JSON.load_file file
  end

  def url_append(url, param)
    url + (url.contains?("?") ? "&#{param}" : "?#{param}")
  end

  def known_url(url, user_type = false)
    @entries.each do |entry|
      entry["urlstem"].each do |stem|
        stem = stem.delete("/")
        if url.start_with?(stem)
          if entry["remoteurl"].empty?
            {type: "ezproxy", url: url, entry: entry}
          else
            {type: "remoteurl", url: url_append(entry["remoteurl"], "NLAOriginalUrl=#{url}"), entry: entry}
          end
        end
      end
    end
  end
end
