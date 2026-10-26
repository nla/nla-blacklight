# frozen_string_literal: true

require "csv"

module Nla
  module Exports
    ##
    # Renders catalogue bookmark documents as a CSV string.
    #
    # The main title and public fields displayed on the record show view,
    # with the Catalogue persistent identifier URL as the final column.
    class CsvExport
      PERSISTENT_ID_LABEL = "Catalogue persistent identifier"

      def initialize(documents, fields, title_field: "title_tsim")
        @documents = documents
        @fields = fields.reject { |field| field.component == StaffOnlyComponent }
        @title_field = title_field
      end

      def render
        CSV.generate do |csv|
          csv << header
          @documents.each do |document|
            csv << row(document).map { |value| spreadsheet_safe(value) }
          end
        end
      end

      private

      def header
        ["Title"] + @fields.map { |field| field.display_label } + [PERSISTENT_ID_LABEL]
      end

      def row(document)
        [flatten(document.fetch(@title_field, nil)).join("; ")] +
          @fields.map { |field| cell(document, field) } + [document.catalogue_persistent_url]
      end

      def spreadsheet_safe(value)
        value.match?(/\A(?:\s*[=+@-]|[\t\r\n])/) ? "'#{value}" : value
      end

      def cell(document, field)
        return "" unless visible?(document, field)

        value = retrieve(document, field)
        return copyright_text(document, value) if field.key.to_s == "copyright_info" && value.present?

        flatten(value).join(separator(field))
      end

      def copyright_text(document, value)
        html = ApplicationController.render(CopyrightStatusComponent.new(document, value), layout: false)
        Nokogiri::HTML.fragment(html).text.squish
      end

      def visible?(document, field)
        conditional = field.if
        return true unless conditional.is_a?(Proc)

        conditional.call(nil, field, document)
      rescue KeyError => error
        Rails.logger.warn("Bookmark CSV field #{field.key} skipped: #{error.class}")
        false
      end

      def retrieve(document, field)
        if field.accessor == true
          document.send(field.field)
        elsif field.accessor.present?
          if document.method(field.accessor).arity.zero?
            document.public_send(field.accessor)
          else
            document.public_send(field.accessor, field.field)
          end
        else
          document.fetch(field.field, nil)
        end
      rescue NoMethodError, KeyError
        # mirrors SolrDocument's key_error_handler (nil) so one malformed
        # document does not break the whole export
        nil
      end

      def separator(field)
        field.separator_options ? field.separator_options.values.first.to_s : "; "
      end

      def flatten(value)
        case value
        when Array
          value.flat_map { |item| flatten(item) }
        when Hash
          flatten_hash(value)
        when RelatedRecords
          [value.collection_name.presence || value.collection_id.to_s]
        when nil
          []
        else
          [value.to_s]
        end
      end

      def flatten_hash(hash)
        text = hash[:text] || hash["text"]
        href = hash[:href] || hash["href"]
        [text, href].compact
      end
    end
  end
end
