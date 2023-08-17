# frozen_string_literal: true

module Nla
  module Citations
    class CitationsService
      def initialize(document)
        @document = document
      end

      def self.cite(*args)
        new(*args).export
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
        if @document.first("date_lower_isi").present?
          @document.first("date_lower_isi").to_s
        end
      end

      def cite_url
        if @document.copy_access.present?
          @document.copy_access.first[:href].presence
        end
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
