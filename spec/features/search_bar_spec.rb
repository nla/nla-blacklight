# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Search via search bar" do
  scenario "from advanced search page" do
    visit advanced_search_catalog_path
    expect(page).to have_content("Advanced search")
    expect(page).to have_no_css(".search-query-form")
  end

  scenario "from home page" do
    visit root_path
    expect(page).to have_no_css(".navbar-search")
  end

  scenario "from bento search page" do
    visit bento_search_index_path
    expect(page).to have_no_content("form[id=\"search\"]")
  end
end
