# frozen_string_literal: true

require "rails_helper"

RSpec.describe ThumbnailService, type: :request do
  subject(:service) { described_class.new }

  describe "#get_url" do
    context "when unable to connect to thumbnail service" do
      it "returns nil" do
        WebMock.stub_request(:get, /thumbservices.test\/thumbnail-service\/thumbnail\/url/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_raise(StandardError)

        expect(service.get_url(id: "123")).to be_nil
      end
    end
  end
end
