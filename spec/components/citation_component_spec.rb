# frozen_string_literal: true

require "rails_helper"

RSpec.describe CitationComponent, type: :component do
  let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 4157485) }

  it "renders the persistent identifier" do
    render_inline(described_class.new(document: document))
    expect(page.text).to include("https://nla.gov.au/nla.cat-vn4157485")
  end

  it "renders the MLA citation" do
    render_inline(described_class.new(document: document))
    expect(page.text).to include("MLA")
  end

  it "renders the APA citation" do
    render_inline(described_class.new(document: document))
    expect(page.text).to include("APA")
  end

  it "renders the Chicago citation" do
    render_inline(described_class.new(document: document))
    expect(page.text).to include("Chicago")
  end

  it "renders the Australian/Harvard citation" do
    render_inline(described_class.new(document: document))
    expect(page.text).to include("Australian/Harvard")
  end

  it "renders the Wikipedia citation" do
    render_inline(described_class.new(document: document))
    expect(page.text).to include("Wikipedia")
  end

  def sample_marc
    load_marc_from_file 4157458
  end
end
