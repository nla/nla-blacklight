# frozen_string_literal: true

require "cgi"

class ExploreComponent < ViewComponent::Base
  attr_reader :document, :engines

  def initialize(document)
    @document = document
  end

  def trove_query
    query = ""
    if document.isbn.present?
      document.isbn.each do |isn|
        query += "isbn:#{clean_isn isn}#{(isn != document.isbn.last) ? " OR " : ""}"
      end
    else
      query += document.id.to_s
      if document.callnumber.present?
        query += " OR "
        document.callnumber.each do |callnumber|
          query += "\"#{callnumber}\"#{(callnumber != document.callnumber.last) ? " OR " : ""}"
        end
      end
    end

    "https://trove.nla.gov.au/search?keyword=ANL AND (#{CGI.escape(query)}) AND title:%22#{CGI.escape(document.title_start.tr('"', ""))}%22"
  end

  def online_shop
    nil
  end

  def render_online_shop?
    online_shop.present?
  end

  def google_preview
    nil
  end

  def render_google_preview?
    google_preview.present?
  end

  def render?
    document.present? && document.id.present?
  end

  private

  def clean_isn(isn)
    isn = isn.gsub(/[\s-]+/, '\1')
    isn.gsub(/^.*?([0-9]+).*?$/, '\1')
  end
end
