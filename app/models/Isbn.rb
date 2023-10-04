# frozen_string_literal: true

class Isbn
  include Nla::IsbnExtraction

  def initialize(document)
    @document = document
    @marc_xml = document.marc_xml
  end

  def valid_isbn(*_args)
    @valid_isbn ||= get_isbn(tag: "020", sfield: "a", qfield: "q", use_880: true)
  end

  def invalid_isbn(*_args)
    @invalid_isbn ||= get_isbn(tag: "020", sfield: "z", qfield: "q", use_880: true)
  end

  def isbn_list(*_args)
    @isbn_list ||= @document.fetch("isbn_tsim", [])&.map { |isbn| clean_isn(isbn) }
  end

  private

  def clean_isn(isn)
    isn = isn.gsub(/[\s-]+/, '\1')
    isn = isn.gsub(/^.*?([0-9]+).*?$/, '\1')
    isn.gsub(/\s+/, "")
  end
end
