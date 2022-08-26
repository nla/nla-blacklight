# frozen_string_literal: true

require "rails_helper"

RSpec.describe BlacklightHelper do
  describe "#application_name" do
    it "defaults to 'Catalogue | National Library of Australia'" do
      expect(application_name).to eq "Catalogue | National Library of Australia"
    end
  end

  describe "#render_page_title" do
    it "defaults to the application name" do
      expect(helper.render_page_title).to eq helper.application_name
    end

    context "when in development environment" do
      before { ENV["RAILS_ENV"] = "development" }

      it "prepends '[DEV]' to the title" do
        expect(helper.render_page_title).to eq "[DEV] #{helper.application_name}"
      end
    end

    context "when in staging environment" do
      before { ENV["RAILS_ENV"] = "staging" }

      it "prepends '[TEST]' to the title" do
        expect(helper.render_page_title).to eq "[TEST] #{helper.application_name}"
      end
    end
  end
end
