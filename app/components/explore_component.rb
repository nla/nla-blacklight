# frozen_string_literal: true

require "cgi"
require "faraday"

class ExploreComponent < ViewComponent::Base
  attr_reader :document, :nla_shop

  def initialize(document)
    @document = document

    config = Rails.application.config_for(:catalogue)
    @nla_shop_url = config.nla_shop_url
    @google_books_url = config.google_books_url

    @nla_shop ||= get_online_shop
  end

  def trove_query
    Rails.cache.fetch("trove_query/#{document.id}", expires_in: 1.hour) do
      query = ""
      if document.isbn.present?
        document.isbn.each do |isn|
          query += "isbn:#{isn}#{(isn != document.isbn.last) ? " OR " : ""}"
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

      trove_query = "https://trove.nla.gov.au/search?keyword=ANL"
      if query.present?
        trove_query += " AND (#{ERB::Util.u(query)})"
      end
      if document.title_start.present?
        trove_query += " AND title:%22#{ERB::Util.u(document.title_start.first.tr('"', ""))}%22"
      end
      trove_query
    end
  end

  def google_books_script
    "https://books.google.com/books?jscmd=viewapi&bibkeys=#{google_lccn_list&.join(",")}#{document.isbn.present? ? "," : ""}#{google_isbn_list&.join(",")}&callback=showGoogleBooksPreview"
  end

  def render_online_shop?
    nla_shop.present?
  end

  def render_map_search?
    format = document.first("format")
    format.present? && format.include?("Map")
  end

  def render?
    document.present? && document.id.present?
  end

  private

  def get_online_shop
    isbn_list = document.isbn&.map { |isn| isbn10_to_isbn13(isn) }

    if isbn_list.present?
      Rails.cache.fetch("nla_shop/#{document.id}", expires_in: 15.minutes) do
        res = Faraday.get("#{@nla_shop_url}?isbn13=#{isbn_list.join(",")}")
        res_body = res.body.delete(" \t\r\n")
        if res.status == 200 && res_body != ""
          result = []
          shop_response = JSON.parse(res.body)
          isbn_list.each do |isn|
            item = shop_response["InsertOnlineShop"][isn.to_s]
            if item.present?
              result << {thumbnail: item["thumbnail"], itemLink: item["itemLink"], price: item["price"]}
            end
          end
          result
        end
      end
    end
  rescue
    Rails.logger.error("Error fetching online shop data for #{document.id}")
    nil
  end

  def isbn10_to_isbn13(isbn)
    new_isbn = isbn

    unless isbn.empty?
      if new_isbn.length > 10
        return new_isbn
      end

      isbn13 = "978#{new_isbn}"[0..12]

      sum = 0
      isbn13.to_s.each_char do |c|
        multiplier = (c.ord % 2 == 0) ? 1 : 3
        sum += (c.ord - 48) * multiplier
      end

      check_digit = 10 - (sum % 10)

      new_isbn = "#{isbn13}#{check_digit}"
    end

    new_isbn
  end

  def lccn_list
    document.lccn
  end

  def google_lccn_list
    lccn_list&.map do |lcn|
      "LCCN:#{lcn}"
    end
  end

  def google_isbn_list
    document.isbn&.map do |isn|
      "ISBN:#{isn}"
    end
  end
end
