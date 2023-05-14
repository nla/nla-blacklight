# frozen_string_literal: true

class RequestItemComponent < ViewComponent::Base
  include RequestItemHelper

  def initialize(document:)
    @document = document
    @catalogue_services_client = CatalogueServicesClient.new
  end

  def render?
    !is_ned_item?(@document) || has_online_copy?(@document)
  end

  def holdings
    instance_id = @document.fetch("folio_instance_id_ssim").first
    @catalogue_services_client.get_holdings(instance_id: instance_id)
  end
end
