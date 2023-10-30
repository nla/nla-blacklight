require "webmock/rspec"

# Disables HTTP requests, with the exception of requests to localhost
WebMock.disable_net_connect!(
  allow_localhost: true,
  allow: "chromedriver.storage.googleapis.com"
)

RSpec.configure do |config|
  config.before do
    eresource_config = IO.read("spec/files/eresources/config.txt")
    WebMock.stub_request(:get, "http://eresource-manager.example.com/")
      .with(
        headers: {
          "Accept" => "application/json",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
        }
      )
      .to_return(status: 200, body: eresource_config, headers: {})

    WebMock.stub_request(:get, "http://eresource-manager.example.com/service-error")
      .with(
        headers: {
          "Accept" => "application/json",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
        }
      )
      .to_return(status: 500, body: "", headers: {})

    WebMock.stub_request(:get, "http://eresource-manager.example.com/service-fail")
      .with(
        headers: {
          "Accept" => "application/json",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
        }
      )
      .to_raise(StandardError)

    WebMock.stub_request(:get, /solr:8983/)
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
        }
      )
      .to_return(status: 200, body: "", headers: {})

    success_auth_mock = IO.read("spec/files/auth/user_reg_success.json")

    WebMock.stub_request(:post, /auth-test.nla.gov.au\/authenticate/)
      .with(
        body: "{\"barcode\":\"bltest\",\"lastName\":\"test\"}",
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Content-Type" => "application/json"
        }
      )
      .to_return(status: 200, body: success_auth_mock, headers: {})

    cat_search_mock = IO.read("spec/files/bento_search/cat_search.json")

    WebMock.stub_request(:get, /test.host\/catalog.json/)
      .with(
        headers: {
          "Accept" => "application/json"
        }
      )
      .to_return(status: 200, body: cat_search_mock, headers: {"Content-Type" => "application/json"})

    fa_search_mock = IO.read("spec/files/bento_search/fa_search.json")

    WebMock.stub_request(:get, /test.host\/finding-aids\/catalog.json/)
      .with(
        headers: {
          "Accept" => "application/json"
        }
      )
      .to_return(status: 200, body: fa_search_mock, headers: {"Content-Type" => "application/json"})

    WebMock.stub_request(:get, /test.nla.gov.au\/catalogue-message\/(1|1234)/)
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
        }
      )
      .to_return(status: 200, body: "", headers: {"Content-Type" => "application/json"})

    WebMock.stub_request(:get, /https:\/\/bookshop.nla.gov.au\/api\/jsonDetails.do?/)
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
        }
      )
      .to_return(status: 200, body: "", headers: {})

    fa_search = IO.read("spec/files/bento_search/fa_search.json")

    WebMock.stub_request(:get, "http://test.host/finding-aids/catalog.json?per_page=5&q=hydrogen")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
        }
      )
      .to_return(status: 200, body: fa_search, headers: {})

    eds_auth_mock = IO.read("spec/files/bento_search/ebsco/uidauth.json")

    WebMock.stub_request(:post, /eds-api.ebscohost.com\/authservice\/rest\/uidauth/)
      .with(
        headers: {
          "Accept" => "application/json",
          "X-Authenticationtoken" => "",
          "X-Sessiontoken" => ""
        }
      )
      .to_return(status: 200, body: eds_auth_mock, headers: {"Content-Type" => "application/json"})

    eds_session_mock = IO.read("spec/files/bento_search/ebsco/session.json")

    WebMock.stub_request(:get, /eds-api.ebscohost.com\/edsapi\/rest\/CreateSession\?displaydatabasename=y&guest=n&profile=edsapi/)
      .with(
        headers: {
          "Accept" => "application/json",
          "X-Authenticationtoken" => "AGPGzYCzk-NO9_ueZr4gxTl-MP2cQWQ1zUR7IkN1c3RvbWVySWQiOiJzODQyMzUxNiIsIkdyb3VwSWQiOiJtYWluIn0",
          "X-Sessiontoken" => "17e7115f-5c8a-495b-98bc-61f5c330d71a.+D51EefNZ/p2kEbaEIqJRQ=="
        }
      )
      .to_return(status: 200, body: eds_session_mock, headers: {"Content-Type" => "application/json"})

    WebMock.stub_request(:get, /eds-api.ebscohost.com\/edsapi\/rest\/CreateSession\?displaydatabasename=y&guest=n&profile=edsapi/)
      .with(
        headers: {
          "Accept" => "application/json",
          "X-Authenticationtoken" => "AGPGzYCzk-NO9_ueZr4gxTl-MP2cQWQ1zUR7IkN1c3RvbWVySWQiOiJzODQyMzUxNiIsIkdyb3VwSWQiOiJtYWluIn0",
          "X-Sessiontoken" => ""
        }
      )
      .to_return(status: 200, body: eds_session_mock, headers: {"Content-Type" => "application/json"})

    eds_info_mock = IO.read("spec/files/bento_search/ebsco/info.json")

    WebMock.stub_request(:get, /eds-api.ebscohost.com\/edsapi\/rest\/Info/)
      .with(
        headers: {
          "Accept" => "application/json",
          "X-Authenticationtoken" => "AGPGzYCzk-NO9_ueZr4gxTl-MP2cQWQ1zUR7IkN1c3RvbWVySWQiOiJzODQyMzUxNiIsIkdyb3VwSWQiOiJtYWluIn0",
          "X-Sessiontoken" => "17e7115f-5c8a-495b-98bc-61f5c330d71a.+D51EefNZ/p2kEbaEIqJRQ=="
        }
      )
      .to_return(status: 200, body: eds_info_mock, headers: {"Content-Type" => "application/json"})

    eds_search_mock = IO.read("spec/files/bento_search/ebsco/search.json")

    WebMock.stub_request(:post, /eds-api.ebscohost.com\/edsapi\/rest\/Search/)
      .with(
        body: "{\"SearchCriteria\":{\"Queries\":[{\"Term\":\"hydrogen\"}],\"SearchMode\":\"bool\",\"IncludeFacets\":\"n\",\"FacetFilters\":[],\"Limiters\":[{\"Id\":\"FT1\",\"Values\":[\"y\"]}],\"Sort\":\"relevance\",\"PublicationId\":null,\"RelatedContent\":[\"emp\"],\"AutoSuggest\":\"n\",\"Expanders\":[\"fulltext\"],\"AutoCorrect\":\"n\"},\"RetrievalCriteria\":{\"View\":\"brief\",\"ResultsPerPage\":3,\"PageNumber\":1,\"Highlight\":false,\"IncludeImageQuickView\":false},\"Actions\":[\"GoToPage(1)\"],\"Comment\":\"\"}",
        headers: {
          "Accept" => "application/json",
          "X-Authenticationtoken" => "AGPGzYCzk-NO9_ueZr4gxTl-MP2cQWQ1zUR7IkN1c3RvbWVySWQiOiJzODQyMzUxNiIsIkdyb3VwSWQiOiJtYWluIn0",
          "X-Sessiontoken" => "17e7115f-5c8a-495b-98bc-61f5c330d71a.+D51EefNZ/p2kEbaEIqJRQ=="
        }
      )
      .to_return(status: 200, body: eds_search_mock, headers: {"Content-Type" => "application/json"})

    eds_search_title_mock = IO.read("spec/files/bento_search/ebsco/search_title.json")

    WebMock.stub_request(:post, /eds-api.ebscohost.com\/edsapi\/rest\/Search/)
      .with(
        body: "{\"SearchCriteria\":{\"Queries\":[{\"FieldCode\":\"TI\",\"Term\":\"hydrogen\"}],\"SearchMode\":\"bool\",\"IncludeFacets\":\"n\",\"FacetFilters\":[],\"Limiters\":[{\"Id\":\"FT1\",\"Values\":[\"y\"]}],\"Sort\":\"relevance\",\"PublicationId\":null,\"RelatedContent\":[\"emp\"],\"AutoSuggest\":\"n\",\"Expanders\":[\"fulltext\"],\"AutoCorrect\":\"n\"},\"RetrievalCriteria\":{\"View\":\"brief\",\"ResultsPerPage\":3,\"PageNumber\":1,\"Highlight\":false,\"IncludeImageQuickView\":false},\"Actions\":[\"GoToPage(1)\"],\"Comment\":\"\"}",
        headers: {
          "Accept" => "application/json",
          "X-Authenticationtoken" => "AGPGzYCzk-NO9_ueZr4gxTl-MP2cQWQ1zUR7IkN1c3RvbWVySWQiOiJzODQyMzUxNiIsIkdyb3VwSWQiOiJtYWluIn0",
          "X-Sessiontoken" => "17e7115f-5c8a-495b-98bc-61f5c330d71a.+D51EefNZ/p2kEbaEIqJRQ=="
        }
      )
      .to_return(status: 200, body: eds_search_title_mock, headers: {"Content-Type" => "application/json"})

    site_info = IO.read("spec/files/catalogue_services/site_info.json")

    WebMock.stub_request(:get, "http://auth.test/auth/realms/example-realm/.well-known/openid-configuration")
      .to_return(status: 200, body: site_info, headers: {})

    token_response = IO.read("spec/files/catalogue_services/token_response.json")

    WebMock.stub_request(:post, "https://auth.test/auth/realms/example-realm/protocol/openid-connect/token")
      .with(
        body: {"grant_type" => "client_credentials"},
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Content-Type" => "application/x-www-form-urlencoded"
        }
      )
      .to_return(status: 200, body: token_response, headers: {"Content-Type" => "application/json"})

    holdings_response = IO.read("spec/files/catalogue_services/serial.json")

    WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/instance\/(.*)/)
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
        }
      )
      .to_return(status: 200, body: holdings_response, headers: {"Content-Type" => "application/json"})

    create_request_response = IO.read("spec/files/catalogue_services/create_request_response.json")

    WebMock.stub_request(:post, /catservices.test\/catalogue-services\/folio\/request\/new/)
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
        }
      )
      .to_return(status: 200, body: create_request_response, headers: {})

    WebMock.stub_request(:get, /thumbservices.test\/thumbnail-service\/thumbnail\/url/)
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
        }
      )
      .to_return(status: 404, body: "", headers: {})

    request_summary = IO.read("spec/files/account/request_summary.json")

    WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/user\/.*\/myRequests/)
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
        }
      )
      .to_return(status: 200, body: request_summary, headers: {})

    WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/user\/(.*)\/requestLimitReached/)
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
        }
      )
      .to_return(status: 200, body: "{\"requestLimitReached\": \"false\"}", headers: {})

    WebMock.stub_request(:post, /catservices.test\/catalogue-services\/log\/message/)
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Content-Type" => "application/json"
        }
      )
      .to_return(status: 200, body: "", headers: {})

    request_details = IO.read("spec/files/account/single_request.json")

    WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/request\/(.*)\?loan=(.*)/)
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "User-Agent" => "nla-blacklight/2.9.0"
        }
      )
      .to_return(status: 200, body: request_details, headers: {})
  end
end
