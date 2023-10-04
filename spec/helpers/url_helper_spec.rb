# frozen_string_literal: true

require "rails_helper"

RSpec.describe UrlHelper do
  let(:blacklight_config) do
    Blacklight::Configuration.new(view_config: {title_field: "title_tsim"})
  end

  describe "#link_to_document" do
    before do
      allow(document_presenter).to receive(:heading).and_return(document.first("title_tsim"))
      allow(helper).to receive(:document_link_params).with(any_args).and_return({})
      allow(helper).to receive(:document_presenter).with(any_args).and_return(document_presenter)
      allow(helper).to receive_messages(blacklight_config: blacklight_config)
    end

    let(:document) { SolrDocument.new(id: "123", title_tsim: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam molestie porttitor leo et pellentesque. Maecenas semper interdum ligula sit amet sollicitudin. Pellentesque lacinia libero nisi, et libero.") }

    context "when on the index page" do
      before do
        allow(helper).to receive(:current_page?).with(search_catalog_path).and_return(true)
      end

      let(:document_presenter) { instance_double(Blacklight::DocumentPresenter) }

      it "truncates the title" do
        expect(helper.link_to_document(document)).to have_content("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam molestie porttitor leo et pellentesque. Maecenas semper interdum ligula sit amet sollicitudin. Pellentesque...")
      end
    end

    context "when on the show page" do
      before do
        allow(helper).to receive(:current_page?).with(search_catalog_path).and_return(false)
      end

      let(:search_state) { instance_double(Blacklight::SearchState) }
      let(:document_presenter) { instance_double(Blacklight::DocumentPresenter) }

      it "does not truncate the title" do
        expect(helper.link_to_document(document)).to have_content("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam molestie porttitor leo et pellentesque. Maecenas semper interdum ligula sit amet sollicitudin. Pellentesque lacinia libero nisi, et libero.")
      end
    end
  end
end
