# frozen_string_literal: true

class InvalidIsbn
  include Nla::IsbnExtraction

  def initialize(marc_xml)
    @marc_xml = marc_xml
  end

  def value
    get_isbn(tag: "020", sfield: "z", qfield: "q", use_880: true)
  end
end
