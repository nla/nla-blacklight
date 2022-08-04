class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  layout :determine_layout if respond_to? :layout

  def staff_login
    redirect_post(user_keycloakopenid_omniauth_authorize_path, options: {authenticity_token: "auto"})
  end
end
