# frozen_string_literal: true

class RequestLimitMessageComponent < ViewComponent::Base
  renders_one :limit_reached
  renders_one :remaining_requests

  def initialize(current_user, cat_services_client)
    @current_user = current_user
    @cat_services_client = cat_services_client
  end

  def before_render
    if !limit_reached? && @current_user.present?
      @met_limit = @cat_services_client.request_limit_reached?(requester: @current_user.folio_id)
    end
  end

  def render?
    @current_user.present?
  end
end
