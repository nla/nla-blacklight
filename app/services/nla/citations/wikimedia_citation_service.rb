# frozen_string_literal: true

module Nla
  module Citations
    class WikimediaCitationService < CitationsService
      def export
        result = "{{Citation\n"

        format = @document.first("format")

        title = build_title(format)
        if title.present?
          result += title
        end

        authors = build_authors
        if authors.present?
          result += authors
        end

        pub_date = build_pubdate
        if pub_date.present?
          result += pub_date
        end

        publisher = build_publisher
        if publisher.present?
          result += publisher
        end

        isbns = build_isbns
        if isbns.present?
          result += isbns
        end

        language = build_language
        if language.present?
          result += language
        end

        pi = build_pi
        if pi.present?
          result += pi
        end

        result + "}}"
      end

      def build_title(format)
        title = ""

        if format.present? && format.casecmp("journal").zero?
          title += " | title=[article title here]\n"
          title += " | author=[article author here]\n"
          title += " | author2=[first co-author here]\n"
          title += " | date=[date of publication]\n"
          title += " | journal=#{@document.first("title_tsim")}\n"
        else
          title += " | title=#{@document.first("title_tsim")}\n"
        end

        title
      end

      def build_authors
        author_string = ""

        authors = cite_authors
        if authors.present?
          authors.each_with_index do |author, author_count|
            author_string += " | author#{author_count + 1}=#{author}\n"
          end
        end

        author_string
      end

      def build_pubdate
        cited_pubdate = cite_pubdate

        if cited_pubdate.present?
          " | year=#{cited_pubdate}\n"
        end
      end

      def build_publisher
        publisher = @document.publisher
        if publisher.present?
          " | publisher=#{publisher}\n"
        end
      end

      def build_isbns
        isbns = @document.isbn_list
        if isbns.present?
          " | isbn=#{isbns.first}\n"
        end
      end

      def build_language
        language = @document.first("language_ssim")
        if language.present?
          " | language=#{language}\n"
        else
          " | language=No linguistic content\n"
        end
      end

      def build_pi
        pi = @document.pi
        if pi.present?
          " | url=#{pi.first}\n"
        end
      end
    end
  end
end
