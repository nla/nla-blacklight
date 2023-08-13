# frozen_string_literal: true

require "cgi"
require "faraday"

class ExploreComponent < ViewComponent::Base
  attr_reader :document, :nla_shop, :map_search

  def initialize(document)
    @document = document

    config = Rails.application.config_for(:catalogue)
    @nla_shop_url = config.nla_shop_url
    @google_books_url = config.google_books_url

    @nla_shop ||= get_online_shop
  end

  def trove_query
    query = ""
    if document.isbn_list.present?
      isbn_list = document.isbn_list
      isbn_list.each do |isn|
        query += "isbn:#{document.clean_isn isn}#{(isn != isbn_list.last) ? " OR " : ""}"
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

  def google_books_script
    isbn_list = document.isbn_list
    "https://books.google.com/books?jscmd=viewapi&bibkeys=#{google_lccn_list&.join(",")}#{isbn_list.present? ? "," : ""}#{google_isbn_list&.join(",")}&callback=showGoogleBooksPreview"
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
    isbn_list = document.isbn_list&.map { |isn| isbn10_to_isbn13(isn) }

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
    document.lccn&.map do |lccn|
      lccn
    end
  end

  def google_lccn_list
    lccn_list&.map do |lcn|
      "LCCN:#{document.clean_isn(lcn)}"
    end
  end

  def google_isbn_list
    document.isbn_list&.map do |isn|
      "ISBN:#{isn}"
    end
  end
end
