class ApplicationController < ActionController::Base
  before_action :store_user_location!, if: :storable_location?

  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  layout :determine_layout if respond_to? :layout

  # Tell Rails to look for templates in the view components directory
  # Make sure to use an absolute path when rendering the partial because
  # view context is based on the executing controller.
  append_view_path "#{Rails.root}/app/components/"

  # :nocov:
  def staff_login
    redirect_post(user_keycloakopenid_omniauth_authorize_path, options: {authenticity_token: "auto"})
  end
  # :nocov:

  private

  # Its important that the location is NOT stored if:
  # - The request method is not GET (non idempotent)
  # - The request is handled by a Devise controller such as Devise::SessionsController as that could cause an
  #    infinite redirect loop.
  # - The request is an Ajax request as this can lead to very unexpected behaviour.
  # :nocov:
  def storable_location?
    request.get? &&
      is_navigational_format? &&
      (!is_a?(ThumbnailController) && !is_a?(Users::SessionsController) && !is_a?(Users::OmniauthCallbacksController) && !devise_controller?) &&
      !request.xhr?
  end
  # :nocov:

  # :nocov:
  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end
  # :nocov:
end
