# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # rubocop: disable Rails/LexicallyScopedActionFilter
  before_action :configure_sign_in_params, only: [:create]
  # rubocop: enable Rails/LexicallyScopedActionFilter

  protected

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [user: [:username, :password]])
  end
end
