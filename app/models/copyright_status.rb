# frozen_string_literal: true

require "faraday"
require "faraday/middleware"
require "faraday/adapter/net_http"

class CopyrightStatus
  attr_accessor :document, :info

  FORMAT_TO_CATEGORY = [
    Audio: "OH",
    Manuscript: "MAN",
    Map: "MAPS",
    Music: "MUS",
    Picture: "PIC"
  ]

  DEFAULT_CATEGORY = "IS"

  def initialize(document)
    @document = document
    @info ||= fetch
  end

  def category
    FORMAT_TO_CATEGORY[document.format.last] || DEFAULT_CATEGORY
  end

  def value
    @info
  end

  private

  def fetch
    Rails.cache.fetch("copyright/#{document.id}", expires_in: 15.minutes) do
      res = Faraday.get(ENV["COPYRIGHT_SERVICE_URL"] % [document.id])
      unless res.status != 200
        doc = Nokogiri::XML(res.body)
        item = doc.xpath("//response/itemList/item")
        Hash.from_xml(item.to_s)["item"] if item.present?
      end
    end
  rescue => e
    Rails.logger.error "Failed to connect to copyright service: #{e.message}"
  end
end
