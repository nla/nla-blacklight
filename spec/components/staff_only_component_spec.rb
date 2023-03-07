require "rails_helper"

RSpec.describe StaffOnlyComponent, type: :component do
  let(:document) { SolrDocument.new(marc_ss: sample_marc) }
  let(:view_context) { controller.view_context }
  let(:field_config) { Blacklight::Configuration::Field.new(key: "rights_information", label: "Rights information", accessor: :rights_information, helper_method: :url_list, component: described_class) }
  let(:field) do
    Blacklight::FieldPresenter.new(view_context, document, field_config)
  end

  describe "#render?" do
    context "when request is from onsite IP" do
      before do
        request.env["REMOTE_ADDR"] = "200.2.40.0"
      end

      it "returns true" do
        render_inline(described_class.new(field: field, show: true))

        expect(page.text).to include "Rights information"

        expect(page.text).to include "View in Sprightly"
      end
    end

    context "when request is from external IP" do
      before do
        request.env["REMOTE_ADDR"] = "127.0.0.1"
      end

      it "returns false" do
        render_inline(described_class.new(field: field, show: true))

        expect(page.text).to eq ""
      end
    end
  end

  def sample_marc
    load_marc_from_file 1990
  end
end
