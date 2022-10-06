# frozen_string_literal: true

require "rails_helper"

RSpec.describe CopyrightHelper do
  let(:document) { SolrDocument.new(marc_ss: sample_marc) }
  let(:view_context) { instance_double(ActionView::Base) }
  let(:config) { Blacklight::Configuration.new.view_config(:show) }

  describe "#fair_dealing_link" do
    subject(:link) { helper.fair_dealing_link }

    it "generates a link using the environment variable value" do
      stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_FAIR_DEALING_URL" => "https://fairdealing.example.com"))

      expect(link).to include '<a href="https://fairdealing.example.com">fair dealing</a>'
    end
  end

  describe "#rights_contact_us_link" do
    subject(:link) { helper.rights_contact_us_link }

    it "generates a link using the environment variable value" do
      stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_CONTACT_URL" => "https://example.com/contact-us"))

      expect(link).to include '<a href="https://example.com/contact-us">contact us</a>'
    end
  end

  describe "#copies_direct_link" do
    subject(:link) { helper.copies_direct_link }

    it "generates a link to submit the Copies Direct form on-click" do
      expect(link).to include '<a onclick="document.getElementById(\'copiesdirect_addcart\').submit();" href="javascript:;">Copies Direct</a>'
    end
  end

  # Need to set the MARC source field to actual MARC XML in order to allow
  # the "#to_marc" method to be included in the SolrDocument model.
  def sample_marc
    IO.read("spec/files/marc/4157458.marcxml")
  end
end
