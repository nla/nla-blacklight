# frozen_string_literal: true

class ThumbnailService
  def get_url(options = {})
    conn = Faraday.new(url: ENV["THUMBNAIL_SERVICE_API_BASE_URL"]) do |f|
      f.response :json
    end

    url = "/thumbnail-service/thumbnail/url?#{options.to_query}"
    Rails.cache.fetch("thumb_url_#{url}", expires: 1.year) do
      res = conn.get(url)
      if res.status == 200
        res.body["url"]
      else
        Rails.logger.error "Failed to retrieve thumbnail for #{options.to_json}"
        nil
      end
    end
  end

  # Not used, but implemented just in case it needs to be used in the future.
  # :nocov:
  def get_binary(options = {})
    conn = Faraday.new(url: ENV["THUMBNAIL_SERVICE_API_BASE_URL"])

    url = "/thumbnail-service/thumbnail/retrieve?#{options.to_query}"
    Rails.cache.fetch("thumb_raw_#{url}", expires: 1.year) do
      res = conn.get(url)
      if res.status == 200
        content_type = res.headers["content-type"]
        "data:#{content_type};base64,#{Base64.encode64(res.body).gsub("\n", "")}"
      else
        Rails.logger.error "Failed to retrieve thumbnail for #{options.to_json}"
        nil
      end
    end
  end
  # :nocov:
end