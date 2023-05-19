# frozen_string_literal: true

class CatalogueRecordActionsComponent < ViewComponent::Base
  include RequestItemHelper

  def initialize(document:)
    @document = document
  end

  def render_online?
    has_online_access?(@document) || has_online_copy?(@document)
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
      @document.online_access.first[:href]
    elsif @document.copy_access.present?
      @document.copy_access.first[:href]
    end
  end

  def render_request?
    Flipper.enabled?(:requesting) && (!is_ned_item?(@document) || has_online_copy?(@document))
  end
end
