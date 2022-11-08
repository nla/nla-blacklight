require "rails_helper"

RSpec.describe "Navigation Actions" do
  before do
    driven_by(:rack_test)
  end

  context "when unauthenticated user" do
    it "does not show the History link" do
      visit root_path

      expect(page).not_to have_text("History")
    end
  end

  context "when authenticated user" do
    it "does not how the History link" do
      visit new_user_session_path

      fill_in "user_username", with: "bltest"
      fill_in "user_password", with: "test"

      click_button "Log in"

      expect(page).not_to have_text("History")
    end
  end
end
