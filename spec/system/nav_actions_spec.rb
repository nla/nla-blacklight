require "rails_helper"

RSpec.describe "Navigation actions" do
  before do
    driven_by(:rack_test)
  end

  it "does not show the History link" do
    visit root_path

    expect(page).to have_no_text("History")
  end

  context "when FOLIO_UPDATE_IN_PROGRESS is `true`" do
    it "does not render the request button" do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("FOLIO_UPDATE_IN_PROGRESS").and_return("true")

      visit root_path

      expect(page).to have_no_link I18n.t("blacklight.header_links.login"), href: new_user_session_path
    end
  end

  context "when FOLIO_UPDATE_IN_PROGRESS is `false`" do
    it "renders the request button" do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("FOLIO_UPDATE_IN_PROGRESS").and_return("false")

      visit root_path

      expect(page).to have_link I18n.t("blacklight.header_links.login"), href: new_user_session_path
    end
  end

  context "when FOLIO_UPDATE_IN_PROGRESS is defined without a value" do
    it "renders the request button" do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("FOLIO_UPDATE_IN_PROGRESS").and_return(nil)

      visit root_path

      expect(page).to have_link I18n.t("blacklight.header_links.login"), href: new_user_session_path
    end
  end

  context "when FOLIO_UPDATE_IN_PROGRESS is not defined" do
    it "renders the request button" do
      visit root_path

      expect(page).to have_link I18n.t("blacklight.header_links.login"), href: new_user_session_path
    end
  end
end
