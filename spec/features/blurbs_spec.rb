# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Home page blurbs" do
  it "displays the blurbs" do
    visit search_catalog_path

    expect(page.html).to include(I18n.t("home.p1").html_safe)
    expect(page.html).to include(I18n.t("home.p2").html_safe)
    expect(page.html).to include(I18n.t("home.p3").html_safe)
  end
end
