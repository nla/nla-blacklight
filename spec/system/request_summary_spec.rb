require "system_helper"

RSpec.describe "Request summary" do
  context "when logged in" do
    before do
      sign_in create(:user)
    end

    it "displays the request summary" do
      visit account_requests_path

      Capybara.using_wait_time(30) do
        expect(page).to have_css("a.active", text: "Test User")

        expect(page).to have_css("caption", text: /Checked out/)
        expect(page).to have_css("caption", text: /Ready for collection/)
        expect(page).to have_css("caption", text: /Not available/)
        expect(page).to have_css("caption", text: /Items requested/)
        expect(page).to have_css("caption", text: /Previous requests/)
      end
    end

    it "displays the request details" do
      visit account_request_details_path("d7746c53-7746-4b0e-8382-5261aa9bcecb", loan: false)

      Capybara.using_wait_time(30) do # seconds
        expect(page).to have_css("h1", text: "Request Details")
        expect(page).to have_css("h3", text: "The Mad Max movies / Adrian Martin.")

        expect(page).to have_css("dt", text: "Collect From:")
        expect(page).to have_css("dd", text: "Main Reading Room")

        expect(page).to have_css("dt", text: "Date:")
        expect(page).to have_css("dd", text: "20 June 2023")
        expect(page).to have_css("small", text: "06:36pm")

        expect(page).to have_css("dt", text: "Notes:")
        expect(page).to have_css("dd", text: "Testing patron comments")
      end
    end
  end

  context "when not logged in" do
    it "redirects to the login page" do
      visit account_requests_path

      expect(page).to have_css("h1", text: "Login")
      expect(page).to have_button("Login")
    end
  end
end
