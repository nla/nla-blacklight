require "system_helper"

RSpec.describe "Request summary" do
  context "when logged in" do
    before do
      visit root_path
      click_link "Login"

      fill_in "user_username", with: "bltest"
      fill_in "user_password", with: "test"
      click_button "Login"
    end

    it "displays the request summary" do
      visit account_requests_path

      expect(page).to have_css("a.active", text: "blacklight test")

      expect(page).to have_css("caption", text: /Checked out/)
      expect(page).to have_css("caption", text: /Ready for collection/)
      expect(page).to have_css("caption", text: /Not available/)
      expect(page).to have_css("caption", text: /Items requested/)
      expect(page).to have_css("caption", text: /Previous requests/)
    end

    it "displays the request details" do
      visit request_details_path("d7746c53-7746-4b0e-8382-5261aa9bcecb", loan: false)

      Capybara.using_wait_time(10) do # seconds
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

      expect(page).to have_content("Login")
      expect(page).to have_content("User ID")
      expect(page).to have_content("Family Name")
    end
  end
end
