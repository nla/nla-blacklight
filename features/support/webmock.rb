require "webmock/cucumber"

# Disables HTTP requests, with the exception of requests to localhost
WebMock.disable_net_connect!(allow_localhost: true)

Before do |_scenario|
  stub_request(:get, /solr:8983/)
    .with(
      headers: {
        "Accept" => "*/*",
        "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
        "User-Agent" => "Faraday v1.10.0"
      }
    )
    .to_return(status: 200, body: "", headers: {})

  stub_request(:post, /\S.nla.gov.au\/getalibrarycard\/authenticate.xml/)
    .with(
      headers: {
        "Accept" => "*/*",
        "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
        "Content-Length" => "0",
        "User-Agent" => "Faraday v1.10.0"
      }
    )
    .to_return(status: 200, body: "", headers: {})

  details_mock = IO.read("features/files/auth/user_details.xml")

  stub_request(:get, /\S.nla.gov.au\/getalibrarycard\/patrons\/details\/([0-9]*).xml/)
    .with(
      headers: {
        "Accept" => "*/*",
        "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
        "User-Agent" => "Faraday v1.10.0"
      }
    )
    .to_return(status: 200, body: details_mock, headers: {})
end
