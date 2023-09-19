# frozen_string_literal: true

class Series
  prepend MemoWise

  include ActiveModel::Model

  attr_accessor :document

  def initialize(document)
    @document = document
  end

  def values
    series = []

    if non_800_exists?
      series += document.get_marc_derived_field("490avx") || []
    end

    series += document.get_marc_derived_field("440anpvx:800abcdknpqtvx:810abcdknptvx:811acdefklnpqtvx:830anpvx") || []

    series.compact_blank.flatten.presence
  end

  private

  def non_800_exists?
    document.get_marc_derived_field("490|1*|").blank?
  end
end
