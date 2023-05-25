require "cgi"
require "multi_json"

require "httpclient"
require "http_client_patch/include_client"

module BentoSearch
  class BlacklightEngine
    include BentoSearch::SearchEngine

    extend HTTPClientPatch::IncludeClient
    include_http_client do |client|
      client.ssl_config.clear_cert_store
      client.ssl_config.cert_store.set_default_paths
    end

    def search_implementation(args)
      results = Results.new

      begin
        results = Results.new
        results.total_items = 0

        url = construct_query(args)

        headers = {"Accept" => "application/json"}
        response = http_client.get(url, nil, headers)

        if response.status != 200
          results.error ||= {}
          results.error[:status] = response.status
          results.error[:response] = response.body
          return results
        end

        json = MultiJson.load(response.body)

        results.total_items = json["meta"]["pages"]["total_count"].to_i
        results.per_page = json["meta"]["pages"]["limit_value"].to_i

        (json["data"] || []).each do |json_item|
          item = BentoSearch::ResultItem.new

          item.unique_id = json_item["id"]
          item.format_str = json_item["type"]

          json_item["attributes"].each do |attr|
            if attr[0] == "title"
              title = HTMLEntities.new.decode(attr[1])
              item.title = title
            else
              value = attr[1]["attributes"]["value"]
              label = attr[1]["attributes"]["label"]

              item.custom_data[label] = value
            end
          end

          item.link = json_item["links"]["self"]
          item.custom_data[:finding_aid] = true

          item.custom_data[:search_link] = json["links"]["self"]

          results << item
        end

        results
      rescue BentoSearch::RubyTimeoutClass, HTTPClient::ConfigurationError, HTTPClient::BadResponseError, HTTPClient::TimeoutError => e
        results.total_items = 0
        results.error ||= {}
        results.error[:exception] = e
        results
      end
    end

    def self.default_configuration
      {
        base_url: "https://catalogue.nla.gov.au/catalogue.json"
      }
    end

    protected

    # create the URL to the Blacklight API based on normalized search args
    def construct_query(args)
      url = "#{configuration.base_url}?q=#{CGI.escape args[:query]}"
      url += "&per_page=#{args[:per_page]}" if args[:per_page]

      url
    end
  end
end
