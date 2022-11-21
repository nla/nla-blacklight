# frozen_string_literal: true

require "digest"
require "erb"

module NLA::Offsite
  extend ActiveSupport::Concern

  def offsite
    url = params[:url]

    unless url.match?(/^https?:\/\/.*/)
      raise "#{url} is not a valid URL"
    end

    @eresource = Eresources.new.known_url(url)

    if @eresource.present?
      if helpers.user_type == :local || helpers.user_type == :staff
        # let them straight through
        return redirect_to url, allow_other_host: true
      elsif @eresource[:entry]["remoteaccess"] == "yes"
        # already logged in
        if current_user.present?
          return redirect_to @eresource[:url], allow_other_host: true if @eresource[:type] == "remoteurl"

          # sorry for this.  EZProxy really needs a URL rewrite function.
          return redirect_to generate_ezproxy_url("http://yomiuri:1234/rekishikan/"), allow_other_host: true if url == "https://database.yomiuri.co.jp/rekishikan/"

          return redirect_to generate_ezproxy_url(@eresource[:url]), allow_other_host: true
        else
          info_msg = if @eresource[:entry]["title"].strip == "ebsco"
            "Log into eResources with your National Library card"
          else
            "To access #{@eresource[:entry]["title"]}, log in with your National Library card details."
          end

          return redirect_to new_user_session_url, flash: {info: info_msg}
        end
      else
        @requested_url = url
        @record_url = solr_document_path(id: params[:id])
        return render "onsite_only"
      end
    end

    # if all else fails, redirect back to the same catalogue record page
    redirect_to solr_document_path(id: params[:id])
  end

  private

  # rubocop:disable Rails/OutputSafety
  def generate_ezproxy_url(url)
    user = ENV.fetch("EZPROXY_USER")
    pass = ENV.fetch("EZPROXY_PASSWORD")

    packet = "$u#{Time.zone.now.to_i}"
    ticket = ERB::Util.url_encode("#{Digest::MD5.hexdigest "#{pass}#{user}#{packet}"}#{packet}")
    "#{ENV.fetch("EZPROXY_URL").html_safe}/login?user=#{ENV.fetch("EZPROXY_USER")}&ticket=#{ticket}&url=#{url}"
  end
  # rubocop:enable Rails/OutputSafety
end
