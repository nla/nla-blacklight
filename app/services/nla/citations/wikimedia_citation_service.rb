# frozen_string_literal: true

module Nla
  module Citations
    class WikimediaCitationService < CitationsService
      def export
        result = "{{Citation\n"

        format = @document.first("format")

        if format.downcase == "journal"
          result += " | title=[article title here]\n"
          result += " | author=[article author here]\n"
          result += " | author2=[first co-author here]\n"
          result += " | date=[date of publication]\n"
          result += " | journal=#{@document.first("title_tsim")}\n"
        else
          result += " | title=#{@document.first("title_tsim")}\n"
        end

        author_count = 1
        author = @document.first("author_with_relator_ssim")
        if author.present?
          result += " | author#{author_count}=#{author}\n"
          author_count += 1
        end

        @document.other_authors.each do |other_author|
          result += " | author#{author_count}=#{other_author}\n"
          author_count += 1
        end

        result += " | year=#{@document.first("date_lower_isi")}\n"

        publisher = @document.first("publisher_tsim")
        if publisher.present?
          result += " | publisher=#{publisher}\n"
        end

        isbns = @document.isbn_list
        if isbns.present?
          result += " | isbn=#{isbns.first}\n"
        end

        language = @document.first("language_ssim")
        result += if language.present?
          " | language=#{@document.first("language_ssim")}\n"
        else
          " | language=No linguistic content\n"
        end

        pi = @document.pi
        result += " | url=#{pi}\n" if pi.present?

        result + "}}"
      end
    end
  end
end
