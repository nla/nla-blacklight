# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Advanced Search" do
  scenario "does not display a sort widget" do
    # In BL9, advanced search is now native at /catalog/advanced
    visit "/catalog/advanced"
    expect(page).to have_css("body")
    expect(page).to have_no_css(".sort-buttons pull-left")
  end
end
