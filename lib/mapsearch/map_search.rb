require "faraday"
require "faraday/net_http"

class MapSearch
  def determine_url(id:, format:)
    url = ""

    unless id.nil?
      config = Rails.application.config_for(:catalogue)

      mapsearch_url = config.mapsearch[:search_url]
      if mapsearch_url.present? && format.include?("Map")
        response = Faraday.get("#{mapsearch_url}#{id}")
        unless response.status != 200
          body = JSON.parse(response.body)
          if body["results"]["response"]["numFound"] > 0
            url = "#{config.mapsearch[:url]}#{id}"
          end
        end
      end
    end

    url
  end
end
