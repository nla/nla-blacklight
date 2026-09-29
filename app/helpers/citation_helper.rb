# frozen_string_literal: true

module CitationHelper
  CITATION_FORMATS = {
    "blacklight.citation.apa": :export_as_apa_citation_txt,
    "blacklight.citation.mla": :export_as_mla_citation_txt,
    "citation.harvard": :export_as_harvard_citation_txt,
    "citation.wikipedia": :export_as_wikipedia_citation_txt
  }.freeze

  def citation_copy_all_text(citation_method, documents)
    documents.map do |document|
      citation = sanitize(document.send(citation_method).to_s)

      if citation_method == :export_as_wikipedia_citation_txt
        # the Wikipedia template already embeds the persistent identifier URL
        citation
      else
        persistent_id = "#{t("citation.persistent_id")}: https://nla.gov.au/nla.cat-vn#{document.id}"
        [citation, persistent_id].compact_blank.join("\n")
      end
    end.join("\n\n")
  end
end
