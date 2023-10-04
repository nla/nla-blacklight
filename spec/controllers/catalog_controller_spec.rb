# frozen_string_literal: true

require "rails_helper"

RSpec.describe CatalogController do
  it "includes BentoSessionResetConcern" do
    expect(described_class.ancestors).to include(BentoSessionResetConcern)
  end
end
