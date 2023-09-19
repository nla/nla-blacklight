# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/NestedGroups
RSpec.describe "Offsite redirect", :request do
  include Devise::Test::IntegrationHelpers
  include ActiveSupport::Testing::TimeHelpers

  before do
    allow(Rails.logger).to receive(:info)
  end

  let(:catalogue_service_mock) { instance_double(CatalogueServicesClient, post_stats: {}) }

  context "when given a 'url' param that does not start with http or https" do
    it "will raise a RuntimeError" do
      expect { get "/catalog/0000/offsite?url=htp://example.com" }.to raise_error(RuntimeError)
    end
  end

  context "when given a 'url' param that starts with http or https" do
    context "when the URL is not an eResource URL" do
      it "will redirect to the catalogue record page" do
        get "/catalog/0000/offsite?url=https://example.com"
        expect(request).to redirect_to(solr_document_path(id: "0000"))
      end
    end

    context "when the URL is a known eResource URL" do
      context "when requested from a local subnet" do
        before do
          # rubocop:disable RSpec/AnyInstance
          allow_any_instance_of(ActionDispatch::Request).to receive(:remote_addr).and_return("187.121.206.121")
          # rubocop:enable RSpec/AnyInstance
        end

        it "redirects to the 'url'" do
          get "/catalog/0000/offsite?url=http://opac.newsbank.com/select/shaw/35846"

          expect(request).to redirect_to("http://opac.newsbank.com/select/shaw/35846")
        end

        it "posts stats" do
          allow(CatalogueServicesClient).to receive(:new).and_return(catalogue_service_mock)

          get "/catalog/0000/offsite?url=http://opac.newsbank.com/select/shaw/35846"

          expect(catalogue_service_mock).to have_received(:post_stats).with(anything).once
        end

        it "logs access" do
          get "/catalog/0000/offsite?url=http://opac.newsbank.com/select/shaw/35846"

          expect(Rails.logger).to have_received(:info).with("eResources local access: http://opac.newsbank.com/select/shaw/35846").once
        end
      end

      context "when requested from a staff subnet" do
        before do
          # rubocop:disable RSpec/AnyInstance
          allow_any_instance_of(ActionDispatch::Request).to receive(:remote_addr).and_return("200.2.40.0")
          # rubocop:enable RSpec/AnyInstance
        end

        it "redirects to the 'url'" do
          get "/catalog/0000/offsite?url=http://opac.newsbank.com/select/shaw/35846"

          expect(request).to redirect_to("http://opac.newsbank.com/select/shaw/35846")
        end

        it "posts stats" do
          allow(CatalogueServicesClient).to receive(:new).and_return(catalogue_service_mock)

          get "/catalog/0000/offsite?url=http://opac.newsbank.com/select/shaw/35846"

          expect(catalogue_service_mock).to have_received(:post_stats).with(anything).once
        end

        it "logs access" do
          get "/catalog/0000/offsite?url=http://opac.newsbank.com/select/shaw/35846"

          expect(Rails.logger).to have_received(:info).with("eResources staff access: http://opac.newsbank.com/select/shaw/35846").once
        end
      end

      context "when requested from offsite" do
        before do
          # rubocop:disable RSpec/AnyInstance
          allow_any_instance_of(ActionDispatch::Request).to receive(:remote_addr).and_return("127.0.0.1")
          # rubocop:enable RSpec/AnyInstance
        end

        context "when eResource does not allow remote access" do
          it "renders the 'onsite_only' template" do
            get "/catalog/0000/offsite?url=http://opac.newsbank.com/select/shaw/35846"
            expect(request).to render_template :onsite_only
          end
        end

        context "when eResource allows remote access" do
          context "when user is logged in" do
            before do
              sign_in user
            end

            let(:user) { create(:user) }

            context "when eResource type is 'ezproxy'" do
              it "redirects to the 'url'" do
                Time.use_zone("Canberra") do
                  travel_to Time.zone.local(2022, 11, 28, 0, 0, 0) do
                    get "/catalog/0000/offsite?url=http://www.macquariedictionary.com.au/login"

                    expect(request).to redirect_to("https://ezproxy.example.com/login?user=user&ticket=60d52eca002749aef4d50486c91c2a6d%24u1669554000&url=http://www.macquariedictionary.com.au/login")
                  end
                end
              end

              it "posts stats" do
                allow(CatalogueServicesClient).to receive(:new).and_return(catalogue_service_mock)

                get "/catalog/0000/offsite?url=http://www.macquariedictionary.com.au/login"

                expect(catalogue_service_mock).to have_received(:post_stats).with(anything).once
              end

              it "logs access" do
                get "/catalog/0000/offsite?url=http://www.macquariedictionary.com.au/login"

                expect(Rails.logger).to have_received(:info).with("eResources external access by user #{user.id}: http://www.macquariedictionary.com.au/login").once
              end
            end
          end

          context "when user is not logged in" do
            context "when eResource title is 'ebsco'" do
              it "redirects to the login page" do
                get "/catalog/0000/offsite?url=http://search.ebscohost.com/login.aspx?direct=true&scope=site&db=nlebk&db=nlabk&AN=658574"
                expect(request).to redirect_to new_user_session_url
              end

              it "displays a flash message" do
                get "/catalog/0000/offsite?url=http://search.ebscohost.com/login.aspx?direct=true&scope=site&db=nlebk&db=nlabk&AN=658574"
                expect(flash[:alert]).to eq "Login to eResources with your National Library card"
              end
            end

            context "when eResource title is not 'ebsco'" do
              it "redirects to the login page" do
                get "/catalog/0000/offsite?url=https://haynesmanualsallaccess.com/en-au/"
                expect(request).to redirect_to new_user_session_url
              end

              it "displays a flash message" do
                get "/catalog/0000/offsite?url=https://haynesmanualsallaccess.com/en-au/"
                expect(flash[:alert]).to eq "To access Haynes manuals allaccess, login with your National Library card details."
              end
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
