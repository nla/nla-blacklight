# frozen_string_literal: true

class AccountController < ApplicationController
  before_action :authenticate_user!

  def requests
    # check the user's request limit
    @met_request_limit = helpers.cat_services_client.request_limit_reached?(requester: current_user.folio_id)
    @requests = helpers.cat_services_client.get_request_summary(folio_id: current_user.folio_id)
  end
end
