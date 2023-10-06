# frozen_string_literal: true

require "nokogiri"

module UrlHelper
  include Blacklight::UrlHelperBehavior

  def link_to_document(doc, field_or_opts = nil, opts = {counter: nil})
    # :nocov:
    label = case field_or_opts
    when NilClass
      document_presenter(doc).heading
    when Hash
      opts = field_or_opts
      document_presenter(doc).heading
    else # String
      field_or_opts
    end
    # :nocov:

    # rubocop:disable Rails/OutputSafety
    link_to label.html_safe, search_state.url_for_document(doc), document_link_params(doc, opts.merge({class: "text-break"}))
    # rubocop:enable Rails/OutputSafety
  end
end
