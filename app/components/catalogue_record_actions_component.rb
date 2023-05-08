# frozen_string_literal: true

class CatalogueRecordActionsComponent < ViewComponent::Base
  def initialize(document:)
    @document = document
  end

  def render_online?
    @document.copy_access.present? && @document.copy_access.first[:href].include?("nla.gov.au")
  end

  def online_url
    @document.copy_access.first[:href]
  end

  def render_request?
    Flipper.enabled? :requesting
  end

  def request_label
    if @document.fetch("format").first == "Picture"
      "View at library"
    else
      "Request"
    end
  end
end
