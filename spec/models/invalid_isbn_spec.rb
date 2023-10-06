require "rails_helper"

RSpec.describe InvalidIsbn do
  describe "#value" do
    let(:document) { SolrDocument.new(marc_ss: invalid_isbn) }

    context "when there is an invalid ISBN" do
      subject(:invalid_isbn_value) do
        described_class.new(document.marc_xml).value
      end

      it "will return the invalid ISBN" do
        expect(invalid_isbn_value).to eq ["0855504404", "085550448X (corrected) (soft)"]
      end
    end

    context "when there are more than one ISBN" do
      subject(:invalid_isbn_value) do
        described_class.new(document.marc_xml).value
      end

      it "will return all the invalid ISBNs in a single string" do
        expect(invalid_isbn_value).to eq ["0855504404", "085550448X (corrected) (soft)"]
      end
    end

    context "when there is a qualifier" do
      subject(:invalid_isbn_value) do
        described_class.new(document.marc_xml).value
      end

      it "will append it after the invalid ISBN" do
        expect(invalid_isbn_value[1]).to include " (corrected) (soft)"
      end
    end

    context "when there is no invalid ISBN" do
      subject(:invalid_isbn_value) do
        described_class.new(document.marc_xml).value
      end

      let(:document) { SolrDocument.new(marc_ss: issn) }

      it "will return nil" do
        expect(invalid_isbn_value).to be_nil
      end
    end

    context "when there is extra punctuation around the invalid ISBN" do
      subject(:isbn_value) do
        described_class.new(document.marc_xml).value
      end

      let(:document) { SolrDocument.new(marc_ss: isbn_format) }

      it "will strip extra punctuation around the ISBN" do
        expect(isbn_value).to eq [
          "9781478005773 (hardcover) (alkaline paper)",
          "1478006676 (hardcover) (alkaline paper)",
          "9781478006671 (paperback) (alkaline paper)",
          "1478005777 (hardcover ;) (alkaline paper)"
        ]
      end
    end
  end

  def invalid_isbn
    load_marc_from_file 1868021
  end

  def isbn_format
    load_marc_from_file 8420291
  end

  def issn
    load_marc_from_file 28336
  end
end
