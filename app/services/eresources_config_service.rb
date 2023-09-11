# frozen_string_literal: true

require "faraday"

class EresourcesConfigService
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
    Rails.logger.error "Failed to retrieve or parse eResources config: #{e.message}"
    nil
  end
end
