# frozen_string_literal: true

class ThumbnailService
  def get_url(options = {})
    Rails.cache.fetch("thumbnail_url/#{options[:id]}/#{options[:width]}", expires_in: 1.hour, skip_nil: true) do
      conn = Faraday.new(url: ENV["THUMBNAIL_SERVICE_API_BASE_URL"]) do |f|
        f.response :json
      end

      url = "/thumbnail-service/thumbnail/url?#{options.to_query}"
      res = conn.get(url)
      if res.status == 200
        jbody = JSON.parse(res.body)
        jbody["url"]
      end
    end
  rescue => e
    Rails.logger.error "Failed to connect to thumbnail service : #{e.message}"
    nil
  end
end
