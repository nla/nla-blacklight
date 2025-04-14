# frozen_string_literal: true

require "htmlentities"

module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  DEV_TAG = "[DEV] "
  STAGING_TAG = "[TEST] "

  def application_name
    "Catalogue | National Library of Australia"
  end

  def render_page_title
    prefix = if Rails.env.development?
      DEV_TAG
    elsif Rails.env.staging?
      STAGING_TAG
    end
    # rubocop:disable Rails/HelperInstanceVariable
    if prefix.present?
      prefix + get_unique_page_title + ((content_for(:page_title) if content_for?(:page_title)) || @page_title || application_name)
    else
      (content_for(:page_title) if content_for?(:page_title)) || @page_title || application_name
    end
    # rubocop:enable Rails/HelperInstanceVariable
  end

  def get_unique_page_title
    page_titles = {
      root_path => "Home | ",
      search_catalog_path => "Search | ",
      advanced_search_catalog_path => "Advanced Search | ",
      bento_search_index_path => "Bento Search | ",
      new_user_session_path => "Login | ",
      destroy_user_session_path => "Logout | ",
      account_requests_path => "Requests | ",
      account_profile_path => "Profile | ",
      account_profile_edit_path => "Edit Profile | ",
      :dynamic_edit => -> {
        I18n.t("account.settings.update.heading", attribute: t("account.settings.#{params[:attribute]}.change_text"))
        pp "attribute: " + params[:attribute] + ", " + t("account.settings.#{params[:attribute]}.change_text")
      }
    }

    page_titles.each do |path, title|
      if path == :dynamic_edit && params[:attribute].present? && current_page?(account_profile_edit_path(attribute: params[:attribute]))
        return title.call
      elsif path != :dynamic_edit && current_page?(path)
        return title
      end
    end

    ""
  end
end
