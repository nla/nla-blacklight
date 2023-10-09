# frozen_string_literal: true

class CitationComponent < ::Blacklight::Component
  DEFAULT_FORMATS = {
    "blacklight.citation.apa": :export_as_apa_citation_txt,
    "blacklight.citation.mla": :export_as_mla_citation_txt,
    "citation.harvard": :export_as_harvard_citation_txt,
    "citation.wikipedia": :export_as_wikipedia_citation_txt
  }.freeze

  with_collection_parameter :document

  def initialize(document:, formats: DEFAULT_FORMATS)
    @document = document
    @formats = formats.select { |_k, v| @document.respond_to?(v) }
  end

  def title
    presenter.heading
  end

  def presenter
    helpers.document_presenter(@document)
  end
end
