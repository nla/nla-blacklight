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
