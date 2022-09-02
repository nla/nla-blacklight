require "rails_helper"

RSpec.describe "External request" do
  it "queries FactoryBot contributors on GitHub" do
    stub_request(:get, "https://api.github.com/repos/thoughtbot/factory_bot/contributors")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Host" => "api.github.com",
          "User-Agent" => "Ruby"
        }
      )
      .to_return(status: 200, body: "", headers: {})

    uri = URI("https://api.github.com/repos/thoughtbot/factory_bot/contributors")

    response = Net::HTTP.get(uri)

    expect(response).to be_an_instance_of(String)
  end
end
