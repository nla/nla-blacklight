# frozen_string_literal: true

class Series
  include ActiveModel::Model

  attr_accessor :document

  def initialize(document)
    @document = document
  end

  def values
    series = []

    if non_800_exists?
      series << document.get_marc_derived_field("490avx")&.flatten
    end

    series << document.get_marc_derived_field("440anpvx")&.flatten
    series << document.get_marc_derived_field("800abcdknpqtvx")&.flatten
    series << document.get_marc_derived_field("810abcdknptvx")&.flatten
    series << document.get_marc_derived_field("811acdefklnpqtvx")&.flatten
    series << document.get_marc_derived_field("830anpvx")&.flatten

    series.flatten.compact_blank.presence
  end

  private

  def non_800_exists?
    document.get_marc_derived_field("490|1*|")&.blank?
  end
end
