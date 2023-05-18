# frozen_string_literal: true

require "faraday"
require "htmlentities"

module BentoSearch
  class BlacklightEngine
    include BentoSearch::SearchEngine

    def search_implementation(args)
      results = BentoSearch::Results.new

      uri = URI.parse(configuration.search_url)

      conn = Faraday.new(
        url: "#{uri.scheme}://#{uri.host}#{uri.port.present? ? ":#{uri.port}" : ""}"
      )
      endpoint = uri.path.to_s

      q = (args[:oq].presence || args[:query].presence)

      if q.nil?
        results.total_items = 0
        return results
      end

      response = conn.get(endpoint) do |req|
        req.params["q"] = q
        req.params["per_page"] = args[:per_page]
      end

      if response.status == 200
        response_body = JSON.parse(response.body)

        results.total_items = response_body["meta"]["pages"]["total_count"]
        results.per_page = response_body["meta"]["pages"]["limit_value"]

        data = response_body["data"]

        data.each do |d|
          item = BentoSearch::ResultItem.new

          item.unique_id = d["id"]
          item.format_str = d["type"]

          d["attributes"].each do |attr|
            if attr[0] == "title"
              title = HTMLEntities.new.decode(attr[1])
              item.title = title
            else
              value = attr[1]["attributes"]["value"]
              label = attr[1]["attributes"]["label"]

              item.custom_data[label] = value
            end
          end

          item.link = d["links"]["self"]
          item.custom_data[:finding_aid] = true

          results << item
        end
      else
        results.total_items = 0
      end

      results
    end
  end
end
