# frozen_string_literal: true

require "csv"

module Nla
  module Exports
    ##
    # Renders catalogue bookmark documents as a CSV string.
    #
    # One column per field displayed on the record show view, in display order,
    # with the Catalogue persistent identifier URL as the final column.
    class CsvExport
      PERSISTENT_ID_LABEL = "Catalogue persistent identifier"

      def initialize(documents, fields)
        @documents = documents
        @fields = fields
      end

      def render
        CSV.generate do |csv|
          csv << header
          @documents.each do |document|
            csv << row(document)
          end
        end
      end

      private

      def header
        @fields.map { |field| field.display_label } + [PERSISTENT_ID_LABEL]
      end

      def row(document)
        @fields.map { |field| cell(document, field) } + [persistent_id_url(document)]
      end

      def persistent_id_url(document)
        "https://nla.gov.au/nla.cat-vn#{document.id}"
      end

      def cell(document, field)
        return "" unless visible?(document, field)

        flatten(retrieve(document, field)).join(separator(field))
      end

      # Staff-only, or backed by an external service rather than the
      # document's indexed fields, so excluded from the export
      EXCLUDED_FIELDS = %w[rights_information copyright_info].freeze

      def visible?(document, field)
        return false if EXCLUDED_FIELDS.include?(field.key.to_s)
        return false if field.component == StaffOnlyComponent

        conditional = field.if
        return true unless conditional.is_a?(Proc)

        conditional.call(nil, field, document)
      rescue
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
        if hash["contextMsg"]
          [hash["contextMsg"]]
        else
          text = hash[:text] || hash["text"]
          href = hash[:href] || hash["href"]
          [text, href].compact
        end
      end
    end
  end
end
