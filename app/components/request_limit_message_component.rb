# frozen_string_literal: true

class RequestLimitMessageComponent < ViewComponent::Base
  renders_one :limit_reached
  renders_one :remaining_requests

  def initialize(current_user, cat_services_client)
    @current_user = current_user
    @cat_services_client = cat_services_client
  end

  def render?
    @current_user.present?
  end

  private

  def limit_message
    case @current_user.provider
    when "catalogue_sol"
      I18n.t("requesting.request_limit_error.sol",
        staff_borrowing: Rails.application.config_for(:catalogue).staff_borrowing_url,
        enquiry_form: Rails.application.config_for(:catalogue).data_services_enquiry_form).html_safe
    when "catalogue_spl"
      I18n.t("requesting.request_limit_error.spl",
        staff_borrowing: Rails.application.config_for(:catalogue).staff_borrowing_url).html_safe
    when "catalogue_shared"
      I18n.t("requesting.request_limit_error.tol",
        staff_borrowing: Rails.application.config_for(:catalogue).staff_borrowing_url,
        enquiry_form: Rails.application.config_for(:catalogue).data_services_enquiry_form).html_safe
    else
      I18n.t("requesting.request_limit_error.patron", url: ENV["ASK_LIBRARIAN_URL"]).html_safe
    end
  end
end
