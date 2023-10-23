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

  describe "#post_stats" do
    context "when unable to post stats" do
      before do
        WebMock.stub_request(:post, /catservices.test\/catalogue-services\/log\/message/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "Content-Type" => "application/json"
            }
          )
          .to_raise(StandardError)
      end

      let(:stats) { EresourcesStats.new({entry: {"remoteaccess" => "yes", "title" => "test title"}}, "external") }

      it "returns nil" do
        expect { service.post_stats(stats) }.not_to raise_error
      end
    end

    context "when non-200 response" do
      before do
        WebMock.stub_request(:post, /catservices.test\/catalogue-services\/log\/message/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "Content-Type" => "application/json"
            }
          )
          .to_return(status: 501, body: "", headers: {})
      end

      let(:stats) { EresourcesStats.new({entry: {"remoteaccess" => "yes", "title" => "test title"}}, "external") }

      it "returns nil" do
        expect { service.post_stats(stats) }.not_to raise_error
      end
    end
  end

  describe "#user_folio_details" do
    context "when able to get user details" do
      before do
        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/user\?query=id==(.*)/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: folio_details, headers: {})
      end

      let(:folio_details) do
        IO.read("spec/files/account/user_folio_details.json")
      end

      it "does not raise a UserDetailsError" do
        expect { service.user_folio_details("c202a7d5-3d30-411a-b0a7-53753801bf98") }.not_to raise_error
      end

      it "returns FOLIO user details" do
        details = service.user_folio_details("c202a7d5-3d30-411a-b0a7-53753801bf98")
        expect(details).not_to be_nil
        expect(details.dig("personal", "firstName")).to eq "Blacklight"
        expect(details.dig("personal", "lastName")).to eq "Test"
      end
    end

    context "when response is not 200" do
      before do
        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/user\?query=id==(.*)/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 404, body: "", headers: {})
      end

      it "raises a UserDetailsError" do
        expect { service.user_folio_details("1111") }.to raise_error(UserDetailsError)
      end
    end

    context "when unable to get user details" do
      before do
        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/user\?query=id==(.*)/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_raise(StandardError)
      end

      it "raises a UserDetailsError" do
        expect { service.user_folio_details("1111") }.to raise_error(UserDetailsError)
      end
    end
  end
end
