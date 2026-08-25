require "rails_helper"

RSpec.describe RequestHelper do
  describe "#is_dfl_item?" do
    before do
      stub_const("RequestItemHelper::DFL_ENABLED", true)
    end

    it "identifies DFL from the catalogue service loan type" do
      expect(helper.is_dfl_item?({"loanType" => "DFL"})).to be true
    end

    it "does not identify another named loan type as DFL" do
      item = {
        "loanType" => "Reading room",
        "permanentLoanTypeId" => RequestItemHelper::DFL_LEGACY_LOAN_TYPE_IDS.first
      }

      expect(helper.is_dfl_item?(item)).to be false
    end

    it "supports development and test UUIDs until catalogue-services supplies the loan type" do
      results = RequestItemHelper::DFL_LEGACY_LOAN_TYPE_IDS.map do |loan_type_id|
        helper.is_dfl_item?({"permanentLoanTypeId" => loan_type_id})
      end

      expect(results).to all(be true)
    end
  end

  describe "#dfl_request_url" do
    let(:item) { {"barcode" => "77000000789105"} }
    let(:document) do
      SolrDocument.new(
        id: "8068789",
        title_tsim: ["Minefields & Miniskirts"],
        author_with_relator_ssim: ["McHugh, Siobhan"],
        display_publication_date_ssim: ["2026"]
      )
    end

    before do
      allow(helper).to receive(:solr_document_url).with(document).and_return("https://catalogue.example/catalog/8068789")
      allow(helper).to receive(:current_user).and_return(User.new(name_given: "Renata", name_family: "Dyer"))
    end

    it "uses catalogue metadata and the signed-in user's name" do
      query = Rack::Utils.parse_query(URI.parse(helper.dfl_request_url(document, item)).query)

      expect(query).to include(
        "key" => "Access_Request",
        "qnudftb17" => "https://catalogue.example/catalog/8068789",
        "bbudftb01" => "8068789",
        "bbudftb03" => "77000000789105",
        "bbttl" => "Minefields & Miniskirts",
        "bbaut" => "McHugh, Siobhan",
        "bbpd" => "2026",
        "clname" => "Renata Dyer"
      )
      expect(query).not_to have_key("qnudftb11")
    end
  end

  describe "#request_item_link" do
    before do
      stub_const("RequestItemHelper::DFL_ENABLED", true)
      allow(helper).to receive(:current_user).and_return(nil)
    end

    it "keeps an in-use DFL item requestable" do
      item = {"loanType" => "DFL", "displayStatus" => "In use", "barcode" => "77000000789105"}

      link = helper.request_item_link(item, SolrDocument.new(id: "8068789"))
      expect(link).to include("Request to Use in the Library")
      expect(link).to include("bbudftb03=77000000789105")
      expect(link).not_to include("disabled")
    end
  end

  describe "#merge_statements" do
    subject(:statements) do
      statement = {"statement" => "Vol. 1", "note" => "This is a note"}
      helper.merge_statements_and_notes(statement)
    end

    let(:holding) { holdings_response["holdingsRecords"].first }

    it "returns an array" do
      expect(statements.class.name).to eq "Array"
    end

    context "when there is only a statement or a note" do
      subject(:statements) do
        statement = holding["holdingsStatements"].last
        helper.merge_statements_and_notes(statement)
      end

      it "removes empty or nil elements" do
        expect(statements.size).to eq 1
      end
    end

    context "when there are no statements or notes" do
      subject(:statements) { helper.merge_statements_and_notes({"statement" => "", "note" => ""}) }

      it "returns nil" do
        expect(statements).to be_nil
      end
    end
  end

  describe "#recent_item_issue_held" do
    let(:holding) { holdings_response["holdingsRecords"].last }

    it "returns the most recent item issue held" do
      expect { helper.recent_item_issue_held(holding) }.to raise_error(NoMethodError)
    end
  end

  describe "#item_issues_held" do
    subject(:statements) { helper.items_issues_held(holding) }

    let(:holding) { holdings_response["holdingsRecords"].last }

    it "returns an array of issues" do
      expect(statements.class.name).to eq "Array"
      expect(statements).to eq [
        ["v.116:no.6 (1959:Dec.) - v.218:no.1 (2010:July),"],
        ["v.218:no.4 (2010:Oct.) - v.222:no.2 (2012:Aug.)"],
        ["v.222:no.4 (2012:Oct.) - v.242:no.3 (2022:Sep.)"],
        ["v. 242, no. 4 (2022 Oct.)"]
      ]
    end
  end

  describe "#supplements" do
    let(:holding) { holdings_response["holdingsRecords"].last }

    it "returns an array of supplements" do
      expect(supplements(holding).size).to eq 8
    end
  end

  describe "#indexes" do
    let(:holding) { holdings_response["holdingsRecords"].last }

    it "returns an array of indexes" do
      expect(indexes(holding).size).to eq 6
    end
  end

  describe "#pickup_location_text" do
    context "when the pickup location starts with 'MRR'" do
      let(:item) { {"pickupLocation" => {"code" => "MRR-SP"}} }

      it "returns the Main Reading Room pickup location text" do
        expect(pickup_location_text(item)).to include "Main Reading Room"
      end
    end

    context "when the pickup location starts with 'NMRR'" do
      let(:item) { {"pickupLocation" => {"code" => "NMRR-SP"}} }

      it "returns the Newspapers and Family History pickup location text" do
        expect(pickup_location_text(item)).to include "Newspapers and Family History"
      end
    end

    context "when the pickup location starts with 'SCRR'" do
      let(:item) { {"pickupLocation" => {"code" => "SCRR-SP"}} }

      it "returns the Special Collections Reading Room pickup location text" do
        expect(pickup_location_text(item)).to include "Special Collections Reading Room"
      end
    end
  end

  describe "#pickup_location_img" do
    context "when the pickup location starts with 'MRR'" do
      let(:item) { {"pickupLocation" => {"code" => "MRR-SP"}} }

      it "returns the Main Reading Room image" do
        expect(pickup_location_img(item)).to include "NLA_006.png"
      end
    end

    context "when the pickup location starts with 'NMRR'" do
      let(:item) { {"pickupLocation" => {"code" => "NMRR-SP"}} }

      it "returns the Newspapers and Family History image" do
        expect(pickup_location_img(item)).to include "NLA_011.png"
      end
    end

    context "when the pickup location starts with 'SCRR'" do
      let(:item) { {"pickupLocation" => {"code" => "SCRR-SP"}} }

      it "returns the Special Collections Reading Room image" do
        expect(pickup_location_img(item)).to include "NLA_003.png"
      end
    end
  end

  describe "#access_condition_notes" do
    context "when there are restriction notes" do
      let(:holding) { notes_response["holdingsRecords"][1] }

      it "returns the restriction notes only" do
        expect(helper.access_condition_notes(holding).size).to eq 1
        expect(helper.access_condition_notes(holding).first["holdingsNoteType"]).to eq "Restriction"
      end
    end

    context "when there are no restriction notes" do
      let(:holding) { holdings_response["holdingsRecords"].last }

      it "returns no notes" do
        expect(helper.access_condition_notes(holding)).to eq []
      end
    end
  end

  describe "#holding_notes" do
    context "when there are notes" do
      let(:holding) { notes_response["holdingsRecords"][1] }

      it "doesn't return restriction notes" do
        expect(helper.holding_notes(holding).size).to eq 1
        expect(helper.holding_notes(holding).first["holdingsNoteType"]).to eq "Action note"
      end
    end

    context "when there are no holding notes" do
      let(:holding) { holdings_response["holdingsRecords"].last }

      it "returns no notes" do
        expect(helper.holding_notes(holding)).to eq []
      end
    end
  end

  describe "#shelving_title" do
    context "when there is a shelving title" do
      let(:holding) { {"shelvingTitle" => "G.C. Bleeck/Misc #1"} }

      it "returns the shelvingTitle" do
        expect(helper.shelving_title(holding)).to eq "G.C. Bleeck/Misc #1"
      end
    end

    context "when there is no shelvingTitle" do
      let(:holding) { {"shelvingTitle" => nil} }

      it "returns nil" do
        expect(helper.shelving_title(holding)).to be_nil
      end
    end
  end

  describe "#items_issues_in_use" do
    context "when there are notes" do
      let(:holding) { holdings_response["holdingsRecords"][4] }

      it "returns the items/issues in use" do
        expect(helper.items_issues_in_use(holding).size).to eq 14
      end

      it "merges chronology, enumeration and yearCaption into a single string" do
        expect(helper.items_issues_in_use(holding)[2]).to eq "March, April, May 2022"
      end
    end
  end

  def holdings_response
    JSON.parse(IO.read("spec/files/catalogue_services/serial.json"))
  end

  def notes_response
    JSON.parse(IO.read("spec/files/catalogue_services/serial_manuscript.json"))
  end
end
