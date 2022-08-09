# frozen_string_literal: true

require "addressable/uri"

class SearchLink
  include ActiveModel::Model

  GOOGLE_BASE_URL = "https://www.google.com.au/search?q=%s"
  TROVE_BASE_URL = "https://webarchive.nla.gov.au/awa"
  WAYBACK_BASE_URL = "https://web.archive.org/web"

  def initialize(document)
    @document = document
  end

  def links
    @links ||= generate_links
  end

  private

  def generate_links
    urls = select_urls

    result = {}

    urls.each do |url|
      result[url] = {
        google: build_google_query(url),
        trove: build_wayback_query(TROVE_BASE_URL, url),
        wayback: build_wayback_query(WAYBACK_BASE_URL, url)
      }
    end

    result
  end

  def select_urls
    urls = @document.get_marc_derived_field("856u")

    eresources = Eresources.new

    result = []

    urls.each do |url|
      unless eresources.known_url url
        result << url
      end

      if is_nla_url?(url)
        break
      end
    end

    result
  end

  def build_google_query(url)
    unless url.empty?
      query = [phrase_query(url), extract_domain(url)]

      cited_authors = @document.get_marc_derived_field("100a:110a:111a:700a:710a:711a")
      cited_authors.each do |author|
        query << process_author(author)
      end

      file_extension = Addressable::URI.parse(url).extname
      unless file_extension.nil?
        query << "pdf" if file_extension.downcase == "pdf"
      end

      GOOGLE_BASE_URL % [join_query(query)] unless query.empty?
    end
  end

  def build_wayback_query(base_url, url)
    "#{base_url}/*/#{url}" unless url.empty?
  end

  def phrase_query(url)
    "\"#{trim_garbage(url.delete('"'))}\"" unless url.empty?
  end

  def extract_domain(url)
    URI.parse(url).host unless url.empty?
  end

  def trim_garbage(value)
    clean = value.gsub(/^[[:punct:]\s]+/, "")
    clean.gsub(/[[:punct:]\s]+$/, "")
  end

  def is_nla_url?(url)
    url.match(/https?:\/\/(nla\.gov\.au\/nla\.|purl\.nla\.gov\.au|pandora\.nla\.gov\.au)/i).present?
  end

  def process_author(author)
    result = []
    unless author.empty?
      names = author.split(/ +/)

      unless names.size > 3
        names.each do |name|
          result << name.gsub(/\W/, "") if /^\w{3,}/.match?(name)
        end
      end
    end
    result.join(" ")
  end

  def join_query(query)
    result = ""

    query.each do |term|
      result += " #{term}" unless term.empty?
    end

    result.strip
  end
end
