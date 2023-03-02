# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Search via search bar" do
  scenario "from outside advanced search page" do
    visit "/"
    fill_in "q", with: "cats"
    click_button "Search"
    expect(page).to have_content("Search Results")
  end

  scenario "from advanced search page" do
    visit blacklight_advanced_search_engine.advanced_search_path
    expect(page).to have_content("Advanced search")
    expect(page).not_to have_css(".search-query-form")
  end
end
