# frozen_string_literal: true

require "rails_helper"

RSpec.describe EzproxyUrl do
  include ActiveSupport::Testing::TimeHelpers

  let(:url) { "" }

  context "when given a blank url" do
    it "raises a RuntimeError" do
      expect { described_class.new(url) }.to raise_error(RuntimeError, "Invalid URL")
    end
  end

  context "when not given a blank url" do
    subject(:ezproxy_url) { described_class.new(url).url }

    let(:url) { "https://example.com" }

    it "generates an ezproxy url" do
      expect(ezproxy_url).not_to be_nil
    end

    it "generates an ezproxy authentication ticket" do
      Time.use_zone("Canberra") do
        travel_to Time.zone.local(2022, 11, 28, 0, 0, 0) do
          expect(ezproxy_url).to include "ticket=60d52eca002749aef4d50486c91c2a6d%24u1669554000"
        end
      end
    end
  end
end
