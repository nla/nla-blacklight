require "rspec"

RSpec.describe BlacklightHelper do
  describe "#application_name" do
    it "defaults to 'Catalogue | National Library of Australia'" do
      expect(application_name).to eq "Catalogue | National Library of Australia"
    end
  end
end
