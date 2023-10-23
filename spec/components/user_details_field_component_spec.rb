# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserDetailsFieldComponent, type: :component do
  let(:folio_details) do
    {
      "personal" => {
        "firstName" => "John",
        "lastName" => "Smith",
        "email" => "test@example.com",
        "mobilePhone" => "0123456789",
        "addresses" => [
          {
            "postalCode" => "AB1 2CD"
          }
        ]
      }
    }
  end

  let(:user_details) { UserDetails.new(folio_details) }

  it "renders the user details if there is a value" do
    unless ENV["KC_PATRON_REALM"]
      skip("Skipping test as KC_PATRON_REALM is not set")
    end

    render_inline(described_class.new(attribute: "last_name", details: user_details))

    expect(page).to have_css("#last_name-label", text: I18n.t("account.settings.last_name.label"))
    expect(page).to have_css("dd", text: "Smith")
  end

  it "does not render the user details if there is no value" do
    unless ENV["KC_PATRON_REALM"]
      skip("Skipping test as KC_PATRON_REALM is not set")
    end

    render_inline(described_class.new(attribute: "phone", details: user_details))

    expect(page).not_to have_css("#phone-label", text: "Phone")
  end

  context "when patron account" do
    it "renders the edit link if the attribute is editable" do
      unless ENV["KC_PATRON_REALM"]
        skip("Skipping test as KC_PATRON_REALM is not set")
      end

      render_inline(described_class.new(attribute: "email", details: user_details, editable: UserDetails::PATRON_EDITABLE_ATTRIBUTES.include?("email")))

      expect(page).to have_css("#email-label", text: I18n.t("account.settings.email.label"))
      expect(page).to have_css("a", text: I18n.t("account.settings.email.change_text"))
    end

    it "does not render the edit link if the attribute is not editable" do
      unless ENV["KC_PATRON_REALM"]
        skip("Skipping test as KC_PATRON_REALM is not set")
      end

      render_inline(described_class.new(attribute: "last_name", details: user_details, editable: UserDetails::PATRON_EDITABLE_ATTRIBUTES.include?("last_name")))

      expect(page).to have_css("#last_name-label", text: I18n.t("account.settings.last_name.label"))
      expect(page).to have_css("dd", text: "Smith")
      expect(page).not_to have_css("a", text: I18n.t("account.settings.last_name.change_text"))
    end
  end

  context "when staff account" do
    it "does not render the edit link if the attribute is not editable" do
      unless ENV["KC_PATRON_REALM"]
        skip("Skipping test as KC_PATRON_REALM is not set")
      end

      render_inline(described_class.new(attribute: "email", details: user_details, editable: UserDetails::STAFF_EDITABLE_ATTRIBUTES.include?("email")))

      expect(page).to have_css("#email-label", text: I18n.t("account.settings.email.label"))
      expect(page).not_to have_css("a", text: I18n.t("account.settings.email.change_text"))
    end
  end
end
