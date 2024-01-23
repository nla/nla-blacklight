# frozen_string_literal: true

module Nla
  module Citations
    class ApaCitationService < CitationsService
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
          "(#{cited_pubdate})."
        end
      end

      def cite_publisher
        cited_publisher = ""

        publisher = @document.publisher
        if publisher.present?
          publication_place = @document.publication_place
          cited_publisher += if publication_place.present?
            "#{publication_place} : #{publisher.first}"
          else
            publisher.first
          end
        end

        cited_publisher
      end
    end
  end
end
