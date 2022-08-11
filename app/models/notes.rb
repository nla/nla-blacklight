# frozen_string_literal: true

class Notes
  include ActiveModel::Model

  attr_accessor :document

  def initialize(document)
    @document = document
  end

  def notes
    notes = get_notes

    # 880 notes
    more_notes = get_more_notes

    {notes: notes, more_notes: more_notes}
  end

  private

  def get_notes
    notes = []

    notes << document.get_marc_derived_field("500a:501a:502a:504a").flatten
    notes << document.get_marc_derived_field("513ab:516a:518a").flatten
    notes << document.get_marc_derived_field("521a:522a:524a:525a:526iabcdz").flatten
    notes << document.get_marc_derived_field("530abc3u:535abcdg:536abcdefgh").flatten
    notes << document.get_marc_derived_field("5463ab:547a").flatten
    notes << document.get_marc_derived_field("550a:552abcdefghijklmnopuz:556az").flatten
    notes << document.get_marc_derived_field("562abcde:565abcde:567a").flatten
    notes << document.get_marc_derived_field("580a:581a").flatten
    notes << document.get_marc_derived_field("583abcdefhijklnouz23", options: {separator: ", "})
    notes << document.get_marc_derived_field("5843ab:588a").flatten
    notes << document.get_marc_derived_field("900a:995abdpy").flatten

    notes.compact_blank.flatten
  end

  def get_more_notes
    more_notes = []

    more_notes << document.get_marc_derived_field_with_conditions("880", "a", "6", /^500/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "a", "6", /^501/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "a", "6", /^502/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "a", "6", /^504/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "ab", "6", /^513/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "a", "6", /^516/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "a", "6", /^518/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "a", "6", /^521/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "a", "6", /^522/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "a", "6", /^524/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "a", "6", /^525/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "abc3u", "6", /^530/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "abcdg", "6", /^535/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "a", "6", /^546/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "a", "6", /^547/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "a", "6", /^550/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "az", "6", /^556/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "abcde", "6", /^562/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "abcde", "6", /^565/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "a", "6", /^567/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "a", "6", /^580/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "a", "6", /^581/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "aa", "6", /^583/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "a", "6", /^900/).flatten
    more_notes << document.get_marc_derived_field_with_conditions("880", "abdpy", "6", /^995/).flatten

    more_notes.compact_blank.flatten
  end
end
