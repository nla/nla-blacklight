# Extends Blacklight::Marc::DocumentExtension to override the registration of export formats
require "marc"

module NLA::Marc
  module DocumentExtension
    include Blacklight::Marc::DocumentExtension

    def self.extended(document)
      # Register our exportable formats, we inherit these from MarcExport
      NLA::Marc::DocumentExport.register_export_formats(document)
    end
  end
end
