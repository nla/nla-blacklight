# frozen_string_literal: true

class Notes
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
    notes = []

    notes << document.get_marc_derived_field("500a:501a:502a:504a")
    notes << document.get_marc_derived_field("513ab:516a:518a")
    notes << document.get_marc_derived_field("521a:522a:524a:525a:526iabcdz")
    notes << document.get_marc_derived_field("530abc3u:535abcdg:536abcdefgh")
    notes << document.get_marc_derived_field("5463ab:547a")
    notes << document.get_marc_derived_field("550a:552abcdefghijklmnopuz:556az")
    notes << document.get_marc_derived_field("562abcde:565abcde:567a")
    notes << document.get_marc_derived_field("580a:581a")
    notes << document.get_marc_derived_field("583abcdefhijklnouz23")
    notes << document.get_marc_derived_field("5843ab:588a")
    notes << document.get_marc_derived_field("900a:995abdpy")

    notes.compact_blank.flatten.presence
  end
end
