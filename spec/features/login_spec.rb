# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Login in" do
  before do
    create(:user,
      patron_id: 1,
      voyager_id: 1,
      name_given: "Blacklight",
      name_family: "Test")
  end

  it "creates a new session for the user" do
    visit root_path
    click_link "Login"
    expect(page).to have_content("Log in")

    fill_in "user_username", with: "bltest"
    fill_in "user_password", with: "test"
    click_button "Log in"

    expect(page).to have_content("Signed in successfully.")
    expect(page).to have_content("blacklight test")
  end
end
