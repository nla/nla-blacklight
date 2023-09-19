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
      ((content_for(:page_title) if content_for?(:page_title)) || @page_title || application_name)
    end
    # rubocop:enable Rails/HelperInstanceVariable
  end

  ##
  # Render the document "heading" (title) in a content tag
  # @deprecated
  # @overload render_document_heading(document, options)
  #   @param [SolrDocument] document
  #   @param [Hash] options
  #   @option options [Symbol] :tag
  # @overload render_document_heading(options)
  #   @param [Hash] options
  #   @option options [Symbol] :tag
  # @return [String]
  # rubocop:disable Rails/HelperInstanceVariable
  def render_document_heading(*args)
    options = args.extract_options!
    document = args.first
    tag = options.fetch(:tag, :h4)
    document ||= @document

    # the content_tag will escape special characters as HTML entities again, so we need to decode them first
    clean_heading = HTMLEntities.new.decode(document_presenter(document).heading)
    # rubocop:disable Rails/OutputSafety
    content_tag(tag, clean_heading.html_safe, itemprop: "name", class: "h3 col")
    # rubocop:enable Rails/OutputSafety
  end
  deprecation_deprecate render_document_heading: "Removed without replacement"
  # rubocop:enable Rails/HelperInstanceVariable
end
