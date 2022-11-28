# frozen_string_literal: true

require "digest"
require "erb"

class EzproxyUrl
  include ActiveModel::Model

  attr_reader :url

  def initialize(url)
    if url.blank?
      raise "Invalid URL"
    end

    user = ENV.fetch("EZPROXY_USER")
    pass = ENV.fetch("EZPROXY_PASSWORD")

    packet = "$u#{Time.zone.now.to_i}"
    ticket = ERB::Util.url_encode("#{Digest::MD5.hexdigest "#{pass}#{user}#{packet}"}#{packet}")
    # rubocop:disable Rails/OutputSafety
    @url = "#{ENV.fetch("EZPROXY_URL").html_safe}/login?user=#{ENV.fetch("EZPROXY_USER")}&ticket=#{ticket}&url=#{url}"
    # rubocop:enable Rails/OutputSafety
  end
end
