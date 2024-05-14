require "rails_helper"
require "./app/services/catalogue_services_client"

RSpec.describe "Account" do
  before do
    user = create(:user)
    sign_in user
  end

  context "when DISABLE_REQUESTING is `true`" do
    it "does not render the request button" do
      WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/request\/(.*)/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: monograph_details_response, headers: {})

      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("DISABLE_REQUESTING").and_return("true")

      visit root_path

      click_link("Test User")

      expect(page).not_to have_link I18n.t("account.requests.menu"), href: account_requests_path
    end
  end

  context "when DISABLE_REQUESTING is `false`" do
    it "renders the request button" do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("DISABLE_REQUESTING").and_return("false")

      visit root_path

      click_link("Test User")

      expect(page).to have_link I18n.t("account.requests.menu"), href: account_requests_path
    end
  end

  context "when DISABLE_REQUESTING is defined without a value" do
    it "renders the request button" do
      WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/request\/(.*)/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: monograph_details_response, headers: {})

      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("DISABLE_REQUESTING").and_return(nil)

      visit root_path

      click_link("Test User")

      expect(ENV["DISABLE_REQUESTING"]).to be_nil
      expect(page).to have_link I18n.t("account.requests.menu"), href: account_requests_path
    end
  end

  context "when DISABLE_REQUESTING is not defined" do
    it "renders the request button" do
      WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/request\/(.*)/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: monograph_details_response, headers: {})

      visit root_path

      click_link("Test User")

      expect(page).to have_link I18n.t("account.requests.menu"), href: account_requests_path
    end
  end

  describe "GET /requests" do
    context "when user has reached their request limit" do
      it "renders the request limit error" do
        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/user\/(.*)\/requestLimitReached/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: "{\"requestLimitReached\": \"true\"}", headers: {})

        visit account_requests_path

        expect(page).to have_css(".alert-danger", text: "Your request limit has been reached")
        expect(page).not_to have_css("#request-details")
      end
    end

    context "when user has not reached their request limit" do
      it "does not render the limit error" do
        visit account_requests_path

        expect(page).to have_css(".alert-info", text: "You can request")
        expect(page).not_to have_css(".alert-danger", text: "Your request limit has been reached")
      end
    end
  end

  describe "GET /request_details/:id" do
    context "when loan param is not provided" do
      let(:request_id) { "1bec702d-2bf9-421e-953c-cd5188e8d9c6" }

      it "displays an error" do
        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/request\/(.*)/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: monograph_details_response, headers: {})

        visit account_request_details_path(request_id)

        expect(page).not_to have_text("[Hurstville Light Opera Company : programs and related material collected by the National Library of Australia]")
      end
    end

    context "when item is a monograph" do
      let(:request_id) { "1bec702d-2bf9-421e-953c-cd5188e8d9c6" }

      it "renders the monograph request details" do
        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/request\/(.*)/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: monograph_details_response, headers: {})

        visit account_request_details_path(request_id, loan: false)

        expect(page).to have_css(".document-title-heading", text: "[Hurstville Light Opera Company : programs and related material collected by the National Library of Australia]")
        expect(page).to have_css(".col.col-md-8", text: "Special Collections Reading Room")
        expect(page).to have_css(".col.col-md-8", text: "18 September 2023")
        expect(page).to have_css(".text-muted", text: "04:34pm")
        expect(page).to have_css(".col.col-md-8", text: "test")
      end
    end

    context "when item is a serial" do
      let(:request_id) { "d7746c53-7746-4b0e-8382-5261aa9bcecb" }

      it "renders the monograph request details" do
        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/request\/(.*)/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: serial_details_response, headers: {})

        visit account_request_details_path(request_id, loan: false)

        expect(page).to have_css(".document-title-heading", text: "National geographic.")
        expect(page).to have_css(".col.col-md-8", text: "Special Collections Reading Room")
        expect(page).to have_css(".col.col-md-8", text: "1960")
        expect(page).to have_css(".col.col-md-8", text: "118")
        expect(page).to have_css(".col.col-md-8", text: "August")
        expect(page).to have_css(".col.col-md-8", text: "22 September 2023")
        expect(page).to have_css(".text-muted", text: "09:52am")
        expect(page).to have_css(".col.col-md-8", text: "test after running number reset")
      end
    end

    context "when item is a manuscript" do
      let(:request_id) { "84db922c-517c-4343-8cbd-0cda581f597f" }

      it "renders the manuscript request details" do
        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/request\/(.*)/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: manuscript_details_response, headers: {})

        visit account_request_details_path(request_id, loan: false)

        expect(page).to have_css(".document-title-heading", text: "Correspondence to Andrew Endrey from Hu Feng, Mei Zhi and Zhang Xiaofeng, 1979-2022.")
        expect(page).to have_css(".col.col-md-8", text: "Special Collections Reading Room")
        expect(page).to have_css(".col.col-md-8", text: "Shared")
        expect(page).to have_css(".col.col-md-8", text: "2")
        expect(page).to have_css(".col.col-md-8", text: "26 September 2023")
        expect(page).to have_css(".text-muted", text: "01:21pm")
        expect(page).to have_css(".col.col-md-8", text: "serial test")
      end
    end

    context "when item is a map" do
      let(:request_id) { "f97adbf5-2b70-4a12-b6d0-e92d21978f50" }

      it "renders the map request details" do
        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/request\/(.*)/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: map_details_response, headers: {})

        visit account_request_details_path(request_id, loan: false)

        expect(page).to have_css(".document-title-heading", text: "Fishing map series [cartographic material] : [Australia]")
        expect(page).to have_css(".col.col-md-8", text: "Special Collections Reading Room")
        expect(page).to have_css(".col.col-md-8", text: "1990")
        expect(page).to have_css(".col.col-md-8", text: "26 September 2023")
        expect(page).to have_css(".text-muted", text: "01:46pm")
        expect(page).to have_css(".col.col-md-8", text: "map test")
      end
    end
  end

  def monograph_details_response
    IO.read("spec/files/account/request_details/monograph.json")
  end

  def serial_details_response
    IO.read("spec/files/account/request_details/serial.json")
  end

  def manuscript_details_response
    IO.read("spec/files/account/request_details/manuscript.json")
  end

  def map_details_response
    IO.read("spec/files/account/request_details/map.json")
  end
end
