# frozen_string_literal: true

class CopyrightStatusComponent < ViewComponent::Base
  include CopyrightStatusHelper

  def initialize(copyright:)
    @copyright = copyright
  end

  def info
    @copyright.info
  end

  def render?
    @copyright.present? && info.present? && info["contextMsg"].present?
  end
end
