# frozen_string_literal: true

module UrlHelper
  include Blacklight::UrlHelperBehavior

  def link_to_document(doc, field_or_opts = nil, opts = {counter: nil})
    fetched_heading = false
    # :nocov:
    label = case field_or_opts
    when NilClass
      fetched_heading = true
      document_presenter(doc).heading
    when Hash
      fetched_heading = true
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

    if fetched_heading
      labels = label.split("<br>")
      label = labels.lazy.map { |l| truncate_title(l) }.to_a.join("<br>")
    else
      label = truncate_title(label)
    end

    Deprecation.silence(Blacklight::UrlHelperBehavior) do
      # rubocop:disable Rails/OutputSafety
      clean_label = HTMLEntities.new.decode(label)
      link_to clean_label.html_safe, url_for_document(doc), document_link_params(doc, opts.merge({class: "text-break"}))
      # rubocop:enable Rails/OutputSafety
    end
  end

  def truncate_title(title)
    if current_page?(search_catalog_path)
      title.truncate(175, separator: " ")
    else
      title
    end
  end
end
