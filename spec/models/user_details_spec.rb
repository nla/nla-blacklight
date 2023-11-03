# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserDetails do
  describe "#email" do
    context "when email is blank" do
      it "displays an error" do
        user_details = described_class.new(email: "")

        user_details.valid?(:email)

        expect(user_details.errors[:email]).to include(I18n.t("activemodel.errors.models.user_details.attributes.email.blank"))
      end
    end

    context "when missing '@' symbol" do
      it "displays an error" do
        user_details = described_class.new(email: "test.com")

        user_details.valid?(:email)

        expect(user_details.errors[:email]).to include(I18n.t("activemodel.errors.models.user_details.attributes.email.invalid"))
      end
    end

    context "when missing a label" do
      it "displays an error" do
        user_details = described_class.new(email: "@test.com")

        user_details.valid?(:email)

        expect(user_details.errors[:email]).to include(I18n.t("activemodel.errors.models.user_details.attributes.email.invalid"))
      end
    end

    context "when missing a domain" do
      it "displays an error" do
        user_details = described_class.new(email: "test@example")

        user_details.valid?(:email)

        expect(user_details.errors[:email]).to include(I18n.t("activemodel.errors.models.user_details.attributes.email.invalid"))
      end
    end

    context "when postcode is blank" do
      it "does not display a postcode error" do
        user_details = described_class.new(email: "")

        user_details.valid?(:email)

        expect(user_details.errors[:postcode]).to eq []
      end
    end
  end

  describe "#mobile_phone" do
    context "when mobile_phone and phone are blank" do
      it "displays an error" do
        user_details = described_class.new(mobile_phone: "", phone: "")

        user_details.valid?(:mobile_phone)

        expect(user_details.errors[:base]).to include(I18n.t("account.settings.update.errors.any_phone"))
        expect(user_details.errors[:postcode]).to eq []
      end
    end

    context "when mobile_phone is 10 digits starting with '04'" do
      it "is valid" do
        user_details = described_class.new(mobile_phone: "0434567890")

        user_details.valid?(:mobile_phone)

        expect(user_details.errors[:mobile_phone]).to be_empty
      end
    end

    context "when mobile_phone is 10 digits not starting with '04'" do
      it "is invalid" do
        user_details = described_class.new(mobile_phone: "0234567890")

        user_details.valid?(:mobile_phone)

        expect(user_details.errors[:mobile_phone]).to include(I18n.t("activemodel.errors.models.user_details.attributes.mobile_phone.invalid"))
      end
    end

    context "when including +[country] prefix" do
      it "is valid" do
        user_details = described_class.new(mobile_phone: "+61412345678")

        user_details.valid?(:mobile_phone)

        expect(user_details.errors[:mobile_phone]).to be_empty
      end
    end

    context "when formatting includes spaces" do
      it "is valid" do
        user_details = described_class.new(phone: "043 123 4567")

        user_details.valid?(:mobile_phone)

        expect(user_details.errors[:phone]).to be_empty
      end
    end

    context "when vanity number including non-numeric characters" do
      it "is invalid" do
        user_details = described_class.new(mobile_phone: "13UNICORN")

        user_details.valid?(:mobile_phone)

        expect(user_details.errors[:mobile_phone]).to include(I18n.t("activemodel.errors.models.user_details.attributes.mobile_phone.invalid"))
      end
    end

    context "when mobile_phone is too short" do
      it "displays an error" do
        user_details = described_class.new(mobile_phone: "12345")

        user_details.valid?(:mobile_phone)

        expect(user_details.errors[:mobile_phone]).to include(I18n.t("activemodel.errors.models.user_details.attributes.mobile_phone.invalid"))
      end
    end

    context "when mobile_phone is too long" do
      it "displays an error" do
        user_details = described_class.new(mobile_phone: "123456789012345678901")

        user_details.valid?(:mobile_phone)

        expect(user_details.errors[:mobile_phone]).to include(I18n.t("activemodel.errors.models.user_details.attributes.mobile_phone.invalid"))
      end
    end

    context "when postcode is blank" do
      it "does not display a postcode error" do
        user_details = described_class.new(mobile_phone: "", phone: "")

        user_details.valid?(:mobile_phone)

        expect(user_details.errors[:postcode]).to eq []
      end
    end
  end

  describe "#phone" do
    context "when phone and mobile_phone are blank" do
      it "displays an error" do
        user_details = described_class.new(mobile_phone: "", phone: "")

        user_details.valid?(:phone)

        expect(user_details.errors[:base]).to include(I18n.t("account.settings.update.errors.any_phone"))
        expect(user_details.errors[:postcode]).to eq []
      end
    end

    context "when phone is 10 digits starting with '04'" do
      it "is valid" do
        user_details = described_class.new(phone: "0434567890")

        user_details.valid?(:phone)

        expect(user_details.errors[:phone]).to be_empty
      end
    end

    context "when phone is 10 digits not starting with '04'" do
      it "is invalid" do
        user_details = described_class.new(phone: "0234567890")

        user_details.valid?(:phone)

        expect(user_details.errors[:phone]).to be_empty
      end
    end

    context "when including +[country] prefix" do
      it "is valid" do
        user_details = described_class.new(phone: "+61412345678")

        user_details.valid?(:phone)

        expect(user_details.errors[:phone]).to be_empty
      end
    end

    context "when formatting includes spaces" do
      it "is valid" do
        user_details = described_class.new(phone: "023 123 4567")

        user_details.valid?(:phone)

        expect(user_details.errors[:phone]).to be_empty
      end
    end

    context "when vanity number including non-numeric characters" do
      it "is invalid" do
        user_details = described_class.new(phone: "13UNICORN")

        user_details.valid?(:phone)

        expect(user_details.errors[:phone]).to include(I18n.t("activemodel.errors.models.user_details.attributes.phone.invalid"))
      end
    end

    context "when phone is too short" do
      it "displays an error" do
        user_details = described_class.new(phone: "12345")

        user_details.valid?(:phone)

        expect(user_details.errors[:phone]).to include(I18n.t("activemodel.errors.models.user_details.attributes.phone.invalid"))
      end
    end

    context "when phone is too long" do
      it "displays an error" do
        user_details = described_class.new(phone: "123456789012345678901")

        user_details.valid?(:phone)

        expect(user_details.errors[:phone]).to include(I18n.t("activemodel.errors.models.user_details.attributes.phone.invalid"))
      end
    end
  end

  describe "#postcode" do
    context "when postcode is blank" do
      it "displays an error" do
        user_details = described_class.new(postcode: "")

        user_details.valid?(:postcode)

        expect(user_details.errors[:postcode]).to include(I18n.t("activemodel.errors.models.user_details.attributes.postcode.blank"))
      end
    end
  end
end
