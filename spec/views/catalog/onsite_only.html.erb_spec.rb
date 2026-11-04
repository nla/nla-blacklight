# frozen_string_literal: true

require "rails_helper"

RSpec.describe "catalog/onsite_only" do
  before do
    assign(:eresource, {entry: {"title" => "Resource"}})
    assign(:record_url, "/catalog/0000")
  end

  it "preserves HTTP resource links" do
    assign(:requested_url, "https://example.com/resource")

    render

    expect(rendered).to have_link("Resource", href: "https://example.com/resource")
  end

  it "removes executable resource links" do
    assign(:requested_url, "javascript:alert(1)")

    render

    expect(rendered).not_to include("javascript:")
    expect(rendered).to have_link("return to the record display", href: "/catalog/0000")
  end
end
