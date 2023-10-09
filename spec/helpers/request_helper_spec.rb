require "rails_helper"

RSpec.describe RequestHelper do
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
