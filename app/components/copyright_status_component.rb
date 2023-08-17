# frozen_string_literal: true

class CopyrightStatusComponent < ViewComponent::Base
  include CopyrightStatusHelper

  def initialize(copyright)
    @copyright = copyright
  end

  def info
    @copyright
  end

  def render?
    @copyright.present? && @copyright["contextMsg"].present?
  end
end
