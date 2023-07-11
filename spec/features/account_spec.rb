require "rails_helper"

RSpec.describe "Account" do
  before do
    user = create(:user)
    sign_in user
  end

  describe "GET /requests" do
    context "when user has reached their request limit" do
      it "renders the request limit error" do
        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/user\/(.*)\/requestLimitReached/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: "{\"requestlimitReached\": \"true\"}", headers: {})

        visit account_requests_path

        expect(page).to have_css(".alert-danger", text: "Your request limit has been reached")
        expect(page).not_to have_css("#request-details")
      end
    end

    context "when user has not reached their request limit" do
      it "does not render the limit error" do
        visit account_requests_path

        expect(page).to have_css(".alert-info", text: "You can request")
        expect(page).not_to have_css(".alert-danger", text: "Your request limit has been reached")
      end
    end
  end
end
