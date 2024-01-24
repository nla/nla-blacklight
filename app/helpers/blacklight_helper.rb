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
      prefix + ((content_for(:page_title) if content_for?(:page_title)) || @page_title || application_name)
    else
      (content_for(:page_title) if content_for?(:page_title)) || @page_title || application_name
    end
    # rubocop:enable Rails/HelperInstanceVariable
  end
end
