# frozen_string_literal: true

class Notes
  prepend MemoWise

  include ActiveModel::Model

  attr_accessor :document

  def initialize(document)
    @document = document
  end

  def values
    @document.fetch("notes_tsim", nil)
  end
end
