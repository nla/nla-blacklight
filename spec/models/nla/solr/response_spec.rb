# frozen_string_literal: true

require "rails_helper"

RSpec.describe Nla::Solr::Response do
  let(:config) { Blacklight::Configuration.new }

  context "when a standard search is performed" do
    subject(:r) { described_class.new(standard_response, {}) }

    it "provides spelling suggestions for regular search" do
      expect(r.spelling.words).to include("4130260529")
    end
  end

  context "when an advanced search is performed" do
    subject(:r) { described_class.new(advanced_response, {}) }

    it "provides spelling suggestions for advanced search" do
      expect(r.spelling.words).to include("4130260529")
    end

    it "excludes defType terms from spelling suggestions" do
      expect(r.spelling.words).not_to include("dismax")
    end
  end

  context "when there are no spelling suggestions" do
    subject(:r) { described_class.new(no_suggestions_response, {}) }

    it "returns an empty array of suggestions" do
      expect(r.spelling.words).to eq([])
    end
  end

  def advanced_response
    JSON.parse(IO.read("spec/files/spellcheck/advanced_response.json"))
  end

  def standard_response
    JSON.parse(IO.read("spec/files/spellcheck/standard_response.json"))
  end

  def no_suggestions_response
    JSON.parse(IO.read("spec/files/spellcheck/no_suggestions.json"))
  end
end
