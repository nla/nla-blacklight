# frozen_string_literal: true

module Nla
  module Citations
    class HarvardCitationService < CitationsService
      def export
        format = @document.first("format").downcase

        result = []

        result << cite_authors
        result << cite_pubdate
        result << "<em>#{@document.first("title_tsim")}</em>."
        if format == "book"
          result << cite_publisher
        end
        result << cite_url

        "<span data-clipboard-target=\"source\">#{result.join(" ")}</span>"
      end

      def cite_authors
        cited_authors = []

        author = @document.first("author_with_relator_ssim")
        cited_authors << author.to_s if author.present?

        other_authors = @document.other_authors
        other_authors.each do |other|
          cited_authors << other.to_s
        end

        if cited_authors.present?
          "#{cited_authors.join(" & ")}."
        end
      end

      def cite_pubdate
        pub_date = @document.first("date_lower_isi")
        if pub_date.present?
          "#{@document.first("date_lower_isi")},"
        else
          "n.d., "
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
