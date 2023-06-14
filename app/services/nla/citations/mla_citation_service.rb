# frozen_string_literal: true

module Nla
  module Citations
    class MlaCitationService < CitationsService
      def export
        format = @document.first("format").downcase

        result = []

        result << cite_authors
        result << "<em>#{@document.first("title_tsim")}</em>"
        if format == "book"
          result << cite_publisher
        end
        result << @document.first("date_lower_isi").to_s if @document.first("date_lower_isi").present?
        result << cite_url

        "<span data-clipboard-target=\"source\">#{result.join(" ")}</span>"
      end

      def cite_authors
        cited_authors = []
        author = @document.first("author_with_relator_ssim")
        if author.present?
          cited_authors << author.to_s
        end

        @document.other_authors.each do |other_author|
          cited_authors << other_author.to_s
        end

        if cited_authors.present?
          "#{cited_authors.join(" and ")}."
        end
      end

      def cite_publisher
        cited_publisher = ""

        publisher = @document.publisher
        if publisher.present?
          publication_place = @document.publication_place
          cited_publisher += if publication_place.present?
            "#{publisher} #{publication_place}"
          else
            publisher
          end
        end

        cited_publisher
      end
    end
  end
end
