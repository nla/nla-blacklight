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

      it "returns an empty array" do
        expect(statements).to eq []
      end
    end
  end

  describe "#recent_item_issue_held" do
    subject(:statements) { helper.recent_item_issue_held(holding) }

    let(:holding) { holdings_response["holdingsRecords"].last }

    it "returns the most recent item issue held" do
      expect(statements).to eq ["v. 242, no. 4 (2022 Oct.)"]
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
        ["v.222:no.4 (2012:Oct.) - v.242:no.3 (2022:Sep.)"]
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
        expect(pickup_location_img(item)).to include "main_reading_room.jpg"
      end
    end

    context "when the pickup location starts with 'NMRR'" do
      let(:item) { {"pickupLocation" => {"code" => "NMRR-SP"}} }

      it "returns the Newspapers and Family History image" do
        expect(pickup_location_img(item)).to include "newspapers_and_family_history_zone.jpg"
      end
    end

    context "when the pickup location starts with 'SCRR'" do
      let(:item) { {"pickupLocation" => {"code" => "SCRR-SP"}} }

      it "returns the Special Collections Reading Room image" do
        expect(pickup_location_img(item)).to include "special_collections.jpg"
      end
    end
  end

  def holdings_response
    JSON.parse(IO.read("spec/files/catalogue_services/serial.json"))
  end
end
