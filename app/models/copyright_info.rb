# frozen_string_literal: true

require "faraday"
require "faraday/middleware"
require "faraday/adapter/net_http"

class CopyrightInfo
  include ActiveModel::Model

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

  private

  def fetch
    res = Faraday.get(ENV["COPYRIGHT_SERVICE_URL"] % [document.id])
    unless res.status != 200
      doc = Nokogiri::XML(res.body)
      item = doc.xpath("//response/itemList/item")
      Hash.from_xml(item.to_s)["item"] if item.present?
    end
  end
end
