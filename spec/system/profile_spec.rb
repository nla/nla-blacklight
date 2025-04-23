require "system_helper"

RSpec.describe "Profile" do
  before do
    sign_in create(:user, :patron, name_given: "Blacklight", name_family: "Test")
  end

  context "when patron has mobile and landline phone numbers" do
    before do
      user_details = IO.read("spec/files/profile/user_details.json")
      WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/user/)
        .to_return(status: 200, body: user_details, headers: {"Content-Type" => "application/json"})
    end

    it "displays both phone numbers" do
      visit account_profile_url

      expect(page).to have_content("0412345678")
      expect(page).to have_content("0398765432")
    end

    describe "deleting a phone number" do
      before do
        WebMock.stub_request(:post, /catservices.test\/catalogue-services\/folio\/user\/updateDetails/)
          .to_return(body: '{"status":"OK"}')
      end

      it "deletes a single phone number without error" do
        visit account_profile_url

        click_on "Change my phone number"

        expect(page).to have_content("Update your phone number")
        expect(page).to have_content("Current phone number")
        expect(page).to have_content("0398765432")

        fill_in "user_details[phone]", with: ""

        click_on "Update"

        expect(page).to have_no_content(I18n.t("account.settings.update.errors.any_phone"))

        # validate page has redirected back to profile page
        expect(page).to have_content("Your Profile")
      end
    end
  end
end
