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
