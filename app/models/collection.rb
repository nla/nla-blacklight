# frozen_string_literal: true

require "blacklight"

class Collection
  def initialize(marc_rec)
    @marc_rec = marc_rec
  end

  def value
    @related_records ||= get_related_records
  end

  private

  def get_related_records
    ids = MarcDerivedField.instance.derive(@marc_rec, "0359")
    collection_id = ids&.first

    related_records = []

    # Check for related collections in the 773 subfield
    related_773_records = []
    related_773 = MarcDerivedField.instance.derive(@marc_rec, "773w")
    related_773&.each do |r|
      rec = RelatedRecords.new(@marc_rec, collection_id, "773", r)
      related_773_records << rec if rec.in_collection?
    end

    # Check for related collections in the 973 subfield
    related_973_records = []
    related_973 = MarcDerivedField.instance.derive(@marc_rec, "973w")
    related_973&.each do |r|
      rec = RelatedRecords.new(@marc_rec, collection_id, "973", r)
      related_973_records << rec if rec.in_collection?
    end

    # If there are no 973 or 773 records, but there is a collection ID, then this could be a
    # parent collection.
    if related_773_records.blank? && related_973_records.blank?
      related_records << RelatedRecords.new(@marc_rec, collection_id, nil, nil)
    else
      related_records += related_773_records
      related_records += related_973_records
    end

    if related_records.present?
      # Check if any of any of the collections this record belongs to is really a collection,
      # because it's possible for a parent collection not to have any children.
      visible = !related_records.find { |rec| rec.in_collection? }.nil?

      # There is at least one collection, so let's render the Related Records section
      return related_records if visible
    end

    # Record is not part of any collection, return an empty array
    nil
  end
end
