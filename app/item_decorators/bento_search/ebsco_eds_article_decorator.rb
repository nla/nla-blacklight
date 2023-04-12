module BentoSearch
  class EbscoEdsArticleDecorator < StandardDecorator
    def render_source_info
      parts = []

      if source_title.present?
        parts << _h.content_tag("span", source_title, class: "source_title")
        parts << ". "
      elsif publisher.present?
        parts << _h.content_tag("span", publisher, class: "publisher")
        parts << ". "
      end

      _h.safe_join(parts, "")
    end
  end
end
