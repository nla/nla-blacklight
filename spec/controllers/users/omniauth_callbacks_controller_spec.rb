require "rails_helper"

# frozen_string_literal: true

RSpec.describe Users::OmniauthCallbacksController do
  include Devise::Test::ControllerHelpers

  describe "#keycloakopenid" do
    context "when staff user doesn't exist in the database" do
      before do
        setup_keycloak_env

        get :keycloakopenid
      end

      let(:user) { User.where(uid: "b8d0e04c-5a33-458f-b917-bc258861ebc0") }

      it { expect(is_logged_in?).to be_truthy }

      it { expect(user).not_to be_nil }

      it { is_expected.to redirect_to root_path }
    end
  end

  def setup_keycloak_env
    OmniAuth.config.test_mode = true
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = OmniAuth::AuthHash.new(
      provider: "keycloakopenid",
      uid: "b8d0e04c-5a33-458f-b917-bc258861ebc0",
      info: {
        name: "Staff User",
        email: "staff_user@nla.gov.au",
        first_name: "Staff",
        last_name: "User"
      },
      credentials: {
        token: "1234token",
        refresh_token: "6789refresh",
        expires_at: 1660810917,
        expires: true
      }
    )
  end

  def is_logged_in?
    request.env["warden"].authenticated?(:user)
  end
end
