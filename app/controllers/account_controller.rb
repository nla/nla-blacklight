# frozen_string_literal: true

class AccountController < ApplicationController
  before_action :authenticate_user!

  before_action :set_user_details, only: [:profile, :profile_edit, :profile_update]

  before_action :request_detail_params, only: [:request_details]
  before_action :profile_edit_params, only: [:profile_edit]
  before_action :profile_update_params, only: [:profile_update]

  def requests
    @met_request_limit = CatalogueServicesClient.new.request_limit_reached?(requester: current_user.folio_id)
    @requests = CatalogueServicesClient.new.get_request_summary(folio_id: current_user.folio_id)
  end

  def request_details
    res = CatalogueServicesClient.new.request_details(request_id: request_detail_params[:request_id], loan: request_detail_params[:loan])
    @details = RequestDetail.new(res)
  end

  def profile
  end

  def profile_edit
    @user_details = profile_edit_params[:user_details] || @current_details.dup
  end

  def profile_update
    # Since this is not a database backed model, we need to create a new instance using the
    # current details as a base and then assign the updated attributes to it.
    @user_details = UserDetails.new(@current_details.attributes)
    @user_details.assign_attributes(profile_update_params[:user_details])

    # Pass a validation context to target the specific attribute
    # This is mainly to work around the fact that many pre-Keycloak migration patrons have no
    # postcode in their FOLIO accounts. As such, we don't want to validate the postcode field
    # when updating other fields and display an error message when the postcode is blank.
    if @user_details.valid?(profile_update_params[:attribute].to_sym)
      response = CatalogueServicesClient.new.update_user_folio_details(current_user.folio_id, profile_update_params)
      if response["status"].present?
        if response["status"] == "OK"
          return redirect_to account_profile_path
        else
          service_error_message = case response["status"]
          when "EMAIL_ALREADY_EXISTS"
            I18n.t("account.settings.update.errors.email.taken")
          when "EMAIL_UPDATE_FAILED"
            I18n.t("account.settings.update.errors.email.failed")
          else
            I18n.t("account.settings.update.errors.failed", attribute: I18n.t("account.settings.#{profile_update_params[:attribute]}.change_text"))
          end
          @user_details.errors.add(profile_update_params[:attribute].to_sym, service_error_message)
        end
      end
    end

    render :profile_edit, status: :unprocessable_entity
  end

  private

  def request_detail_params
    params.permit(:request_id, :loan)
  end

  def set_user_details
    folio_details = CatalogueServicesClient.new.user_folio_details(current_user.folio_id)
    email_2fa = Email2faService.new.email_2fa_status(current_user.uid)
    @current_details = UserDetails.new(folio_details, email_2fa)
  end

  def profile_edit_params
    params.permit(:attribute, user_details: {}, current_details: {})
  end

  def profile_update_params
    params.permit(:attribute, user_details: {}, current_details: {})
  end
end
