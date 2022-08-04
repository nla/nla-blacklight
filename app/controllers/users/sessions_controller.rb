# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # rubocop: disable Rails/LexicallyScopedActionFilter
  before_action :configure_sign_in_params, only: [:create]
  skip_before_action :verify_authenticity_token, only: :create
  # rubocop: enable Rails/LexicallyScopedActionFilter

  protected

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [user: [:username, :password]])
  end
end
