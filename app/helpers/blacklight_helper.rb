module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  def application_name
    "Catalogue | National Library of Australia"
  end

  def render_page_title
    prefix = case ENV["RAILS_ENV"]
    when "development" then "[DEV] "
    when "staging" then "[TEST] "
    else ""
    end
    # rubocop:disable Rails/HelperInstanceVariable
    prefix + ((content_for(:page_title) if content_for?(:page_title)) || @page_title || application_name)
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

    content_tag(tag, document_presenter(document).heading, itemprop: "name", class: "h3")
  end
  deprecation_deprecate render_document_heading: "Removed without replacement"
  # rubocop:enable Rails/HelperInstanceVariable
end
