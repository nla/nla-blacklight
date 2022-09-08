# frozen_string_literal: true

class Notes
  include ActiveModel::Model

  attr_accessor :document

  def initialize(document)
    @document = document
  end

  def values
    notes = get_notes

    # 880 notes
    more_notes = get_more_notes

    unless notes.empty? && more_notes.empty?
      {notes: notes, more_notes: more_notes}
    end
  end

  private

  def get_notes
    notes = []

    notes << document.get_marc_derived_field("500a:501a:502a:504a", options: {alternate_script: false})
    notes << document.get_marc_derived_field("513ab:516a:518a", options: {alternate_script: false})
    notes << document.get_marc_derived_field("521a:522a:524a:525a:526iabcdz", options: {alternate_script: false})
    notes << document.get_marc_derived_field("530abc3u:535abcdg:536abcdefgh", options: {alternate_script: false})
    notes << document.get_marc_derived_field("5463ab:547a", options: {alternate_script: false})
    notes << document.get_marc_derived_field("550a:552abcdefghijklmnopuz:556az", options: {alternate_script: false})
    notes << document.get_marc_derived_field("562abcde:565abcde:567a", options: {alternate_script: false})
    notes << document.get_marc_derived_field("580a:581a", options: {alternate_script: false})
    notes << document.get_marc_derived_field("583abcdefhijklnouz23", options: {separator: ", ", alternate_script: false})
    notes << document.get_marc_derived_field("5843ab:588a", options: {alternate_script: false})
    notes << document.get_marc_derived_field("900a:995abdpy", options: {alternate_script: false})

    notes.compact_blank.flatten
  end

  def get_more_notes
    more_notes = []

    more_notes << get_related_notes_from_xml("a", "500")
    more_notes << get_related_notes_from_xml("a", "501")
    more_notes << get_related_notes_from_xml("a", "502")
    more_notes << get_related_notes_from_xml("a", "504")
    more_notes << get_related_notes_from_xml("ab", "513")
    more_notes << get_related_notes_from_xml("a", "516")
    more_notes << get_related_notes_from_xml("a", "518")
    more_notes << get_related_notes_from_xml("a", "521")
    more_notes << get_related_notes_from_xml("a", "522")
    more_notes << get_related_notes_from_xml("a", "524")
    more_notes << get_related_notes_from_xml("a", "525")
    more_notes << get_related_notes_from_xml("abc3u", "530")
    more_notes << get_related_notes_from_xml("abcdg", "535")
    more_notes << get_related_notes_from_xml("a", "546")
    more_notes << get_related_notes_from_xml("a", "547")
    more_notes << get_related_notes_from_xml("a", "550")
    more_notes << get_related_notes_from_xml("az", "556")
    more_notes << get_related_notes_from_xml("abcde", "562")
    more_notes << get_related_notes_from_xml("abcde", "565")
    more_notes << get_related_notes_from_xml("a", "567")
    more_notes << get_related_notes_from_xml("a", "580")
    more_notes << get_related_notes_from_xml("a", "581")
    more_notes << get_related_notes_from_xml("aa", "583")
    more_notes << get_related_notes_from_xml("a", "900")
    more_notes << get_related_notes_from_xml("abdpy", "995")

    more_notes.compact_blank.flatten
  end

  def get_related_notes_from_xml(spec, qualifier)
    values = []
    nodes = document.get_marc_datafields_from_xml("//datafield[@tag='880'][subfield[@code='6' and starts-with(@, '#{qualifier}')]]/subfield[@code='#{spec}']")
    if nodes.present?
      nodes.each do |node|
        values << node.text
      end
    end
    values
  end
end
