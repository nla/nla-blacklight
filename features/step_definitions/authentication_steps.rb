Given("I am a registered user") do
  @registered_user = FactoryBot.create(:user,
    patron_id: 1,
    voyager_id: 1,
    name_given: "Blacklight",
    name_family: "Test")
end

Given("I visit the homepage") do
  visit root_path
end

When("I click on the Login link") do
  click_link "Login"
end

Then("I should be redirected to the log in page") do
  expect(page).to have_content("Log in")
end

When("I fill in the login form") do
  fill_in "user_username", with: "bltest"
  fill_in "user_password", with: "test"

  click_button "Log in"
end

Then("I should be logged in") do
  expect(page).to have_content("Signed in successfully.")
  expect(page).to have_content("blacklight test")
end

Given("I am logged in") do
  visit new_user_session_path

  fill_in "user_username", with: "bltest"
  fill_in "user_password", with: "test"

  click_button "Log in"
end

When("I click the log out link") do
  click_link "Log Out"
end

Then("I should be redirected to the home page") do
  expect(page).to have_content("Welcome LSP Board!")
end
