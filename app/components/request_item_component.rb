# frozen_string_literal: true

class RequestItemComponent < ViewComponent::Base
  include RequestItemHelper

  def initialize(document:)
    @document = document
    @catalogue_services_client = CatalogueServicesClient.new
  end

  def render?
    Flipper.enabled?(:requesting) && (!is_ned_item?(@document) || has_online_copy?(@document))
  end

  def holdings
    instance_id = @document.first("folio_instance_id_ssim")
    @catalogue_services_client.get_holdings(instance_id: instance_id)
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
end
