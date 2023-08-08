# frozen_string_literal: true

class AccountController < ApplicationController
  before_action :authenticate_user!

  def requests
    @met_request_limit = CatalogueServicesClient.new.request_limit_reached?(requester: current_user.folio_id)
    @requests = CatalogueServicesClient.new.get_request_summary(folio_id: current_user.folio_id)
  end
end
