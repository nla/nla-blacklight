# frozen_string_literal: true

class AccountController < ApplicationController
  before_action :authenticate_user!

  def requests
    @requests = helpers.cat_services_client.get_request_summary(folio_id: current_user.folio_id)
  end
end
