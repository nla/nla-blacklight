# frozen_string_literal: true

require "system_helper"

RSpec.describe "Bookmark tools" do
  let(:user) { create(:user, :patron) }

  before do
    response = File.read("spec/files/document_export/search_response.json")
    [:get, :post].each do |method|
      stub_request(method, /solr:8983/).to_return(body: response, headers: {"Content-Type" => "application/json"})
    end
    user.bookmarks.create!(document_id: "1414519", document_type: "SolrDocument")
    sign_in user
  end

  it "refreshes pagination after removal, returns from an emptied page, and shows the empty state" do
    ids = %w[1414519 8425632 4397397]
    ids.drop(1).each { |id| user.bookmarks.create!(document_id: id, document_type: "SolrDocument") }
    fixture = JSON.parse(File.read("spec/files/document_export/search_response.json"))
    document = fixture["response"]["docs"].first
    [:get, :post].each do |method|
      stub_request(method, /solr:8983/).to_return do |request|
        params = Rack::Utils.parse_nested_query([request.uri.query, request.body].compact.join("&"))
        saved_ids = Array(params["fq"]).find { |filter| filter.start_with?("{!terms f=id}") }.to_s.delete_prefix("{!terms f=id}").split(",")
        start = params["start"].to_i
        rows = params["rows"].to_i
        documents = ids.select { |id| saved_ids.include?(id) }.map { |id| document.merge("id" => id) }
        body = fixture.deep_merge("response" => {"numFound" => documents.length, "start" => start, "docs" => documents.slice(start, rows) || []})
        {body: body.to_json, headers: {"Content-Type" => "application/json"}}
      end
    end

    visit bookmarks_path(per_page: 2, page: 2)
    expect(page).to have_css("#documents .document", count: 1)
    find('#documents .bookmark-toggle [data-checkboxsubmit-target="label"]').click

    expect(page).to have_current_path(bookmarks_path(per_page: 2, page: 1))
    expect(page).to have_css("#documents .document", count: 2)
    expect(page).to have_no_link("Next »")
    expect(user.bookmarks.reload.count).to eq(2)

    first('#documents .bookmark-toggle [data-checkboxsubmit-target="label"]').click
    expect(page).to have_css("#documents .document", count: 1)
    expect(page).to have_current_path(bookmarks_path(per_page: 2, page: 1))

    find('#documents .bookmark-toggle [data-checkboxsubmit-target="label"]').click
    expect(page).to have_text(I18n.t("blacklight.bookmarks.no_bookmarks"))
    expect(page).to have_no_css("#documents .document")
    expect(page).to have_no_button("Cite all")
    expect(user.bookmarks.reload).to be_empty
  end

  it "does not refresh or remove the result when bookmark removal fails" do
    visit bookmarks_path
    page.execute_script(<<~JS)
      window.bookmarkPageUnchanged = true;
      window.fetch = () => Promise.resolve(new Response('', {status: 500}));
    JS

    accept_alert("Unable to save the bookmark at this time.") do
      find('#documents .bookmark-toggle [data-checkboxsubmit-target="label"]').click
    end

    expect(page.evaluate_script("window.bookmarkPageUnchanged")).to be(true)
    expect(page).to have_css("#documents .document", count: 1)
    expect(user.bookmarks.reload.count).to eq(1)
  end

  [1200, 375].each do |width|
    it "keeps the citation and export buttons separated at #{width}px" do
      page.current_window.resize_to(width, 800)
      visit bookmarks_path

      expect(page).to have_button("Cite all")
      expect(page).to have_button("Export all")

      rectangles = page.evaluate_script(<<~JS)
        Array.from(document.querySelectorAll('.bookmarks-toolbar .dropdown-toggle')).map(button => {
          const rect = button.getBoundingClientRect();
          return {left: rect.left, right: rect.right, top: rect.top, bottom: rect.bottom};
        })
      JS
      cite, export = rectangles
      expect(cite["right"] + 8 <= export["left"] || cite["bottom"] + 8 <= export["top"]).to be(true)

      click_button "Cite all"
      expect(page).to have_link("APA", visible: :visible)
      click_button "Export all"
      expect(page).to have_link("CSV (.csv)", visible: :visible)
      expect(page).to have_link("RIS (.ris)", visible: :visible)

      click_button "Cite all"
      click_link "APA"
      expect(page).to have_css(".citation-bibliography i, .citation-bibliography em")
      citation = find('[data-clipboard-target="source"]').text
      page.execute_script(<<~JS)
        window.ClipboardItem = class { constructor(data) {this.data = data;} };
        Object.defineProperty(navigator, 'clipboard', {configurable: true, value: {
          write: async items => {
            window.copiedHTML = await items[0].data['text/html'].text();
            window.copiedCitation = await items[0].data['text/plain'].text();
          },
          writeText: async text => {window.plainTextFallback = text;}
        }});
      JS
      click_button "Copy all"
      expect(page).to have_button("Copied")
      expect(page.evaluate_script("window.copiedCitation")).to eq(citation)
      expect(page.evaluate_script("window.copiedHTML")).to match(/<(i|em)>/)
      expect(page.evaluate_script("window.copiedCitation")).not_to include("<i>", "<em>")

      page.execute_script("navigator.clipboard.write = () => Promise.reject(new Error('Not supported'))")
      click_button "Copied"
      expect(page.evaluate_script("window.plainTextFallback")).to eq(citation)

      page.execute_script("navigator.clipboard.write = undefined; window.plainTextFallback = null")
      click_button "Copied"
      expect(page.evaluate_script("window.plainTextFallback")).to eq(citation)
    end
  end
end
