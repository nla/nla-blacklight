# frozen_string_literal: true

require "rails_helper"

RSpec.describe BentoSearchResultsComponent, type: :component do
  before do
    BentoSearch.register_engine("test") do |conf|
      conf.engine = "BentoSearch::BlacklightEngine"
      conf.title = "Test"
    end
    BentoSearch.register_engine("test2") do |conf|
      conf.engine = "BentoSearch::BlacklightEngine"
      conf.title = "Test2"
    end
  end

  it "renders skeletons for result categories" do
    render_inline(described_class.new("catalogue", "/search/catalogue?q=hydrogen"))

    expect(page).to have_css(".bento-item-title", text: "A result")
  end
end
