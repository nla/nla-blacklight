# frozen_string_literal: true

require "rails_helper"

RSpec.describe RequestTableRowComponent, type: :component do
  before do
    record_result = IO.read("spec/files/account/record_search.json")
    WebMock.stub_request(:get, /solr:8983/)
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
        }
      )
      .to_return(status: 200, body: record_result, headers: {})
  end

  it "renders the table row" do
    render_inline(described_class.new(request_data))

    expect(page).to have_css("td", count: 4)
  end

  it "renders the title" do
    render_inline(described_class.new(request_data))

    expect(page).to have_link(href: "/catalog/8564488", text: "The Mad Max movies / Adrian Martin. / N N 791.43720994 M379 / pbk")
  end

  it "renders the pick up location" do
    render_inline(described_class.new(request_data))

    expect(page).to have_css("td", text: "Main Reading Room")
  end

  it "renders the comments" do
    render_inline(described_class.new(request_data))

    expect(page).to have_css("td", text: "Testing patron comments")
  end

  it "renders the request date" do
    render_inline(described_class.new(request_data))

    expect(page).to have_css("td", text: "2023-06-2018:36:33")
  end

  def request_data
    data = IO.read("spec/files/account/single_request.json")
    {request: JSON.parse(data)}
  end
end
