# frozen_string_literal: true

class RequestItemComponent < ViewComponent::Base
  include RequestItemHelper

  attr_accessor :error

  attr_accessor :holdings

  def initialize(document:)
    @document = document
    @error = nil
    @holdings = []
  end

  def render?
    helpers.render_request?(@document)
  end

  def before_render
    instance_id = @document.first("folio_instance_id_ssim")
    begin
      @holdings = cat_services_client.get_holdings(instance_id: instance_id)
    rescue ServiceTokenError, HoldingsRequestError, StandardError => e
      @error = "Unable to retrieve holdings for #{@document.first("title_tsim")}"
      Rails.logger.error "Unable to retrieve holdings for #{@document.id}: #{e}"
    end
  end

  delegate :items_issues_in_use, to: :helpers

  delegate :recent_item_issue_held, to: :helpers

  delegate :items_issues_held, to: :helpers

  delegate :supplements, to: :helpers

  delegate :indexes, to: :helpers

  delegate :holding_notes, to: :helpers

  delegate :access_condition_notes, to: :helpers

  def request_item_link(item)
    holdings_id = item["holdingsRecordId"]
    item_id = item["id"]

    if item["displayStatus"] == "In use"
      button_to I18n.t("requesting.btn_in_use"), "#", target: "_top", class: "btn btn-primary", disabled: true
    elsif item["requestable"]
      link_to I18n.t("requesting.btn_select"), solr_document_request_new_path(solr_document_id: @document.id, holdings: holdings_id, item: item_id), class: "btn btn-primary", target: "_top"
    end
  end

  private

  def cat_services_client
    @catalogue_services_client ||= CatalogueServicesClient.new
  end
end
