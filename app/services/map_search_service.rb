# frozen_string_literal: true

require "faraday"

class MapSearchService
  FORMAT = "Map"

  def determine_url(id:, format:)
    unless id.nil? || format.nil?
      config = Rails.application.config_for(:catalogue)

      mapsearch_url = config.mapsearch[:search_url]
      if mapsearch_url.present? && format.include?(FORMAT)
        response = Faraday.get("#{mapsearch_url}#{id}")
        unless response.status != 200
          body = JSON.parse(response.body)
          if body["results"]["response"]["numFound"] > 0
            "#{config.mapsearch[:url]}#{id}"
          end
        end
      end
    end
  rescue => e
    Rails.logger.error "Failed to connect to map search service: #{e.message}"
    nil
  end
end
