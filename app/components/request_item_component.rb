# frozen_string_literal: true

class RequestItemComponent < ViewComponent::Base
  include RequestItemHelper

  def initialize(document:)
    @document = document
  end

  def render?
    Flipper.enabled?(:requesting) && (!is_ned_item?(@document) || has_online_copy?(@document))
  end

  def holdings
    instance_id = @document.first("folio_instance_id_ssim")
    cat_services_client.get_holdings(instance_id: instance_id)
  end

  def recent_item_issue_held(holding)
    most_recent = holding["holdingsStatements"].last

    if most_recent.present?
      if most_recent["statement"].present?
        most_recent["statement"]
      elsif most_recent["note"].present?
        most_recent["enumeration"]
      end
    end
  end

  def items_issues_held(holding)
    holding["holdingsStatements"].map do |statement|
      if statement["statement"].present?
        statement["statement"]
      elsif statement["note"].present?
        statement["note"]
      end
    end
  end

  def supplements(holding)
    holding["holdingsStatementsForSupplements"].pluck("note")
  end

  def indexes(holding)
    holding["holdingsStatementsForIndexes"].pluck("note")
  end

  def request_item_link(item)
    instance_id = @document.first("folio_instance_id_ssim")
    holdings_id = item["holdingsRecordId"]
    item_id = item["id"]
    link_to t("requesting.btn_select"), new_solr_document_request_path(solr_document_id: @document.id, instance: instance_id, holdings: holdings_id, item: item_id), class: "btn btn-primary"
  end

  private

  def cat_services_client
    @catalogue_services_client ||= CatalogueServicesClient.new
  end
end
