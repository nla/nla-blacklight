# frozen_string_literal: true

require "digest"
require "erb"

class EzproxyUrl
  attr_reader :url

  def initialize(url, folio_id: nil)
    if url.blank?
      raise "Invalid URL"
    end

    user = ENV.fetch("EZPROXY_USER")
    pass = ENV.fetch("EZPROXY_PASSWORD")

    packet = "$u#{Time.zone.now.to_i}"
    ticket = ERB::Util.url_encode("#{Digest::MD5.hexdigest "#{pass}#{user}#{packet}"}#{packet}")

    base_path = ENV.fetch("EZPROXY_URL")
    folio_path = folio_id.present? ? "/folio/#{ERB::Util.url_encode(folio_id)}" : ""

    @url = "#{base_path}#{folio_path}/login?user=#{ENV.fetch("EZPROXY_USER")}&ticket=#{ticket}&url=#{url}"
  end
end
