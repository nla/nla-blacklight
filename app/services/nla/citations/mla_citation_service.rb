# frozen_string_literal: true

module Nla
  module Citations
    class MlaCitationService < CitationsService
      def export
        format = @document.first("format")

        result = []

        result << cite_authors
        result << "<em>#{@document.first("title_tsim")}</em>"
        if format.present? && format.casecmp("book").zero?
          result << cite_publisher
        end
        result << cite_pubdate
        result << cite_url

        "<span data-clipboard-target=\"source\">#{result.join(" ")}</span>"
      end

      def cite_authors
        cited_authors = super

        if cited_authors.present?
          "#{cited_authors.join(" and ")}."
        end
      end
    end
  end
end
