# frozen_string_literal: true

require "rails_helper"

RSpec.describe Nla::Citations::WikimediaCitationService do
  let(:document) { SolrDocument.new(id: "123", title_tsim: "Title", format: ["Book"], date_lower_isi: "2019", publisher_tsim: ["Murdoch"], display_publication_place_ssim: ["Sydney :"]) }
  let(:service) { described_class.new(document) }

  describe "#build_title" do
    context "when the format is journal" do
      it "returns the title with additional fields" do
        expect(service.build_title("Journal")).to eq(" | title=[article title here]\n | author=[article author here]\n | author2=[first co-author here]\n | date=[date of publication]\n | journal=Title\n")
      end
    end

    context "when the format is not journal" do
      it "returns the title without additional fields" do
        expect(service.build_title("Book")).to eq(" | title=Title\n")
      end
    end

    context "when there is no format" do
      let(:document) { SolrDocument.new(id: "123", title_tsim: "Title", date_lower_isi: "2019", publisher_tsim: ["Murdoch"], display_publication_place_ssim: ["Sydney :"], marc_ss: book_marc) }

      it "returns the title without additional fields" do
        expect(service.export).to include(" | title=Title\n")
      end
    end
  end

  describe "#build_authors" do
    context "when there is only a single author" do
      let(:document) { SolrDocument.new(id: "123", title_tsim: "Title", format: ["Book"], date_lower_isi: "2019", publisher_tsim: ["Murdoch"], display_publication_place_ssim: ["Sydney :"], author_search_tsim: ["Author, A."]) }

      it "returns the author" do
        expect(service.build_authors).to eq(" | author1=Author, A.\n")
      end
    end

    context "when there are multiple authors" do
      let(:document) { SolrDocument.new(id: "123", title_tsim: "Title", format: ["Book"], date_lower_isi: "2019", publisher_tsim: ["Murdoch"], display_publication_place_ssim: ["Sydney :"], author_search_tsim: ["Author, A.", "Author, B."]) }

      it "returns the author" do
        expect(service.build_authors).to eq(" | author1=Author, A.\n | author2=Author, B.\n")
      end
    end
  end

  describe "#build_pubdate" do
    context "when there is a publication date" do
      let(:document) { SolrDocument.new(marc_ss: book_marc, id: "123", title_tsim: "Title", format: ["Book"], date_lower_isi: "2019") }

      it "returns the publication date" do
        expect(service.build_pubdate).to eq(" | year=2019\n")
      end
    end

    context "when there is no publication date" do
      let(:document) { SolrDocument.new(marc_ss: book_marc, id: "123", title_tsim: "Title", format: ["Book"]) }

      it "returns nil" do
        expect(service.build_pubdate).to be_nil
      end
    end
  end

  describe "#build_publisher" do
    context "when there is a publisher" do
      let(:document) { SolrDocument.new(marc_ss: book_marc, id: "123", title_tsim: "Title", format: ["Book"], publisher_tsim: ["Murdoch"]) }

      it "returns the publisher" do
        expect(service.build_publisher).to eq(" | publisher=Murdoch\n")
      end
    end

    context "when there is no publisher" do
      let(:document) { SolrDocument.new(marc_ss: book_marc, id: "123", title_tsim: "Title", format: ["Book"]) }

      it "returns nil" do
        allow(document).to receive(:publisher).and_return(nil)

        expect(service.build_publisher).to be_nil
      end
    end
  end

  describe "#build_isbns" do
    context "when there is an isbn" do
      let(:document) { SolrDocument.new(marc_ss: book_marc, id: "123", title_tsim: "Title", format: ["Book"], isbn_tsim: ["9781740457590 :", "1740457595", "9781740457590"]) }

      it "returns the isbn" do
        expect(service.build_isbns).to eq(" | isbn=9781740457590\n")
      end
    end

    context "when there is no isbn" do
      let(:document) { SolrDocument.new(marc_ss: book_marc, id: "123", title_tsim: "Title", format: ["Book"], isbn: isbn) }
      let(:isbn) { instance_double(Isbn, isbn_list: nil) }

      it "returns nil" do
        expect(service.build_isbns).to be_nil
      end
    end
  end

  describe "#build_language" do
    context "when there is a language" do
      let(:document) { SolrDocument.new(marc_ss: book_marc, id: "123", title_tsim: "Title", format: ["Book"], language_ssim: "English") }

      it "returns the language" do
        expect(service.build_language).to eq(" | language=English\n")
      end
    end

    context "when there is no language" do
      let(:document) { SolrDocument.new(marc_ss: book_marc, id: "123", title_tsim: "Title", format: ["Book"]) }

      it "returns nil" do
        expect(service.build_language).to eq(" | language=No linguistic content\n")
      end
    end
  end

  describe "#build_persistent_url" do
    context "when there is an id" do
      let(:document) { SolrDocument.new(marc_ss: book_marc, id: "123", title_tsim: "Title", format: ["Book"]) }

      it "returns the id" do
        expect(service.build_persistent_url).to eq(" | url=https://nla.gov.au/nla.cat-vn123\n")
      end
    end

    context "when there is no id" do
      let(:document) { SolrDocument.new(marc_ss: book_marc, title_tsim: "Title", format: ["Book"]) }

      it "returns nil" do
        expect(service.build_persistent_url).to be_nil
      end
    end
  end

  describe "#build_access_date" do
    context "when date is correct" do
      let(:document) { SolrDocument.new(marc_ss: book_marc, id: "123", title_tsim: "Title", format: ["Book"]) }

      it "returns the correct date" do
        expect(service.build_access_date).to eq(" | access-date=" + Time.zone.today.strftime("%d %B %Y") + "\n")
      end
    end
  end

  describe "#build_via" do
    context "when via is correct" do
      let(:document) { SolrDocument.new(marc_ss: book_marc, id: "123", title_tsim: "Title", format: ["Book"]) }

      it "returns the correct string" do
        expect(service.build_via).to eq(" | via=National Library of Australia\n")
      end
    end
  end

  def book_marc
    load_marc_from_file 3601830
  end
end
