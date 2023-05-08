# frozen_string_literal: true

class CopyrightStatusComponent < ViewComponent::Base
  include CopyrightStatusHelper

  def initialize(copyright:)
    @copyright = copyright
  end

  def info
    @copyright.info
  end

  def document
    @copyright.document
  end

  def render?
    @copyright.present? && info.present?
  end
end
