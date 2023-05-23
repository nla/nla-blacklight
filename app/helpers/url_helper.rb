# frozen_string_literal: true

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
    when Proc, Symbol
      Deprecation.warn(self, "passing a #{field_or_opts.class} to link_to_document is deprecated and will be removed in Blacklight 8")
      Deprecation.silence(Blacklight::IndexPresenter) do
        index_presenter(doc).label field_or_opts, opts
      end
    else # String
      field_or_opts
    end
    # :nocov:

    if current_page?(search_catalog_path)
      label = label.truncate(175, separator: " ")
    end

    Deprecation.silence(Blacklight::UrlHelperBehavior) do
      link_to label, url_for_document(doc), document_link_params(doc, opts)
    end
  end
end
