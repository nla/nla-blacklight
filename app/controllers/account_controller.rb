# frozen_string_literal: true

class AccountController < ApplicationController
  before_action :authenticate_user!

  before_action :request_detail_params, only: [:request_details]
  before_action :settings_edit_params, only: [:settings_edit]
  before_action :settings_update_params, only: [:settings_update]

  def requests
    @met_request_limit = CatalogueServicesClient.new.request_limit_reached?(requester: current_user.folio_id)
    @requests = CatalogueServicesClient.new.get_request_summary(folio_id: current_user.folio_id)
  end

  def request_details
    res = CatalogueServicesClient.new.request_details(request_id: request_detail_params[:request_id], loan: request_detail_params[:loan])
    @details = RequestDetail.new(res)
  end

  def settings
    folio_details = CatalogueServicesClient.new.user_folio_details(current_user.folio_id)
    @user_details = UserDetails.new(folio_details)
  end

  def settings_edit
    folio_details = CatalogueServicesClient.new.user_folio_details(current_user.folio_id)
    @user_details = UserDetails.new(folio_details)
  end

  def settings_update
    CatalogueServicesClient.new.update_user_folio_details(current_user.folio_id, settings_update_params)
    redirect_to account_settings_path
  end

  private

  def request_detail_params
    params.permit(:request_id, :loan)
  end

  def settings_edit_params
    params.permit(:first_name, :last_name, :email, :password, :phone, :mobile_phone, :postcode)
  end

  def settings_update_params
    params.permit(user_details: [:first_name, :last_name, :email, :password, :phone, :mobile_phone, :postcode])
  end
end
