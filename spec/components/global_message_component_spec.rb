# frozen_string_literal: true

require "rails_helper"

RSpec.describe GlobalMessageComponent, type: :component do
  before do
    stub_const("ENV", ENV.to_hash.merge("GLOBAL_MESSAGE_URL" => "http://test.nla.gov.au/catalogue-message/1"))
  end

  it "renders a message" do
    render_inline(described_class.new)

    expect(page).to have_css("div.alert")
    expect(page).to have_content("Blacklight beta message")
  end

  context "when there are multiple messages" do
    before do
      stub_const("ENV", ENV.to_hash.merge("GLOBAL_MESSAGE_URL" => "http://test.nla.gov.au/catalogue-message/2"))
    end

    it "renders multiple messages" do
      render_inline(described_class.new)

      expect(page).to have_css("div.alert", count: 2)
      expect(page).to have_content("Blacklight beta message")
      expect(page).to have_content("Blacklight beta message 2")
    end
  end
end
