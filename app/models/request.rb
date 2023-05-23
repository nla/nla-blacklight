# frozen_string_literal: true

class Request
  include ActiveModel::Model

  # FOLIO instance ID
  attr_accessor :instance_id

  # FOLIO holdings ID
  attr_accessor :holdings_id

  # FOLIO item ID
  attr_accessor :item_id

  # year of the serial issue
  attr_accessor :year

  # volume or number of the serial issue
  attr_accessor :enumeration

  # day or month of the serial issue
  attr_accessor :chronology

  # additional notes for the request
  attr_accessor :notes

  # item barcode
  attr_accessor :barcode

  # holdings data
  attr_accessor :holding

  # item data
  attr_accessor :item

  def initialize(instance_id:, holdings_id:, item_id:)
    @instance_id = instance_id
    @holdings_id = holdings_id
    @item_id = item_id
  end
end
