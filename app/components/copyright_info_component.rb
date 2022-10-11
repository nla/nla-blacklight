# frozen_string_literal: true

class CopyrightInfoComponent < ViewComponent::Base
  include CopyrightHelper

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

  def renderCopiesDirectForm?
    info["contextMsg"] != "3" && info["contextMsg"] != "4" && info["contextMsg"] != "6" && info["contextMsg"] != "7"
  end
end
