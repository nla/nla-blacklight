# frozen_string_literal: true

require "rails_helper"

RSpec.describe CatalogueServicesClient, type: :request do
  subject(:service) { described_class.new }

  describe "#get_holdings" do
    it "returns holdings records" do
      expect(service.get_holdings(instance_id: "08aed703-3648-54d0-80ef-fddb3c635731").size).to eq 5
    end

    context "when unable to request an access token" do
      it "raises a ServiceTokenError" do
        allow_any_instance_of(OAuth2::Strategy::ClientCredentials).to receive(:get_token).and_raise(OAuth2::Error)

        expect { service.get_holdings(instance_id: "08aed703-3648-54d0-80ef-fddb3c635731") }.to raise_error(ServiceTokenError)
      end
    end

    context "when retried too many times to get an access token" do
      it "raises a ServiceTokenError" do
        expired_token_response = IO.read("spec/files/catalogue_services/expired_token_response.json")

        WebMock.stub_request(:post, "https://auth.test/auth/realms/example-realm/protocol/openid-connect/token")
          .with(
            body: {"grant_type" => "client_credentials"},
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "Content-Type" => "application/x-www-form-urlencoded"
            }
          )
          .to_return(status: 200, body: expired_token_response, headers: {"Content-Type" => "application/json"})

        expect { service.get_holdings(instance_id: "08aed703-3648-54d0-80ef-fddb3c635731") }.to raise_error(ServiceTokenError)
      end
    end
  end

  describe "#create_request" do
    context "when unable to request holdings" do
      it "raises a ItemRequestError" do
        WebMock.stub_request(:post, /catservices.test\/catalogue-services\/folio\/request\/new/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 401, body: "", headers: {})

        expect { service.create_request(requester: "1111", request: {}) }.to raise_error(ItemRequestError)
      end
    end
  end

  describe "#request_limit_reached?" do
    context "when unable to check request limit" do
      it "raises an ItemRequestError" do
        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/user\/(.*)\/requestLimitReached/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 404, body: "", headers: {})

        expect { service.request_limit_reached?(requester: "1111") }.to raise_error(ItemRequestError)
      end
    end

    context "when user has met request limit" do
      it "returns true" do
        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/user\/(.*)\/requestLimitReached/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: "{\"requestlimitReached\": \"true\"}", headers: {})

        expect(service.request_limit_reached?(requester: "1111")).to be true
      end
    end

    context "when user has not met request limit" do
      it "returns false" do
        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/user\/(.*)\/requestLimitReached/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: "{\"requestlimitReached\": \"false\"}", headers: {})

        expect(service.request_limit_reached?(requester: "1111")).to be false
      end
    end
  end
end
