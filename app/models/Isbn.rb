# frozen_string_literal: true

class Isbn
  include Nla::IsbnExtraction

  def initialize(marc_xml)
    @marc_xml = marc_xml
  end

  def valid_isbn
    @valid_isbn ||= get_isbn(tag: "020", sfield: "a", qfield: "q", use_880: true)
  end

  def invalid_isbn
    @invalid_isbn ||= get_isbn(tag: "020", sfield: "z", qfield: "q", use_880: true)
  end
end
