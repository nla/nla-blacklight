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
        cited_authors = []

        @document.all_authors.each do |author|
          cited_authors << author.to_s
        end

        cited_authors
      end

      def cite_pubdate
        if @document.first("date_lower_isi").present?
          @document.first("date_lower_isi").to_s
        end
      end

      def cite_url
        url = ""

        copy_access = @document.copy_access.first
        if copy_access.present?
          url += copy_access[:href].to_s
        end

        url
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
