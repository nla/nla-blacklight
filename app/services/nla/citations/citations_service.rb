# frozen_string_literal: true

module Nla
  module Citations
    class CitationsService
      def initialize(document)
        @document = document
      end

      def self.cite(*)
        new(*).export
      end

      # Override this in subclasses to provide the citation format
      def export
      end

      def cite_authors
        @document.all_authors&.map do |author|
          author.to_s
        end
      end

      def cite_pubdate
        @document.fetch("date_lower_isi", nil)
      end

      def cite_url
        @document.copy_access_urls&.first[:href]&.presence
      end

      def cite_publisher
        if @document.publisher.present?
          if @document.publication_place.present?
            "#{@document.publisher} #{@document.publication_place}"
          else
            @document.publisher
          end
        end
      end
    end
  end
end
