# frozen_string_literal: true

require "rails_helper"

RSpec.describe CopiesDirectOrderFormComponent, type: :component do
  let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 4157485, format: ["Picture"]) }

  it "renders the Copies Direct form" do
    render_inline(described_class.new(document: document))

    expect(page).to have_css("#copiesdirect_addcart")
  end

  def sample_marc
    load_marc_from_file 4157458
  end
end
