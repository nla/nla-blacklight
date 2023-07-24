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
      component = described_class.new(user, cat_services_client).tap do |c|
        c.with_limit_reached.with_content(false)
      end

      render_inline(component)

      expect(page).not_to have_css("div.alert-danger")
    end
  end

  context "when the user has reached the limit" do
    before do
      allow(cat_services_client).to receive(:request_limit_reached?).and_return(true)
    end

    let(:component) do
      described_class.new(user, cat_services_client).tap do |c|
        c.with_limit_reached.with_content(true)
      end
    end

    it "renders an error message" do
      render_inline(component)

      expect(page).to have_css("div.alert-danger")
    end

    context "when the user is a public patron" do
      before do
        allow(user).to receive(:provider).and_return("")
      end

      it "renders the patron error message" do
        render_inline(component)

        expect(page).to have_text("Your request limit has been reached and you are unable to make any further requests until you have returned some items.")
        expect(page).to have_text("For further assistance please see desk staff in our reading rooms or Ask a Librarian.")
        expect(page).to have_text("National Library of Australia")
      end
    end

    context "when the user is staff using their SOL account" do
      before do
        allow(user).to receive(:provider).and_return("catalogue_sol")
      end

      it "renders the patron error message" do
        render_inline(component)

        expect(page).to have_text("Please read the borrowing conditions for Staff Official Loans.")
      end
    end

    context "when the user is staff using their SPL account" do
      before do
        allow(user).to receive(:provider).and_return("catalogue_spl")
      end

      it "renders the patron error message" do
        render_inline(component)

        expect(page).to have_text("The borrowing limit for Staff Personal Loans is two (2) items only.")
      end
    end

    context "when the user is staff using their TOL account" do
      before do
        allow(user).to receive(:provider).and_return("catalogue_shared")
      end

      it "renders the patron error message" do
        render_inline(component)

        expect(page).to have_text("Please read the borrowing conditions for Team Official Loans.")
      end
    end
  end

  context "when the user limit is provided" do
    before do
      allow(cat_services_client).to receive(:request_limit_reached?).and_return(false)
    end

    context "when there are multiple requests remaining" do
      it "renders the remaining requests" do
        component = described_class.new(user, cat_services_client).tap do |c|
          c.with_remaining_requests.with_content(5)
        end

        render_inline(component)

        expect(page).to have_css("div.alert-info")
        expect(page).to have_text("You can request 5 more items.")
      end
    end

    context "when there is only 1 request remaining" do
      it "renders a singular message" do
        component = described_class.new(user, cat_services_client).tap do |c|
          c.with_remaining_requests.with_content(1)
        end

        render_inline(component)

        expect(page).to have_css("div.alert-info")
        expect(page).to have_text("You can request 1 more item.")
      end
    end
  end
end
