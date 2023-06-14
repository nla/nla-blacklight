# frozen_string_literal: true

require "rails_helper"

RSpec.describe Nla::Citations::MlaCitationService do
  let(:document) { SolrDocument.new(id: "123", title_tsim: "Title", format: "Book", date_lower_isi: "2019", publisher: "Publisher", publication_place: "Publication Place") }
  let(:service) { described_class.new(document) }

  describe "#cite_authors" do
    context "when there is only a single author" do
      let(:document) { SolrDocument.new(id: "123", title_tsim: "Title", format: "Book", date_lower_isi: "2019", publisher: "Publisher", publication_place: "Publication Place", author_search_tsim: ["Author, A."]) }

      it "returns the author" do
        expect(service.cite_authors).to eq("Author, A..")
      end
    end

    context "when there are multiple authors" do
      let(:document) { SolrDocument.new(id: "123", title_tsim: "Title", format: "Book", date_lower_isi: "2019", publisher: "Publisher", publication_place: "Publication Place", author_search_tsim: ["Author, A.", "Author, B."]) }

      it "returns the author" do
        expect(service.cite_authors).to eq("Author, A. and Author, B..")
      end
    end
  end

  describe "#cite_publisher" do
    context "when there is only a publisher" do
      let(:document) { SolrDocument.new(marc_ss: book_marc, id: "123", title_tsim: "Title", format: "Book", date_lower_isi: "2019") }

      it "returns the publisher" do
        expect(service.cite_publisher).to include("Murdoch")
      end
    end

    context "when there is both a publisher and a publication place" do
      let(:document) { SolrDocument.new(marc_ss: book_marc, id: "123", title_tsim: "Title", format: "Book", date_lower_isi: "2019") }

      it "returns the publisher and the publication place" do
        expect(service.cite_publisher).to eq("Murdoch Sydney")
      end
    end
  end

  describe "#cite_pubdate" do
    context "when there is a publication date" do
      let(:document) { SolrDocument.new(marc_ss: book_marc, id: "123", title_tsim: "Title", format: "Book", date_lower_isi: "2019") }

      it "returns the publication date" do
        expect(service.cite_pubdate).to eq "2019"
      end
    end

    context "when there is no publication date" do
      let(:document) { SolrDocument.new(marc_ss: book_marc, id: "123", title_tsim: "Title", format: "Book") }

      it "returns nil" do
        expect(service.cite_pubdate).to be_nil
      end
    end
  end

  def book_marc
    load_marc_from_file 3601830
  end
end
