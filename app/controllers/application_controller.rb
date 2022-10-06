class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  layout :determine_layout if respond_to? :layout

  # Tell Rails to look for templates in the view components directory
  # Make sure to use an absolute path when rendering the partial because
  # view context is based on the executing controller.
  append_view_path "#{Rails.root}/app/components/"

  def staff_login
    redirect_post(user_keycloakopenid_omniauth_authorize_path, options: {authenticity_token: "auto"})
  end
end
