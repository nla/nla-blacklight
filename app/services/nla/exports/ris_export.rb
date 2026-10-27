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
        "score" => "MUSIC",
        "sound recording" => "AUDIO",
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
        lines << "AN  - #{document.catalogue_persistent_url}"
        urls(document).each { |url| lines << "UR  - #{url}" }
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
