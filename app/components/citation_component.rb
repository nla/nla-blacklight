# frozen_string_literal: true

class CitationComponent < ::Blacklight::Component
  DEFAULT_FORMATS = {
    "blacklight.citation.apa": :export_as_nla_apa_citation_txt,
    "blacklight.citation.mla": :export_as_nla_mla_citation_txt,
    "citation.harvard": :export_as_nla_harvard_citation_txt,
    "citation.wikipedia": :export_as_nla_wikipedia_citation_txt
  }.freeze

  with_collection_parameter :document

  def initialize(document:, formats: DEFAULT_FORMATS)
    @document = document
    @formats = formats.select { |_k, v| @document.respond_to?(v) }
  end
end
