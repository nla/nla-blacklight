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
    rescue ServiceTokenError, HoldingsRequestError => e
      @error = "Unable to retrieve holdings for #{@document.first("title_tsim")}"
      Rails.logger.error "Unable to retrieve holdings for #{@document.id}: #{e}"
    end
  end

  delegate :recent_item_issue_held, to: :helpers

  delegate :items_issues_held, to: :helpers

  delegate :supplements, to: :helpers

  delegate :indexes, to: :helpers

  def request_item_link(item)
    holdings_id = item["holdingsRecordId"]
    item_id = item["id"]
    link_to t("requesting.btn_select"), solr_document_request_new_path(solr_document_id: @document.id, holdings: holdings_id, item: item_id), class: "btn btn-primary", target: "_top"
  end

  private

  def cat_services_client
    @catalogue_services_client ||= CatalogueServicesClient.new
  end
end
