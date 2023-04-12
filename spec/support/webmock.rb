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
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "User-Agent" => "nla-blacklight/#{Rails.configuration.version}"
        }
      )
      .to_return(status: 200, body: eresource_config, headers: {})

    WebMock.stub_request(:get, "http://eresource-manager.example.com/service-fail")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "User-Agent" => "nla-blacklight/#{Rails.configuration.version}"
        }
      )
      .to_return(status: 500, body: "", headers: {})

    WebMock.stub_request(:get, /solr:8983/)
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "User-Agent" => "nla-blacklight/#{Rails.configuration.version}"
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
          "Content-Type" => "application/json",
          "User-Agent" => "nla-blacklight/#{Rails.configuration.version}"
        }
      )
      .to_return(status: 200, body: success_auth_mock, headers: {})

    cat_search_mock = IO.read("spec/files/bento_search/cat_search.json")

    WebMock.stub_request(:get, /test.host\/catalog.json\?per_page=10&q=/)
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "User-Agent" => "nla-blacklight/#{Rails.configuration.version}"
        }
      )
      .to_return(status: 200, body: cat_search_mock, headers: {"Content-Type" => "application/json"})

    fa_search_mock = IO.read("spec/files/bento_search/fa_search.json")

    WebMock.stub_request(:get, /test.host\/finding-aids\/catalog.json\?per_page=3&q=/)
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "User-Agent" => "nla-blacklight/#{Rails.configuration.version}"
        }
      )
      .to_return(status: 200, body: fa_search_mock, headers: {"Content-Type" => "application/json"})

    eds_auth_mock = IO.read("spec/files/bento_search/ebsco/uidauth.json")

    WebMock.stub_request(:post, /eds-api.ebscohost.com\/authservice\/rest\/uidauth/)
      .with(
        headers: {
          "Accept" => "application/json",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Connection" => "keep-alive",
          "Content-Type" => "application/json;charset=UTF-8",
          "Keep-Alive" => "30",
          "User-Agent" => "EBSCO EDS GEM v0.0.1",
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
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Connection" => "keep-alive",
          "Content-Type" => "application/json;charset=UTF-8",
          "Keep-Alive" => "30",
          "User-Agent" => "EBSCO EDS GEM v0.0.1",
          "X-Authenticationtoken" => "AGPGzYCzk-NO9_ueZr4gxTl-MP2cQWQ1zUR7IkN1c3RvbWVySWQiOiJzODQyMzUxNiIsIkdyb3VwSWQiOiJtYWluIn0",
          "X-Sessiontoken" => "17e7115f-5c8a-495b-98bc-61f5c330d71a.+D51EefNZ/p2kEbaEIqJRQ=="
        }
      )
      .to_return(status: 200, body: eds_session_mock, headers: {"Content-Type" => "application/json"})

    WebMock.stub_request(:get, /eds-api.ebscohost.com\/edsapi\/rest\/CreateSession\?displaydatabasename=y&guest=n&profile=edsapi/)
      .with(
        headers: {
          "Accept" => "application/json",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Connection" => "keep-alive",
          "Content-Type" => "application/json;charset=UTF-8",
          "Keep-Alive" => "30",
          "User-Agent" => "EBSCO EDS GEM v0.0.1",
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
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Connection" => "keep-alive",
          "Content-Type" => "application/json;charset=UTF-8",
          "Keep-Alive" => "30",
          "User-Agent" => "EBSCO EDS GEM v0.0.1",
          "X-Authenticationtoken" => "AGPGzYCzk-NO9_ueZr4gxTl-MP2cQWQ1zUR7IkN1c3RvbWVySWQiOiJzODQyMzUxNiIsIkdyb3VwSWQiOiJtYWluIn0",
          "X-Sessiontoken" => "17e7115f-5c8a-495b-98bc-61f5c330d71a.+D51EefNZ/p2kEbaEIqJRQ=="
        }
      )
      .to_return(status: 200, body: eds_info_mock, headers: {"Content-Type" => "application/json"})

    eds_search_mock = IO.read("spec/files/bento_search/ebsco/search.json")

    WebMock.stub_request(:post, /eds-api.ebscohost.com\/edsapi\/rest\/Search/)
      .with(
        body: "{\"SearchCriteria\":{\"Queries\":[{\"Term\":\"hydrogen\"}],\"SearchMode\":\"bool\",\"IncludeFacets\":\"y\",\"FacetFilters\":[],\"Limiters\":[],\"Sort\":\"relevance\",\"PublicationId\":null,\"RelatedContent\":[\"emp\"],\"AutoSuggest\":\"y\",\"Expanders\":[\"fulltext\"],\"AutoCorrect\":\"n\"},\"RetrievalCriteria\":{\"View\":\"brief\",\"ResultsPerPage\":3,\"PageNumber\":1,\"Highlight\":null,\"IncludeImageQuickView\":false},\"Actions\":[\"GoToPage(1)\"],\"Comment\":\"\"}",
        headers: {
          "Accept" => "application/json",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Connection" => "keep-alive",
          "Content-Type" => "application/json;charset=UTF-8",
          "Keep-Alive" => "30",
          "User-Agent" => "EBSCO EDS GEM v0.0.1",
          "X-Authenticationtoken" => "AGPGzYCzk-NO9_ueZr4gxTl-MP2cQWQ1zUR7IkN1c3RvbWVySWQiOiJzODQyMzUxNiIsIkdyb3VwSWQiOiJtYWluIn0",
          "X-Sessiontoken" => "17e7115f-5c8a-495b-98bc-61f5c330d71a.+D51EefNZ/p2kEbaEIqJRQ=="
        }
      )
      .to_return(status: 200, body: eds_search_mock, headers: {"Content-Type" => "application/json"})

    eds_search_title_mock = IO.read("spec/files/bento_search/ebsco/search_title.json")

    stub_request(:post, /eds-api.ebscohost.com\/edsapi\/rest\/Search/)
      .with(
        body: "{\"SearchCriteria\":{\"Queries\":[{\"Term\":\"TI hydrogen\"}],\"SearchMode\":\"bool\",\"IncludeFacets\":\"y\",\"FacetFilters\":[],\"Limiters\":[],\"Sort\":\"relevance\",\"PublicationId\":null,\"RelatedContent\":[\"emp\"],\"AutoSuggest\":\"y\",\"Expanders\":[\"fulltext\"],\"AutoCorrect\":\"n\"},\"RetrievalCriteria\":{\"View\":\"brief\",\"ResultsPerPage\":3,\"PageNumber\":1,\"Highlight\":null,\"IncludeImageQuickView\":false},\"Actions\":[\"GoToPage(1)\"],\"Comment\":\"\"}",
        headers: {
          "Accept" => "application/json",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Connection" => "keep-alive",
          "Content-Type" => "application/json;charset=UTF-8",
          "Keep-Alive" => "30",
          "User-Agent" => "EBSCO EDS GEM v0.0.1",
          "X-Authenticationtoken" => "AGPGzYCzk-NO9_ueZr4gxTl-MP2cQWQ1zUR7IkN1c3RvbWVySWQiOiJzODQyMzUxNiIsIkdyb3VwSWQiOiJtYWluIn0",
          "X-Sessiontoken" => "17e7115f-5c8a-495b-98bc-61f5c330d71a.+D51EefNZ/p2kEbaEIqJRQ=="
        }
      )
      .to_return(status: 200, body: eds_search_title_mock, headers: {"Content-Type" => "application/json"})
  end
end
