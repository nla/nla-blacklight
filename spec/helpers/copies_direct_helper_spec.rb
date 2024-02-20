# frozen_string_literal: true

require "rails_helper"

RSpec.describe CopiesDirectHelper do
  let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 4157458, format: ["Picture"]) }
  let(:view_context) { instance_double(ActionView::Base) }
  let(:config) { Blacklight::Configuration.new.view_config(:show) }

  describe "#copies_direct_link" do
    subject(:link) { helper.copies_direct_link(document.id) }

    it "generates a link to submit the Copies Direct form on-click" do
      expect(link).to include "https://test.nla.gov.au/copies-direct/items/import?source=cat&amp;sourcevalue=4157458"
    end
  end

  # Need to set the MARC source field to actual MARC XML in order to allow
  # the "#to_marc" method to be included in the SolrDocument model.
  def sample_marc
    load_marc_from_file 4157458
  end
end
