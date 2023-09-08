# frozen_string_literal: true

require "rails_helper"

RSpec.describe EresourcesConfigService, type: :request do
  subject(:service) { described_class.new }

  describe "#fetch_config" do
    context "when unable to connect to config endpoint" do
      it "returns nil" do
        stub_const("ENV", ENV.to_hash.merge("ERESOURCES_CONFIG_URL" => "http://eresource-manager.example.com/service-fail"))

        expect(service.fetch_config).to be_nil
      end
    end

    context "when non-200 response" do
      it "returns nil" do
        stub_const("ENV", ENV.to_hash.merge("ERESOURCES_CONFIG_URL" => "http://eresource-manager.example.com/service-error"))

        expect(service.fetch_config).to be_nil
      end
    end
  end
end
