# frozen_string_literal: true

module CitationHelper
  CITATION_FORMATS = {
    "blacklight.citation.apa": :export_as_apa_citation_txt,
    "blacklight.citation.mla": :export_as_mla_citation_txt,
    "citation.harvard": :export_as_harvard_citation_txt
  }.freeze

  def citation_copy_all_text(citation_method, documents)
    documents.map do |document|
      citation = CGI.unescapeHTML(strip_tags(document.public_send(citation_method).to_s))
      persistent_id = "#{t("citation.persistent_id")}: #{document.catalogue_persistent_url}"
      [citation, persistent_id].compact_blank.join("\n")
    end.join("\n\n")
  end

  def citation_copy_all_html(citation_method, documents)
    safe_join(documents.map do |document|
      citation = sanitize(document.public_send(citation_method).to_s,
        tags: %w[i em b strong u sub sup br a], attributes: %w[href])
      persistent_id = "#{t("citation.persistent_id")}: #{document.catalogue_persistent_url}"
      tag.p(safe_join([citation, persistent_id], tag.br))
    end)
  end
end
