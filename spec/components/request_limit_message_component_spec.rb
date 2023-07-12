# frozen_string_literal: true

require "rails_helper"

RSpec.describe RequestLimitMessageComponent, type: :component do
  let(:user) { create(:user) }
  let(:cat_services_client) { instance_double(CatalogueServicesClient) }

  context "when the user has not reached the limit" do
    before do
      allow(cat_services_client).to receive(:request_limit_reached?).and_return(false)
    end

    it "does not render an error message" do
      render_inline(described_class.new(user, cat_services_client))

      expect(page).not_to have_css("div.alert-danger")
    end
  end

  context "when the user has reached the limit" do
    before do
      allow(cat_services_client).to receive(:request_limit_reached?).and_return(true)
    end

    it "renders an error message" do
      render_inline(described_class.new(user, cat_services_client))

      expect(page).to have_css("div.alert-danger")
    end
  end

  context "when the user limit is provided" do
    before do
      allow(cat_services_client).to receive(:request_limit_reached?).and_return(false)
    end

    it "renders the remaining requests" do
      component = described_class.new(user, cat_services_client).tap do |c|
        c.with_remaining_requests.with_content(5)
      end

      render_inline(component)

      expect(page).to have_css("div.alert-info")
    end
  end
end
