require "rails_helper"

RSpec.describe "Navigation actions" do
  before do
    driven_by(:rack_test)
  end

  it "does not show the History link" do
    visit root_path

    expect(page).not_to have_text("History")
  end
end
