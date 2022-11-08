# Override #register_export_formats to remove Refworks export link
module NLA::Marc::DocumentExport
  include Blacklight::Marc::DocumentExport

  def self.register_export_formats(document)
    document.will_export_as(:xml)
    document.will_export_as(:marc, "application/marc")
    # marcxml content type:
    # http://tools.ietf.org/html/draft-denenberg-mods-etc-media-types-00
    document.will_export_as(:marcxml, "application/marcxml+xml")
    document.will_export_as(:openurl_ctx_kev, "application/x-openurl-ctx-kev")
    document.will_export_as(:endnote, "application/x-endnote-refer")
  end
end
