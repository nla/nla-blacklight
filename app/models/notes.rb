# frozen_string_literal: true

class Notes
  prepend MemoWise

  include ActiveModel::Model

  attr_accessor :document

  def initialize(document)
    @document = document
  end

  def values
    get_notes.presence
  end

  private

  def get_notes
    notes = document.get_marc_derived_field("500a:501a:502a:504a:513ab:516a:518a:521a:522a:524a:525a:526iabcdz:530abc3u:535abcdg:536abcdefgh:5463ab:547a:550a:552abcdefghijklmnopuz:556az:562abcde:565abcde:567a:580a:581a:583abcdefhijklnouz23:5843ab:588a:900a:995abdpy")
    notes&.compact_blank.presence
  end
  memo_wise :get_notes
end
