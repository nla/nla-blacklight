# frozen_string_literal: true

module ApplicationHelper
  def makelink(document:, href:, text:, classes: "", extended_info: false, longtext: "")
    entry = nil
    caption = ""

    if document.has_eresources?
      entry, caption, _ = makelink_eresource href
    end

    result = []

    if text.present? && href.present?
      # if an eResources link, route to offsite handler
      result << if entry.present?
        link_to(text, offsite_catalog_path(id: document.id, url: href), class: "text-break")
      else
        link_to(text, href, class: "text-break")
      end
    end

    # rubocop:disable Rails/OutputSafety
    if extended_info && caption.present?
      result << content_tag(:div, class: "linkCaption") do
        content_tag(:small, caption.to_s.html_safe)
      end
    end
    # rubocop:enable Rails/OutputSafety

    result
  end

  def show_search_bar?
    !current_page?(root_path) &&
      !current_page?(advanced_search_catalog_path) &&
      !current_page?(bento_search_index_path) &&
      !current_page?(new_user_session_path) &&
      params[:controller] != "account"
  end

  def show_facets_sidebar?
    !current_page?(root_path)
  end

  def svg(name)
    file_path = "#{Rails.root}/app/assets/images/#{name}.svg"

    if File.exist?(file_path)
      # rubocop:disable Rails/OutputSafety
      File.read(file_path).html_safe
      # rubocop:enable Rails/OutputSafety
    else
      "(not found)"
    end
  end

  def error_feedback_url(id)
    url = ENV.fetch("FEEDBACK_ERROR_URL", "#")
    if url != "#"
      "#{url}&qnudftb17=#{request.original_url}&qnudftb11=#{id}"
    else
      url
    end
  end

  def culturally_sensitive_url(id)
    url = ENV.fetch("CULTURALLY_SENSITIVE_URL", "#")
    if url != "#"
      "#{url}&qnudftb17=#{request.original_url}&qnudftb11=#{id}"
    else
      url
    end
  end

  # Used to find users who have made too many requests to a resource
  def log_eresources_offsite_access(url)
    message = if current_user.present?
      "eResources %s access by user %s: %s" % [user_type, current_user.id, url]
    else
      "eResources %s access: %s" % [user_type, url]
    end
    Rails.logger.info message
  end

  private

  def makelink_eresource(href)
    entry = nil
    caption = ""
    icon = ""

    if href.present?
      entry = Eresources.new.known_url(href)
    end

    if entry.present?
      caption = if entry[:entry]["remoteaccess"] == "yes"
        icon = <<~ICON
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-key-fill" viewBox="0 0 16 16">
            <path d="M3.5 11.5a3.5 3.5 0 1 1 3.163-5H14L15.5 8 14 9.5l-1-1-1 1-1-1-1 1-1-1-1 1H6.663a3.5 3.5 0 0 1-3.163 2zM2.5 9a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"/>
          </svg>
        ICON
        if user_location == :offsite
          if current_user
            t("eresource.remote_access.logged_in")
          else
            t("eresource.remote_access.logged_out")
          end
        else
          t("eresource.onsite")
        end
      else
        icon = <<~ICON
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-building-fill" viewBox="0 0 16 16">
            <path d="M3 0a1 1 0 0 0-1 1v14a1 1 0 0 0 1 1h3v-3.5a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 .5.5V16h3a1 1 0 0 0 1-1V1a1 1 0 0 0-1-1H3Zm1 2.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1Zm3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1Zm3.5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5ZM4 5.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1ZM7.5 5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5Zm2.5.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1ZM4.5 8h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5Zm2.5.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1Zm3.5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5Z"/>
          </svg>
        ICON
        if user_location == :offsite
          t("eresource.offsite")
        else
          t("eresource.onsite")
        end
      end
    end

    [entry, caption, icon]
  end

  def show_analytics?
    response.status != 404 || !routing_error?
  end

  private

  def routing_error?
    params[:controller] == 'application' && params[:action] == 'routing_error'
  end

end
