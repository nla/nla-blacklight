require "rails_helper"

RSpec.describe "Accounts" do
  before do
    user = create(:user)
    sign_in user
  end

  describe "GET /requests" do
    it "returns http success" do
      get account_requests_path
      expect(response).to have_http_status(:success)
    end

    context "when user is not logged in" do
      before do
        sign_out :user
      end

      it "redirects to login page" do
        get account_requests_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
