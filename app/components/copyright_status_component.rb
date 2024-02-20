# frozen_string_literal: true

class CopyrightStatusComponent < ViewComponent::Base
  include CopiesDirectHelper

  def initialize(document, copyright)
    @document = document
    @copyright = copyright
  end

  def info
    @copyright
  end

  def render?
    @copyright.present? && @copyright["contextMsg"].present?
  end
end
