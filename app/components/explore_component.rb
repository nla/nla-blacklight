# frozen_string_literal: true

require "cgi"
require "faraday"

class ExploreComponent < ViewComponent::Base
  attr_reader :document, :nla_shop, :google_books, :library_thing

  def initialize(document)
    @document = document

    config = Rails.application.config_for(:catalogue)
    @nla_shop_url = config.nla_shop_url
    @google_books_url = config.google_books_url

    @nla_shop ||= get_online_shop
    @google_books ||= get_google_preview
    @library_thing ||= get_library_thing
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

  def render_online_shop?
    nla_shop.present?
  end

  def render_google_preview?
    google_books.present?
  end

  def render_library_thing?
    library_thing.present?
  end

  def render?
    document.present? && document.id.present?
  end

  private

  def clean_isn(isn)
    isn = isn.gsub(/[\s-]+/, '\1')
    isn.gsub(/^.*?([0-9]+).*?$/, '\1')
  end

  def isbn10_to_isbn13(isbn)
    new_isbn = isbn

    unless isbn.empty?
      if new_isbn.length > 10
        return new_isbn
      end

      isbn13 = "978#{new_isbn}"[0..-12]

      multiplier

      sum = 0
      isbn13.each_char do |c|
        multiplier = (c.ord % 2 == 0) ? 1 : 3
        sum += (c.ord - 48) * multiplier
      end

      check_digit = 10 - (sum % 10)

      new_isbn = "#{isbn13}#{check_digit}"
    end

    new_isbn
  end

  def get_online_shop
    result = []

    unless document.isbn.empty?
      isbn_list = []
      document.isbn.each do |isn|
        isbn_list << clean_isn(isn)
      end

      conn = Faraday.new(@nla_shop_url) do |f|
        f.response :json
      end
      res = conn.get("/api/jsonDetails.do?isbn13=#{isbn_list.join(",")}")
      # res = Faraday.get("#{@nla_shop_url}?isbn13=#{isbn_list.join(",")}")
      if res.status == 200 && res.body != ""
        shop_response = JSON.parse(res.body)
        isbn_list.each do |isn|
          item = shop_response["InsertOnlineShop"]["#{isn}"]
          result << {thumbnail: item["thumbnail"], itemLink: item["itemLink"], price: item["price"]}
        end
      end
    end

    result
  end

  def get_google_preview
    nil
  end

  def get_library_thing
    nil
  end
end
