# frozen_string_literal: true

require "rails_helper"

RSpec.describe CatalogueServicesClient, type: :request do
  subject(:service) { described_class.new }

  describe "#get_holdings" do
    it "returns holdings records" do
      expect(service.get_holdings(instance_id: "08aed703-3648-54d0-80ef-fddb3c635731").size).to eq 5
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
          .to_return(status: 200, body: "{\"requestLimitReached\": \"true\"}", headers: {})

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
          .to_return(status: 200, body: "{\"requestLimitReached\": \"false\"}", headers: {})

        expect(service.request_limit_reached?(requester: "1111")).to be false
      end
    end
  end
end
