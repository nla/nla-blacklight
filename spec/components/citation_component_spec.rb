# frozen_string_literal: true

require "rails_helper"

RSpec.describe CitationComponent, type: :component do
  context "when citing a journal" do
    let(:document) { SolrDocument.new(marc_ss: journal_marc, id: 8425632, format: "Journal") }

    it "renders the persistent identifier" do
      render_inline(described_class.new(document: document))
      expect(page.text).to include("https://nla.gov.au/nla.cat-vn8425632")
    end

    it "renders the MLA citation" do
      render_inline(described_class.new(document: document))
      expect(page.text).to include("MLA")
    end

    it "renders the APA citation" do
      render_inline(described_class.new(document: document))
      expect(page.text).to include("APA")
    end

    it "renders the Australian/Harvard citation" do
      render_inline(described_class.new(document: document))
      expect(page.text).to include("Australian/Harvard")
    end

    it "renders the Wikipedia citation" do
      render_inline(described_class.new(document: document))
      expect(page.text).to include("Wikipedia")
    end
  end

  context "when citing a book" do
    let(:document) { SolrDocument.new(marc_ss: book_marc, id: 3601830, format: "Book") }

    it "renders the persistent identifier" do
      render_inline(described_class.new(document: document))
      expect(page.text).to include("https://nla.gov.au/nla.cat-vn3601830")
    end

    it "renders the MLA citation" do
      render_inline(described_class.new(document: document))
      expect(page.text).to include("MLA")
    end

    it "renders the APA citation" do
      render_inline(described_class.new(document: document))
      expect(page.text).to include("APA")
    end

    it "renders the Australian/Harvard citation" do
      render_inline(described_class.new(document: document))
      expect(page.text).to include("Australian/Harvard")
    end

    it "renders the Wikipedia citation" do
      render_inline(described_class.new(document: document))
      expect(page.text).to include("Wikipedia")
    end
  end

  def journal_marc
    load_marc_from_file 8425632
  end

  def book_marc
    load_marc_from_file 3601830
  end
end
