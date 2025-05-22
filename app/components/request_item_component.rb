# frozen_string_literal: true

class RequestItemComponent < ViewComponent::Base
  include RequestItemHelper

  attr_accessor :error

  attr_accessor :holdings

  def initialize(document:)
    @document = document
    @error = nil
    instance_id = @document.first("folio_instance_id_ssim")
    begin
      result = CatalogueServicesClient.new.get_holdings(instance_id: instance_id)
      @holdings = result.is_a?(Array) ? result : []
    rescue ServiceTokenError, HoldingsRequestError, StandardError => e
      @error = "Unable to retrieve holdings for #{@document.first("title_tsim")}"
      Rails.logger.error "Unable to retrieve holdings for #{@document.id}: #{e}"
      @holdings = []
    end
  end

  def render?
    helpers.render_request?(@document)
  end

  def before_render
    instance_id = @document.first("folio_instance_id_ssim")
    begin
      @holdings = CatalogueServicesClient.new.get_holdings(instance_id: instance_id)
    rescue ServiceTokenError, HoldingsRequestError, StandardError => e
      @error = "Unable to retrieve holdings for #{@document.first("title_tsim")}"
      Rails.logger.error "Unable to retrieve holdings for #{@document.id}: #{e}"
    end
  end

  delegate :items_issues_in_use, to: :helpers

  delegate :items_issues_held, to: :helpers

  delegate :supplements, to: :helpers

  delegate :indexes, to: :helpers

  delegate :holding_notes, to: :helpers

  delegate :access_condition_notes, to: :helpers
end
