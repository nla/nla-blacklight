# frozen_string_literal: true

class CatalogueRecordActionsComponent < ViewComponent::Base
  include RequestItemHelper

  def initialize(document:)
    @document = document
  end

  def render_online?
    has_online_access?(@document) || has_online_copy?(@document) || is_ned_item?(@document) || is_electronic_resource?(@document)
  end

  def online_label
    format = @document.first("format")
    if format.present? && format.include?("Audio")
      "Listen"
    else
      "View online"
    end
  end

  def online_url
    href = if @document.online_access_urls.present?
      @document.online_access_urls.first[:href]
    elsif @document.copy_access_urls.present?
      @document.copy_access_urls.first[:href]
    end

    if @document.has_eresources?
      entry = Eresources.new.known_url(href)

      if entry.present?
        helpers.offsite_catalog_path(id: @document.id, url: href)
      else
        href
      end
    else
      href
    end
  end

  def render_request?
    !is_ned_item?(@document) && !has_no_physical_holdings?(@document)
  end
end
