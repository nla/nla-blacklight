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
        author = @document.first("author_with_relator_ssim")
        if author.present?
          cited_authors << author.to_s
        end

        @document.other_authors.each do |other_author|
          cited_authors << other_author.to_s
        end

        cited_authors
      end

      def cite_url
        url = ""

        copy_access = @document.copy_access.first
        if copy_access.present? && copy_access[:href].include?("nla.gov.au")
          url += copy_access[:href].to_s
        end

        url
      end
    end
  end
end
