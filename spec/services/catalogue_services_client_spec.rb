# frozen_string_literal: true

require "rails_helper"

RSpec.describe CatalogueServicesClient, type: :request do
  subject(:service) { described_class.new }

  context "when unable to request a token" do
    it "raises a ServiceTokenError" do
      WebMock.stub_request(:post, "https://auth.test/auth/realms/example-realm/protocol/openid-connect/token")
        .with(
          body: {"grant_type" => "client_credentials"},
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Content-Type" => "application/x-www-form-urlencoded",
            "User-Agent" => "nla-blacklight/#{Rails.configuration.version}"
          }
        )
        .to_return(status: 401, body: "", headers: {"Content-Type" => "application/json"})

      expect { service.get_holdings(instance_id: "123") }.to raise_error(ServiceTokenError)
    end
  end

  describe "#create_request" do
    context "when unable to request holdings" do
      it "raises a ItemRequestError" do
        WebMock.stub_request(:post, /catservices.test\/catalogue-services\/folio\/request\/new/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "User-Agent" => "nla-blacklight/#{Rails.configuration.version}"
            }
          )
          .to_return(status: 401, body: "", headers: {})

        expect { service.create_request(requester: "1111", request: {}) }.to raise_error(ItemRequestError)
      end
    end
  end
end
