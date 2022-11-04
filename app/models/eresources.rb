# frozen_string_literal: true

require "json"
require "down"
require "fileutils"

class Eresources
  include ActiveModel::Model

  attr_accessor :entries

  def initialize
    @entries = Rails.cache.fetch(["eresources_config"], race_condition_ttl: 10.seconds, expires_in: 4.hours) do
      fetch_latest_config
    end
  end

  def url_append(url, param)
    url + (url.include?("?") ? "&#{param}" : "?#{param}")
  end

  def known_url(url)
    result = {}
    @entries&.each do |entry|
      entry["urlstem"].each do |stem|
        stem = stem.gsub(/\/+$/, "")
        if url.start_with?(stem)
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

  def fetch_latest_config
    Rails.logger.info "Fetching latest eResources config"

    config = []
    begin
      tempfile = Down.download(ENV["ERESOURCES_CONFIG_URL"])
      if tempfile.present?
        same = if File.exist? current_config_path
          FileUtils.compare_file(current_config_path, tempfile.path)
        else
          false
        end

        if same
          Rails.logger.info "eResources config has not changed. Keeping current config."
        elsif File.exist?(current_config_path) && ((File.size(current_config_path) - File.size(tempfile.path)).abs / File.size(current_config_path) > 0.5)
          # compare the filesizes
          Rails.logger.error "Suspicious difference in file size between latest and current config. Keeping current config."
        else
          FileUtils.mv(tempfile.path, current_config_path)
          Rails.logger.info "eResources config updated"
        end
      else
        Rails.logger.error "Failed to retrieve latest eResources config. Keeping current config."
      end
    rescue Down::ServerError
      Rails.logger.error "Failed to retrieve latest eResources config. Keeping current config."
    ensure
      if File.exist? current_config_path
        config = JSON.parse read_current_config
      end
    end

    config
  end

  def current_config_path
    "#{ENV["BLACKLIGHT_TMP_PATH"]}/cache/eresources.cfg"
  end

  def read_current_config
    File.read(current_config_path)
  end
end
