# frozen_string_literal: true

require "rails_helper"

RSpec.describe BentoSearchTotalsComponent, type: :component do
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

  it "renders links to result categories" do
    list = %w[test test2]
    render_inline(described_class.new(list))

    expect(page).to have_link("Test", href: "#test")
    expect(page).to have_link("Test2", href: "#test2")
  end
end
