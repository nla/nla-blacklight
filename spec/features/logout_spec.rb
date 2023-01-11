# frozen_state_literal: true

require "rails_helper"

RSpec.feature "Logout" do
  before do
    create(:user,
      patron_id: 1,
      voyager_id: 1,
      name_given: "Blacklight",
      name_family: "Test")
  end

  it "destroys the user session" do
    visit new_user_session_path
    fill_in "user_username", with: "bltest"
    fill_in "user_password", with: "test"
    click_button "Log in"

    visit root_path
    click_link "Log Out"

    expect(page).to have_content("Your National Library card")
  end
end
