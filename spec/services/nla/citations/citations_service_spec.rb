# frozen_string_literal: true

require "rails_helper"

RSpec.describe Nla::Citations::CitationsService do
  let(:document) { SolrDocument.new(id: "123", title_tsim: "Title", format: "Book", date_lower_isi: "2019", publisher: "Publisher", publication_place: "Publication Place") }
  let(:service) { described_class.new(document) }

  describe "#cite_authors" do
    context "when there is only a primary author" do
      let(:document) { SolrDocument.new(id: "123", title_tsim: "Title", format: "Book", date_lower_isi: "2019", publisher: "Publisher", publication_place: "Publication Place", author_search_tsim: ["Author, A."]) }

      it "returns the author" do
        expect(service.cite_authors).to eq(["Author, A."])
      end
    end

    context "when there are only other authors" do
      let(:document) { SolrDocument.new(id: "123", title_tsim: "Title", format: "Book", date_lower_isi: "2019", publisher: "Publisher", publication_place: "Publication Place", author_search_tsim: ["Author, A.", "Author, B."]) }

      it "returns the author" do
        expect(service.cite_authors).to eq(["Author, A.", "Author, B."])
      end
    end

    context "when there are both primary and other authors" do
      let(:document) { SolrDocument.new(id: "123", title_tsim: "Title", format: "Book", date_lower_isi: "2019", publisher: "Publisher", publication_place: "Publication Place", author_search_tsim: ["Author, A.", "Author, B.", "Author, C."]) }

      it "returns the authors" do
        expect(service.cite_authors).to eq(["Author, A.", "Author, B.", "Author, C."])
      end
    end
  end
end
