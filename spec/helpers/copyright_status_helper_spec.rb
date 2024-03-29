# frozen_string_literal: true

require "rails_helper"

RSpec.describe CopyrightStatusHelper do
  let(:document) { SolrDocument.new(marc_ss: sample_marc) }
  let(:view_context) { instance_double(ActionView::Base) }
  let(:config) { Blacklight::Configuration.new.view_config(:show) }

  describe "#fair_dealing_link" do
    it "raises an error" do
      expect { helper.fair_dealing_link }.to raise_error(NoMethodError)
    end
  end

  describe "#rights_contact_us_link" do
    subject(:link) { helper.rights_contact_us_link }

    it "generates a link using the environment variable value" do
      expect(link).to include '<a href="https://test.nla.gov.au/contact-us">Contact us</a>'
    end
  end

  # Need to set the MARC source field to actual MARC XML in order to allow
  # the "#to_marc" method to be included in the SolrDocument model.
  def sample_marc
    load_marc_from_file 4157458
  end
end
