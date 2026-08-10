# frozen_string_literal: true

require "rails_helper"

RSpec.describe Blacklight::SearchContext::ServerItemPaginationComponent, type: :component do
  subject(:component) do
    described_class.new(search_context: search_context, search_session: search_session, current_document: current_document)
  end

  let(:current_document) { SolrDocument.new(id: "123") }
  let(:search_session) { {"counter" => "1", "total" => "3"} }
  let(:search_context) { {prev: SolrDocument.new(id: "122"), next: SolrDocument.new(id: "124")} }

  describe "#render?" do
    context "when search_context has prev and next" do
      it "returns true" do
        expect(component).to be_render
      end

      context "when search_context only has prev" do
        let(:search_context) { {prev: SolrDocument.new(id: "122"), next: nil} }

        it "returns true" do
          expect(component).to be_render
        end
      end

      context "when search_context only has next" do
        let(:search_context) { {prev: nil, next: SolrDocument.new(id: "124")} }

        it "returns true" do
          expect(component).to be_render
        end
      end
    end

    context "when search_context has no prev or next but total is positive" do
      let(:search_context) { {prev: nil, next: nil} }

      it "returns true" do
        expect(component).to be_render
      end
    end

    context "when search_context is empty and total is zero" do
      let(:search_context) { {} }
      let(:search_session) { {"counter" => "0", "total" => "0"} }

      it "returns false" do
        expect(component).not_to be_render
      end
    end

    context "when search_session document_id does not match current document" do
      let(:search_session) { {"document_id" => "999", "counter" => "1", "total" => "3"} }

      it "returns true (does not require document_id to match)" do
        expect(component).to be_render
      end
    end

    context "when search_session has no document_id" do
      let(:search_session) { {"counter" => "1", "total" => "3"} }

      it "returns true" do
        expect(component).to be_render
      end
    end
  end

  describe "rendering" do
    it "does not render when search_context is empty and total is zero" do
      empty_context = {}
      empty_session = {"counter" => "0", "total" => "0"}
      comp = described_class.new(search_context: empty_context, search_session: empty_session, current_document: current_document)

      render_inline(comp)

      expect(page.text).to be_blank
    end
  end
end
