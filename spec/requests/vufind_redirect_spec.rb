# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Redirect VuFind URLs" do
  it "redirects /Record/:id to /catalog/:id" do
    expect(get("/Record/000")).to redirect_to("/catalog/000")
  end

  it "redirects /Record/:id/Offsite?url= to /catalog/:id/offsite?url=" do
    expect(get("/Record/000/Offsite?url=https://example.com")).to redirect_to("/catalog/000/offsite?url=https://example.com")
  end
end
