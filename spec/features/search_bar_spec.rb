# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Search via search bar" do
  scenario "from advanced search page" do
    visit blacklight_advanced_search_engine.advanced_search_path
    expect(page).to have_content("Advanced search")
    expect(page).not_to have_css(".search-query-form")
  end

  scenario "from home page" do
    visit root_path
    expect(page).not_to have_css(".navbar-search")
  end

  scenario "from bento search page" do
    visit bento_search_index_path
    expect(page).not_to have_content("form[id=\"search\"]")
  end
end
