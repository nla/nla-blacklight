# frozen_string_literal: true

class UserDetailsFieldComponent < ViewComponent::Base
  PASSWORD_MASK = ""

  def initialize(attribute:, details:, value: nil, editable: true)
    super
    @attribute = attribute
    @details = details
    @label = I18n.t("account.settings.#{attribute}.label")
    @value = if @attribute == "password"
      PASSWORD_MASK # ensure we don't display anything for the password
    else
      value || @details.instance_values[attribute]
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
end
