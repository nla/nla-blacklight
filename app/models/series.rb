# frozen_string_literal: true

class Series
  prepend MemoWise

  include ActiveModel::Model

  attr_accessor :document

  def initialize(document)
    @document = document
  end

  def values
    @document.fetch("series_tsim", nil)
  end
end
