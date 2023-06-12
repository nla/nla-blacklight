# frozen_string_literal: true

class CitationComponent < ::Blacklight::Component
  DEFAULT_FORMATS = {
    'blacklight.citation.mla': :export_as_mla_citation_txt,
    'blacklight.citation.apa': :export_as_apa_citation_txt,
    'blacklight.citation.chicago': :export_as_chicago_citation_txt
  }.freeze

  with_collection_parameter :document

  def initialize(document:, formats: DEFAULT_FORMATS)
    @document = document
    @formats = formats.select { |_k, v| @document.respond_to?(v) }
  end

  def persistent_id_link
    link_to "https://nla.gov.au/nla.cat-vn#{@document.id}", "https://nla.gov.au/nla.cat-vn#{@document.id}"
  end
end
