# frozen_string_literal: true

require "rails_helper"

RSpec.describe SingleSearchHelper do
  describe "#downcast" do
    it "downcases a string" do
      expect(helper.downcast("HELLO")).to eq("hello")
    end

    it "replaces spaces with underscores" do
      expect(helper.downcast("hello world")).to eq("hello_world")
    end

    it "replaces dashes with underscores" do
      expect(helper.downcast("hello-world")).to eq("hello_world")
    end

    it "replaces slashes with underscores" do
      expect(helper.downcast("hello/world")).to eq("hello_world")
    end
  end

  describe "#is_catalog_pane?" do
    it "returns true if the pane title is Catalogue" do
      expect(helper.is_catalog_pane?("Catalogue")).to be true
    end

    it "returns false if the pane title is not Catalogue" do
      expect(helper.is_catalog_pane?("Finding Aids")).to be false
    end
  end

  describe "#is_catalogued?" do
    it "returns true if the url starts with \"catalogue\"" do
      expect(helper.is_catalogued?("https://catalogue.example.com:3000/catalog/1234")).to be true
    end

    it "returns false if the url does not start with \"catalogue\"" do
      expect(helper.is_catalogued?("https://localhost:3000/")).to be false
    end

    it "returns false if the url is nil" do
      expect(helper.is_catalogued?(nil)).to be false
    end

    it "returns false if the url is invalid" do
      expect(helper.is_catalogued?("Full text available from Masterfile Premier: 01/01/1990 to present")).to be false
    end
  end

  describe "#ss_uri_encode" do
    it "replaces spaces with %20" do
      expect(helper.ss_uri_encode("hello world")).to eq("hello%20world")
    end

    it "replaces $ with %24" do
      expect(helper.ss_uri_encode("hello$world")).to eq("hello%24world")
    end

    it "replaces ; with %3B" do
      expect(helper.ss_uri_encode("hello;world")).to eq("hello%3Bworld")
    end

    it "replaces [ with %5B" do
      expect(helper.ss_uri_encode("hello[world")).to eq("hello%5Bworld")
    end

    it "replaces ] with %5D" do
      expect(helper.ss_uri_encode("hello]world")).to eq("hello%5Dworld")
    end

    it "replaces \" with %22" do
      expect(helper.ss_uri_encode("hello\"world")).to eq("hello%22world")
    end

    it "replaces ( with %28" do
      expect(helper.ss_uri_encode("hello(world")).to eq("hello%28world")
    end

    it "replaces ) with %29" do
      expect(helper.ss_uri_encode("hello)world")).to eq("hello%29world")
    end

    it "replaces % with %25" do
      expect(helper.ss_uri_encode("hello%world")).to eq("hello%25world")
    end

    it "does not replace % with %25 if it is already encoded" do
      expect(helper.ss_uri_encode("hello%25world")).to eq("hello%25world")
    end
  end

  describe "#advanced_search_link" do
    it "returns a link to the advanced search page" do
      expect(helper.advanced_search_link("catalogue", "hello")).to eq("http://test.host/catalog/advanced?all_fields=hello&search_field=advanced")
    end
  end

  describe "#bento_all_results_link" do
    context "when a query is present" do
      before do
        controller.params[:q] = "hello"
      end

      it "returns a link to the catalogue search results page" do
        expect(helper.bento_all_results_link("catalogue")).to eq("http://test.host/catalog?search_field=all_fields&q=hello")
      end

      it "returns a link to the finding aids search results page" do
        expect(helper.bento_all_results_link("finding_aids")).to eq("http://test.host/finding-aids/catalog?group=false&search_field=all_fields&q=hello")
      end

      it "returns a link to the EDS keyword search results page" do
        expect(helper.bento_all_results_link("ebsco_eds_keyword")).to eq("https://research.ebsco.com/c/ciw6tp/search/results?q=hello&limiters=FT1%253AY&searchMode=all&searchSegment=all-results")
      end

      it "returns a link to the EDS title search results page" do
        expect(helper.bento_all_results_link("ebsco_eds_title")).to eq("https://publications.ebsco.com/c/elukgh?searchField=titlename&searchtype=contains&highlightTag=mark&search=hello")
      end
    end

    context "when a query is not present" do
      it "returns a link to the catalogue search results page" do
        expect(helper.bento_all_results_link("catalogue")).to eq("http://test.host/catalog?search_field=all_fields&q=") # eq("https://search.ebscohost.com/login.aspx?authtype=ip,guest&groupid=main&profile=eds&direct=true&custid=test?q=hello&limiters=FT1%253AY&searchMode=all&searchSegment=all-results")
      end

      it "returns a link to the finding aids search results page" do
        expect(helper.bento_all_results_link("finding_aids")).to eq("http://test.host/finding-aids/catalog?group=false&search_field=all_fields&q=")
      end

      it "returns a link to the EDS keyword search results page" do
        expect(helper.bento_all_results_link("ebsco_eds_keyword")).to eq("https://research.ebsco.com/c/ciw6tp/search/results")
      end

      it "returns a link to the EDS title search results page" do
        expect(helper.bento_all_results_link("ebsco_eds_title")).to eq("https://publications.ebsco.com/c/elukgh")
      end
    end
  end
end
