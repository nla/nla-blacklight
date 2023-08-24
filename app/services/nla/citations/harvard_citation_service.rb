# frozen_string_literal: true

module Nla
  module Citations
    class HarvardCitationService < CitationsService
      def export
        format = @document.first("format")

        result = []

        result << cite_authors
        result << cite_pubdate
        result << "<em>#{@document.first("title_tsim")}</em>."
        if format.present? && format.casecmp("book").zero?
          result << cite_publisher
        end
        result << cite_url

        "<span data-clipboard-target=\"source\">#{result.join(" ")}</span>"
      end

      def cite_authors
        cited_authors = super

        if cited_authors.present?
          "#{cited_authors.join(" & ")}."
        end
      end

      def cite_pubdate
        cited_pubdate = super

        if cited_pubdate.present?
          "#{cited_pubdate},"
        else
          "n.d.,"
        end
      end
    end
  end
end
