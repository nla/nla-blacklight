# frozen_string_literal: true

class AccountController < ApplicationController
  before_action :authenticate_user!

  before_action :request_detail_params, only: [:request_details]

  def requests
    @met_request_limit = CatalogueServicesClient.new.request_limit_reached?(requester: current_user.folio_id)
    @requests = CatalogueServicesClient.new.get_request_summary(folio_id: current_user.folio_id)
  end

  def request_details
    res = CatalogueServicesClient.new.request_details(request_id: params[:request_id])
    @details = RequestDetail.new(res)
  end

  private

  def request_detail_params
    params.permit(:request_id)
  end
end
