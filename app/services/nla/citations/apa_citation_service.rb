# frozen_string_literal: true

module Nla
  module Citations
    class ApaCitationService < CitationsService
      def export
        format = @document.first("format").downcase

        result = []

        result << cite_authors
        result << "(#{@document.first("date_lower_isi")})." if @document.first("date_lower_isi").present?
        result << "<em>#{@document.first("title_tsim")}</em>."
        if format == "book"
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

      def cite_publisher
        cited_publisher = ""

        publisher = @document.publisher
        if publisher.present?
          publication_place = @document.publication_place
          cited_publisher += if publication_place.present?
            "#{publication_place} : #{publisher}"
          else
            publisher
          end
        end

        cited_publisher
      end
    end
  end
end
