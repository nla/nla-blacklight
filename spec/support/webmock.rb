require "webmock/rspec"

# Disables HTTP requests, with the exception of requests to localhost
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before do
    eresource_config = IO.read("spec/files/eresources/config.txt")
    WebMock.stub_request(:get, "http://eresource-manager.example.com/")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "User-Agent" => "Down/5.3.1"
        }
      )
      .to_return(status: 200, body: eresource_config, headers: {})

    WebMock.stub_request(:get, "http://eresource-manager.example.com/service-fail")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "User-Agent" => "Down/5.3.1"
        }
      )
      .to_return(status: 500, body: "", headers: {})
  end
end
