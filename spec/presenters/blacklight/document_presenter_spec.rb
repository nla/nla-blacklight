# frozen_string_literal: true

require "rails_helper"

RSpec.describe Blacklight::DocumentPresenter do
  subject(:presenter) { described_class.new(document, request_context, view_config: blacklight_config.view_config) }

  before do
    Blacklight::Rendering::Pipeline.operations = [
      # from the default pipeline:
      Blacklight::Rendering::HelperMethod,
      Blacklight::Rendering::LinkToFacet,
      Blacklight::Rendering::Microdata,
      # Blacklight::Rendering::Join
      NlaJoin
    ]
  end

  let(:blacklight_config) do
    Blacklight::Configuration.new.configure do |config|
      config.index.title_field = "title_tsim"
      config.show.title_field = "title_tsim"
    end
  end
  let(:document) { SolrDocument.new(id: "123", title_tsim: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam molestie porttitor leo et pellentesque. Maecenas semper interdum ligula sit amet sollicitudin. Pellentesque lacinia libero nisi, et libero."]) }

  describe "#heading" do
    context "when on the search results page" do
      # rubocop:disable RSpec/VerifiedDoubles
      let(:request_context) { double("View context", should_render_field?: true, blacklight_config: blacklight_config, action_name: "index") }
      # rubocop:enable RSpec/VerifiedDoubles

      it "truncates the title" do
        expect(presenter.heading).to eq "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam molestie porttitor leo et pellentesque. Maecenas semper interdum ligula sit amet sollicitudin. Pellentesque..."
      end

      context "when there are multiple titles" do
        let(:document) do
          SolrDocument.new(
            id: "123",
            title_tsim: [
              "Aodaliya nan xin Yinggelan zao shan dai bei hei si ting si di kuai de di zhi bian xing yan hua li shi (ying wen ban) = Unravelling the Deformation History of the Northern Hastings Block Southern New England Orogen / Yan jie",
              "澳大利亚南新英格兰造山带北黑斯廷斯地块的地质变形演化历史（英文版）/ 严杰"
            ]
          )
        end

        it "truncates titles independently" do
          expect(presenter.heading).to eq "Aodaliya nan xin Yinggelan zao shan dai bei hei si ting si di kuai de di zhi bian xing yan hua li shi (ying wen ban) = Unravelling the Deformation History of the Northern...<br>澳大利亚南新英格兰造山带北黑斯廷斯地块的地质变形演化历史（英文版）/ 严杰"
        end
      end
    end

    context "when on the catalogue record page" do
      # rubocop:disable RSpec/VerifiedDoubles
      let(:request_context) { double("View context", should_render_field?: true, blacklight_config: blacklight_config, action_name: "show") }
      # rubocop:enable RSpec/VerifiedDoubles

      it "does not truncate the title" do
        expect(presenter.heading).to eq "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam molestie porttitor leo et pellentesque. Maecenas semper interdum ligula sit amet sollicitudin. Pellentesque lacinia libero nisi, et libero."
      end

      context "when there are multiple titles" do
        let(:document) do
          SolrDocument.new(
            id: "123",
            title_tsim: [
              "Aodaliya nan xin Yinggelan zao shan dai bei hei si ting si di kuai de di zhi bian xing yan hua li shi (ying wen ban) = Unravelling the Deformation History of the Northern Hastings Block Southern New England Orogen / Yan jie",
              "澳大利亚南新英格兰造山带北黑斯廷斯地块的地质变形演化历史（英文版）/ 严杰"
            ]
          )
        end

        it "does not truncate the titles" do
          expect(presenter.heading).to eq "Aodaliya nan xin Yinggelan zao shan dai bei hei si ting si di kuai de di zhi bian xing yan hua li shi (ying wen ban) = Unravelling the Deformation History of the Northern Hastings Block Southern New England Orogen / Yan jie<br>澳大利亚南新英格兰造山带北黑斯廷斯地块的地质变形演化历史（英文版）/ 严杰"
        end
      end
    end
  end

  describe "#html_title" do
    # rubocop:disable RSpec/VerifiedDoubles
    let(:request_context) { double("View context", should_render_field?: true, blacklight_config: blacklight_config, action_name: "index") }
    # rubocop:enable RSpec/VerifiedDoubles

    it "truncates the title" do
      expect(presenter.html_title).to eq "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam molestie porttitor leo et pellentesque...."
    end

    context "when there are multiple titles" do
      let(:document) do
        SolrDocument.new(
          id: "123",
          title_tsim: [
            "Don't stop believin' : Oribia Nyūton Jon jiden : Shinjiru koto o yamenai de / Olivia Newton-John ; Nakagawa Izumi yaku",
            "Don't stop believin' : オリビア・ニュートン・ジョン自伝 :  信じることをやめないで / オリビア・ニュートン・ジョン 著 ; 中川泉 訳"
          ]
        )
      end

      it "displays the first title" do
        expect(presenter.html_title).to eq "Don't stop believin' : Oribia Nyūton Jon jiden : Shinjiru koto o yamenai de / Olivia Newton-John ;..."
      end
    end
  end
end
