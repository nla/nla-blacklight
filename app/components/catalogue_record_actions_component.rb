# frozen_string_literal: true

class CatalogueRecordActionsComponent < ViewComponent::Base
  def initialize(document:)
    @document = document
  end

  def render?
    Flipper.enabled?(:requesting)
  end

  def render_online?
    has_online_access? || has_online_copy?
  end

  def online_label
    if @document.fetch("format").first == "Audio"
      "Listen"
    else
      "View online"
    end
  end

  def online_url
    if @document.online_access.present?
      @document.online_access.first[:href].include?("nla.gov.au")
    elsif @document.copy_access.present?
      @document.copy_access.first[:href].include?("nla.gov.au")
    else
      "#"
    end
  end

  def render_request?
    !is_ned_item? || has_online_copy?
  end

  private

  def has_online_copy?
    @document.copy_access.present? && @document.copy_access.first[:href].include?("nla.gov.au")
  end

  def has_online_access?
    @document.online_access.present? && @document.online_access.first[:href].include?("nla.gov.au")
  end

  alias_method :is_ned_item?, :has_online_access?
end
