# frozen_string_literal: true

module Nla
  module Exports
    ##
    # Renders catalogue bookmark documents as a RIS (Research Information
    # Systems) string, one record per bookmarked document.
    class RISExport
      RECORD_TYPES = {
        "book" => "BOOK",
        "journal" => "JOUR",
        "magazine" => "MGZN",
        "map" => "MAP",
        "manuscript" => "MANSCPT",
        "picture" => "ART",
        "audio" => "SOUND",
        "score" => "MUSIC",
        "sound recording" => "SOUND",
        "video" => "VIDEO",
        "video recording" => "VIDEO",
        "website" => "WEB"
      }.freeze

      def initialize(documents)
        @documents = documents
      end

      def render
        @documents.map { |document| "#{record(document)}\n\n" }.join
      end

      private

      def record(document)
        lines = []
        lines << "TY  - #{record_type(document)}"
        authors(document).each { |author| lines << "AU  - #{author}" }
        lines << "TI  - #{title(document)}" if title(document).present?
        lines << "T2  - #{uniform_title(document)}" if uniform_title(document).present?
        lines << "PY  - #{pubdate(document)}" if pubdate(document).present?
        lines << "CY  - #{place(document)}" if place(document).present?
        lines << "PB  - #{publisher(document)}" if publisher(document).present?
        lines << "AB  - #{summary(document)}" if summary(document).present?
        serial_numbers = identifiers(document)
        serial_numbers.each { |_, value| lines << "SN  - #{value}" }
        record_url = document.catalogue_persistent_url
        lines << "AN  - #{record_url}"
        resource_urls = urls(document)
        if resource_urls.empty?
          lines << "UR  - #{record_url}"
        else
          resource_urls.each { |url| lines << "UR  - #{url}" }
          lines << "N1  - Record URL: #{record_url}"
        end
        # Zotero keeps the first UR in its URL field; preserve additional URLs in notes.
        resource_urls.drop(1).each { |url| lines << "N1  - Online resource: #{url}" }
        lines << "ER  - "
        lines.map { |line| line.gsub(/[\r\n]+/, " ") }.join("\n")
      end

      def record_type(document)
        format = document.first("format")
        RECORD_TYPES[format&.downcase] || "GEN"
      end

      def authors(document)
        document.all_authors&.map(&:to_s) || []
      end

      def title(document)
        document.first("title_tsim")
      end

      def uniform_title(document)
        document.first("uniform_title_ssim")
      end

      def pubdate(document)
        document.fetch("date_lower_isi", nil)
      end

      def place(document)
        document.publication_place.to_s.delete_suffix(":")
      end

      def publisher(document)
        document.publisher&.first
      end

      def summary(document)
        Array(document.summary).join(" ")
      end

      def identifiers(document)
        fields = [["ISBN", "isbn_tsim"], ["ISSN", "issn_display_ssim"]]
        fields.reverse! if %w[JOUR MGZN].include?(record_type(document))
        fields.flat_map do |label, field|
          Array(document.fetch(field, nil)).filter_map do |value|
            number = value.to_s.strip
            [label, number] if number.present?
          end
        end.uniq { |_, value| value }
      end

      def urls(document)
        # Export all 856 $u values, regardless of indicators, rather than only
        # the "Online Version" subset used by the record display.
        document.marc_xml.xpath("//datafield[@tag='856']/subfield[@code='u']")
          .map { |subfield| subfield.text.strip }.compact_blank.uniq
      rescue KeyError
        # Documents without a MARC source have no access URLs, but still have AN.
        []
      end
    end
  end
end
