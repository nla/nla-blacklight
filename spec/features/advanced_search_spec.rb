# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Advanced Search" do
  scenario "does not display a sort widget" do
    visit blacklight_advanced_search_engine.advanced_search_path
    expect(page).to have_css("body")
    expect(page).to have_no_css(".sort-buttons pull-left")
  end
end
