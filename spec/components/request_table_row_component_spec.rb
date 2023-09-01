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

  context "when there is an instance id" do
    it "renders a linked title" do
      render_inline(described_class.new(request_data))

      expect(page).to have_link(href: "/catalog/8564488", text: "The Mad Max movies / Adrian Martin. / N N 791.43720994 M379 / pbk")
    end
  end

  context "when there is no instance id" do
    it "renders the title" do
      render_inline(described_class.new(request_data_without_instance_id))

      expect(page).not_to have_css("a")
      expect(page).to have_text("National geographic.")
    end
  end

  it "renders the pick up location" do
    render_inline(described_class.new(request_data))

    expect(page).to have_css("td", text: "Main Reading Room")
  end

  it "renders the comments" do
    render_inline(described_class.new(request_data))

    expect(page).to have_css("td", text: "Testing patron comments")
  end

  context "when there is a cancellation reason" do
    it "renders the cancellation reason and the cancellation comments" do
      render_inline(described_class.new(request_data_with_cancellation))

      expect(page).to have_css("td", text: "Testing patron comments")
      expect(page).to have_css("td", text: "We need more detailed information in order to retrieve this item.")
      expect(page).to have_css("td", text: "this is a test cancellation")
    end
  end

  it "renders the request date" do
    render_inline(described_class.new(request_data))

    expect(page).to have_css("td", text: "20 June 2023")
    expect(page).to have_css("small.text-muted", text: "06:36:33pm")
  end

  it "renders the year in the notes column" do
    render_inline(described_class.new(request_data))

    expect(page).to have_css("p", text: "1909")
  end

  it "renders the enumeration in the notes column" do
    render_inline(described_class.new(request_data))

    expect(page).to have_css("p", text: "pbk")
  end

  it "renders the chronology in the notes column" do
    render_inline(described_class.new(request_data))

    expect(page).to have_css("p", text: "June, July")
  end

  def request_data
    data = IO.read("spec/files/account/single_request.json")
    {request: JSON.parse(data)}
  end

  def request_data_with_cancellation
    data = IO.read("spec/files/account/single_request_with_cancellation.json")
    {request: JSON.parse(data)}
  end

  def request_data_without_instance_id
    data = IO.read("spec/files/account/single_request_without_instance_id.json")
    {request: JSON.parse(data)}
  end
end
