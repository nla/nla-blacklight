# frozen_string_literal: true

class RequestLimitMessageComponent < ViewComponent::Base
  def initialize(show_remaining: false)
    @show_remaining = show_remaining
  end

  def before_render
    if helpers.current_user.present?
      @met_limit = helpers.cat_services_client.request_limit_reached?(requester: helpers.current_user.folio_id)
      @requests = helpers.cat_services_client.get_request_summary(folio_id: helpers.current_user.folio_id)
    end
  end

  def render?
    helpers.current_user.present?
  end
end
