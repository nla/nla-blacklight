# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/NamedSubject
RSpec.describe Users::OmniauthCallbacksController do
  describe "#keycloakopenid" do
    context "when staff user doesn't exist in the database" do
      before do
        setup_keycloak_env

        get :keycloakopenid
      end

      let(:user) { User.where(uid: "b8d0e04c-5a33-458f-b917-bc258861ebc0") }

      it "authenticates the user" do
        expect(is_logged_in?).to be_truthy
      end

      it "creates a user in the database" do
        expect(user).not_to be_nil
      end

      it "redirects to the home page" do
        expect(subject).to redirect_to root_path
      end
    end

    context "when staff user exists in the database" do
      before do
        User.create(patron_id: 1, voyager_id: 1, name_given: "Test", name_family: "User", email: "staff_user@nla.gov.au", provider: "keycloakopenid", uid: "b8d0e04c-5a33-458f-b917-bc258861ebc0")

        setup_keycloak_env

        get :keycloakopenid
      end

      it "sets the staff member as the current_user" do
        expect(subject.current_user.to_s).to eq "Staff User"
      end

      it "redirects to the home page" do
        expect(subject).to redirect_to root_path
      end
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
# rubocop:enable RSpec/NamedSubject
