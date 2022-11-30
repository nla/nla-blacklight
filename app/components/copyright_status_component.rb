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

  def renderCopiesDirectForm?
    %w[3 4 6 7].exclude? info["contextMsg"]
  end
end
