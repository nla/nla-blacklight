# frozen_string_literal: true

class CopyrightInfoComponent < ViewComponent::Base
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
    @copyright.present?
  end
end
