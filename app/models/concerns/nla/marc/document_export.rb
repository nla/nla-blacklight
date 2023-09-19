# frozen_string_literal: true

# Override #register_export_formats to remove Refworks export link
module Nla::Marc::DocumentExport
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

  def export_as_apa_citation_txt
    Nla::Citations::ApaCitationService.cite(self)
  end

  def export_as_mla_citation_txt
    Nla::Citations::MlaCitationService.cite(self)
  end

  def export_as_harvard_citation_txt
    Nla::Citations::HarvardCitationService.cite(self)
  end

  def export_as_wikipedia_citation_txt
    Nla::Citations::WikimediaCitationService.cite(self)
  end
end
