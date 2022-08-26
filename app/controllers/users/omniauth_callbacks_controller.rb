# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def keycloakopenid
    Rails.logger.debug(request.env["omniauth.auth"])
    @user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in_and_redirect @user, event: :authentication
  end

  # Keycloak will display its own error page when there is a failure to login.
  # :nocov:
  def failure
    redirect_to root_path
  end
  # :nocov:
end
