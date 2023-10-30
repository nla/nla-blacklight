# frozen_string_literal: true

class AccountController < ApplicationController
  before_action :authenticate_user!

  before_action :set_user_details, only: [:settings, :settings_edit, :settings_update]

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
  end

  def settings_edit
    @user_details = settings_edit_params[:user_details] || @current_details.dup
  end

  def settings_update
    @user_details = UserDetails.new(@current_details.attributes.merge(settings_update_params[:user_details].to_h))
    if @user_details.valid?
      response = CatalogueServicesClient.new.update_user_folio_details(current_user.folio_id, settings_update_params)
      if response["status"].present?
        if response["status"] == "OK"
          return redirect_to account_settings_path
        else
          service_error_message = case response["status"]
          when "EMAIL_ALREADY_EXISTS"
            I18n.t("account.settings.update.errors.email.taken")
          when "EMAIL_UPDATE_FAILED"
            I18n.t("account.settings.update.errors.email.failed")
          else
            I18n.t("account.settings.update.errors.failed", attribute: I18n.t("account.settings.#{settings_update_params[:attribute]}.change_text"))
          end
          @user_details.errors.add(settings_update_params[:attribute].to_sym, service_error_message)
        end
      end
    end

    render :settings_edit, status: :unprocessable_entity
  end

  private

  def request_detail_params
    params.permit(:request_id, :loan)
  end

  def set_user_details
    folio_details = CatalogueServicesClient.new.user_folio_details(current_user.folio_id)
    @current_details = UserDetails.new(folio_details)
  end

  def settings_edit_params
    params.permit(:attribute, user_details: {}, current_details: {})
  end

  def settings_update_params
    params.permit(:attribute, user_details: {}, current_details: {})
  end
end
