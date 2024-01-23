module Nla
  module IsbnExtraction
    extend ActiveSupport::Concern

    def get_marc_datafields_from_xml(xpath)
      @marc_xml.xpath(xpath).presence
    end

    def get_isbn(tag:, sfield:, qfield:, use_880: false)
      elements = get_marc_datafields_from_xml("//datafield[@tag='#{tag}' and subfield[@code='#{sfield}']]")
      isbn = [*extract_isbn(elements: elements, tag: tag, sfield: sfield, qfield: qfield)]
      if use_880
        elements_880 = get_marc_datafields_from_xml("//datafield[@tag='880' and subfield[@code='6' and starts-with(.,'#{tag}-')]]")
        isbn += [*extract_isbn(elements: elements_880, tag: tag, sfield: sfield, qfield: qfield)]
      end
      isbn.compact_blank.presence
    end

    # Extracts ISBNs from MARC. The MARCXML must be read sequentially, where a single 020 tag may contain subfields like:
    # [$a, $q, $q, $z, $q] and only the first sequence of [$a, $q, $q] should be extracted.
    # The `sfield` parameter is the primary subfield and the `qfield` provides a qualifier field.
    def extract_isbn(elements:, tag: "020", sfield: "a", qfield: "q")
      if elements.present?
        isbn = []
        elements.each do |el|
          text = []
          primary_found = false
          prev_subfield_code = ""
          el.children.each do |subfield|
            subfield_code = subfield.attribute("code").value
            if subfield_code != sfield && subfield_code != qfield
              primary_found = false
              next
            elsif subfield_code == sfield
              if prev_subfield_code == subfield_code
                isbn << text.join(" ")
                text = []
              end
              # strip extra punctuation and spaces
              clean_text = subfield.text[/^.*?([0-9X]+).*?$/, 1]
              text << (clean_text.presence || subfield.text)
              primary_found = true
            elsif primary_found && qfield.present? && subfield_code == qfield
              # strip extra punctuation and spaces, then wrap with parentheses
              clean_text = subfield.text[/^\s*(\w*)\s*:*\s*$/, 1]
              text << if clean_text.present?
                "(#{clean_text})"
              else
                "(#{subfield.text})"
              end
            end
            prev_subfield_code = subfield_code
          end
          isbn << text.join(" ")
        end
        isbn
      end
    end
  end
end
