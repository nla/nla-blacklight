# frozen_string_literal: true

class UserDetailsFieldComponent < ViewComponent::Base
  PASSWORD_MASK = ""

  def initialize(attribute:, details:, value: nil, editable: true)
    @attribute = attribute
    @details = details
    @label = I18n.t("account.settings.#{attribute}.label")
    @value = value || @details.instance_values[attribute]
    @value_text = if @attribute == "password"
      PASSWORD_MASK # ensure we don't display anything for the password
    elsif @attribute == "email_2fa"
      @value ? I18n.t("account.settings.email_2fa.value_text_on") : I18n.t("account.settings.email_2fa.value_text_off")
    else
      @value
    end
    @editable = editable
  end

  def edit_link_text
    I18n.t("account.settings.update.change_text", attribute: I18n.t("account.settings.#{@attribute}.change_text"))
  end

  def link_to_keycloak_password_reset
    if helpers.current_user.present?
      link_to edit_link_text, "#{session[:iss]}/account/password", data: {turbo: false}, target: "_top"
    end
  end

  def link_to_email_2fa
    if helpers.current_user.present?
      if @value
        link_to I18n.t("account.settings.email_2fa.change_text", status: "Off"), email_2fa_disable_url, data: {turbo: false}, target: "_top"
      else
        link_to I18n.t("account.settings.email_2fa.change_text", status: "On"), email_2fa_enable_url, data: {turbo: false}, target: "_top"
      end
    end
  end
end
