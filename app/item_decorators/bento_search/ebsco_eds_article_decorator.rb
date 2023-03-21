module BentoSearch
  class EbscoEdsArticleDecorator < StandardDecorator
    def render_source_info
      parts = []

      if custom_data[:citation_blob].present?
        parts << _h.content_tag("span", custom_data["citation_blob"], class: "source_title")
        parts << ". "
      elsif source_title.present?
        parts << _h.content_tag("span", source_title, class: "source_title")
        parts << ". "
      elsif publisher.present?
        parts << _h.content_tag("span", publisher, class: "publisher")
        parts << ". "
      end

      text = render_citation_details
      if text.present?
        parts << text << "."
      end

      _h.safe_join(parts, "")
    end

    def render_citation_details
      result_elements = []
      result_elements.push custom_data[:citation_blob]

      return nil if result_elements.empty?

      # rubocop:disable Rails/OutputSafety
      result_elements.join(", ").html_safe
      # rubocop:enable Rails/OutputSafety
    end
  end
end
