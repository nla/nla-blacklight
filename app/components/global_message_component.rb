# frozen_string_literal: true

require "faraday"

class GlobalMessageComponent < ViewComponent::Base
  def initialize(location: nil)
    @messages ||= fetch_messages
    @location = location
  end

  def render?
    @messages.present?
  end

  private

  def fetch_messages
    uri = URI.parse(ENV["GLOBAL_MESSAGE_URL"])
    conn = Faraday.new(url: "#{uri.scheme}://#{uri.host}#{uri.port.present? ? ":#{uri.port}" : ""}")
    response = conn.get uri.path.to_s
    if response.status == 200
      JSON.parse(response.body)
    else
      []
    end
  end
end
