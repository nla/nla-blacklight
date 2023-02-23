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
  end
end
