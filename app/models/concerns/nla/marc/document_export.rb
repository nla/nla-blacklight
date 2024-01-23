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

  # Modified to fix format check, since Blacklight will set an empty array if the "format" field is not found.
  # :nocov:
  def export_as_openurl_ctx_kev(format = nil)
    title = to_marc.find { |field| field.tag == "245" }
    author = to_marc.find { |field| field.tag == "100" }
    corp_author = to_marc.find { |field| field.tag == "110" }
    publisher_info = to_marc.find { |field| field.tag == "260" }
    edition = to_marc.find { |field| field.tag == "250" }
    isbn = to_marc.find { |field| field.tag == "020" }
    issn = to_marc.find { |field| field.tag == "022" }
    format = if format.present?
      format.is_a?(Array) ? format[0].downcase.strip : format.downcase.strip
    else
      ""
    end
    export_text = ""
    if format == "book"
      export_text << "ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rfr_id=info%3Asid%2Fblacklight.rubyforge.org%3Agenerator&amp;rft.genre=book&amp;"
      export_text << "rft.btitle=#{(title.nil? || title["a"].nil?) ? "" : CGI.escape(title["a"])}+#{(title.nil? || title["b"].nil?) ? "" : CGI.escape(title["b"])}&amp;"
      export_text << "rft.title=#{(title.nil? || title["a"].nil?) ? "" : CGI.escape(title["a"])}+#{(title.nil? || title["b"].nil?) ? "" : CGI.escape(title["b"])}&amp;"
      export_text << "rft.au=#{(author.nil? || author["a"].nil?) ? "" : CGI.escape(author["a"])}&amp;"
      export_text << "rft.aucorp=#{CGI.escape(corp_author["a"]) if corp_author["a"]}+#{CGI.escape(corp_author["b"]) if corp_author["b"]}&amp;" if corp_author.present?
      export_text << "rft.date=#{(publisher_info.nil? || publisher_info["c"].nil?) ? "" : CGI.escape(publisher_info["c"])}&amp;"
      export_text << "rft.place=#{(publisher_info.nil? || publisher_info["a"].nil?) ? "" : CGI.escape(publisher_info["a"])}&amp;"
      export_text << "rft.pub=#{(publisher_info.nil? || publisher_info["b"].nil?) ? "" : CGI.escape(publisher_info["b"])}&amp;"
      export_text << "rft.edition=#{(edition.nil? || edition["a"].nil?) ? "" : CGI.escape(edition["a"])}&amp;"
      export_text << "rft.isbn=#{(isbn.nil? || isbn["a"].nil?) ? "" : isbn["a"]}"
    elsif /journal/i.match?(format) # checking using include because institutions may use formats like Journal or Journal/Magazine
      export_text << "ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rfr_id=info%3Asid%2Fblacklight.rubyforge.org%3Agenerator&amp;rft.genre=article&amp;"
      export_text << "rft.title=#{(title.nil? || title["a"].nil?) ? "" : CGI.escape(title["a"])}+#{(title.nil? || title["b"].nil?) ? "" : CGI.escape(title["b"])}&amp;"
      export_text << "rft.atitle=#{(title.nil? || title["a"].nil?) ? "" : CGI.escape(title["a"])}+#{(title.nil? || title["b"].nil?) ? "" : CGI.escape(title["b"])}&amp;"
      export_text << "rft.aucorp=#{CGI.escape(corp_author["a"]) if corp_author["a"]}+#{CGI.escape(corp_author["b"]) if corp_author["b"]}&amp;" if corp_author.present?
      export_text << "rft.date=#{(publisher_info.nil? || publisher_info["c"].nil?) ? "" : CGI.escape(publisher_info["c"])}&amp;"
      export_text << "rft.issn=#{(issn.nil? || issn["a"].nil?) ? "" : issn["a"]}"
    else
      export_text << "ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Adc&amp;rfr_id=info%3Asid%2Fblacklight.rubyforge.org%3Agenerator&amp;"
      export_text << "rft.title=" + ((title.nil? || title["a"].nil?) ? "" : CGI.escape(title["a"]))
      export_text << ((title.nil? || title["b"].nil?) ? "" : CGI.escape(" ") + CGI.escape(title["b"]))
      export_text << "&amp;rft.creator=" + ((author.nil? || author["a"].nil?) ? "" : CGI.escape(author["a"]))
      export_text << "&amp;rft.aucorp=#{CGI.escape(corp_author["a"]) if corp_author["a"]}+#{CGI.escape(corp_author["b"]) if corp_author["b"]}" if corp_author.present?
      export_text << "&amp;rft.date=" + ((publisher_info.nil? || publisher_info["c"].nil?) ? "" : CGI.escape(publisher_info["c"]))
      export_text << "&amp;rft.place=" + ((publisher_info.nil? || publisher_info["a"].nil?) ? "" : CGI.escape(publisher_info["a"]))
      export_text << "&amp;rft.pub=" + ((publisher_info.nil? || publisher_info["b"].nil?) ? "" : CGI.escape(publisher_info["b"]))
      export_text << "&amp;rft.format=" + (format.nil? ? "" : CGI.escape(format))
    end
    # rubocop:disable Rails/OutputSafety
    export_text.html_safe if export_text.present?
    # rubocop:enable Rails/OutputSafety
  end
  # :nocov:
end
