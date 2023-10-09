# Extends Blacklight::Marc::DocumentExtension to override the registration of export formats
require "marc"

module Nla::Marc
  module DocumentExtension
    include Blacklight::Marc::DocumentExtension

    include Nla::Marc::DocumentExport

    def self.extended(document)
      # Register our exportable formats, we inherit these from MarcExport
      Nla::Marc::DocumentExport.register_export_formats(document)
    end
  end
end
