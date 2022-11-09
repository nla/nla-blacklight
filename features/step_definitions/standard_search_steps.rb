When("I fill in the search bar form") do
  page.fill_in "q", with: "cats"
end

When("I click the Search button") do
  find(:css, "#search").click
end

Then("I should be redirected to the search results page") do
  expect(page).to have_content("Search Results")
end

Given("I visit the advanced search page") do
  visit blacklight_advanced_search_engine.advanced_search_path
  expect(page).to have_content("Advanced Search")
end
