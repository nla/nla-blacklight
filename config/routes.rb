# == Route Map
#
#                                   Prefix Verb     URI Pattern                                          Controller#Action
#                      email2fa_alert_show GET      /email2fa_alert/show(.:format)                       email2fa_alert#show
#                   email2fa_alert_dismiss GET      /email2fa_alert/dismiss(.:format)                    email2fa_alert#dismiss
#                               blacklight          /                                                    Blacklight::Engine
#        blacklight_advanced_search_engine          /                                                    BlacklightAdvancedSearch::Engine
#               yabeda_prometheus_exporter          /metrics                                             Yabeda::Prometheus::Exporter
#                           search_catalog GET|POST /catalog(.:format)                                   catalog#index
#                  advanced_search_catalog GET      /catalog/advanced(.:format)                          catalog#advanced_search
#                       page_links_catalog GET      /catalog/page_links(.:format)                        catalog#page_links
#                            track_catalog POST     /catalog/:id/track(.:format)                         catalog#track
#                              raw_catalog GET      /catalog/:id/raw(.:format)                           catalog#raw {:format=>"json"}
#                       opensearch_catalog GET      /catalog/opensearch(.:format)                        catalog#opensearch
#                    suggest_index_catalog GET      /catalog/suggest(.:format)                           catalog#suggest
#                            facet_catalog GET      /catalog/facet/:id(.:format)                         catalog#facet
#                      range_limit_catalog GET      /catalog/range_limit(.:format)                       catalog#range_limit
#                                          GET      /catalog/range_limit_panel/:id(.:format)             catalog#range_limit_panel
#                          offsite_catalog GET      /catalog/:id/offsite(.:format)                       catalog#offsite
#                      email_solr_document GET|POST /catalog/:id/email(.:format)                         catalog#email
#                        sms_solr_document GET|POST /catalog/:id/sms(.:format)                           catalog#sms
#                   citation_solr_document GET      /catalog/:id/citation(.:format)                      catalog#citation
#                     email_solr_documents GET|POST /catalog/email(.:format)                             catalog#email
#                       sms_solr_documents GET|POST /catalog/sms(.:format)                               catalog#sms
#                  citation_solr_documents GET      /catalog/citation(.:format)                          catalog#citation
#             librarian_view_solr_document GET      /catalog/:id/librarian_view(.:format)                catalog#librarian_view
#                    solr_document_request GET      /catalog/:solr_document_id/request(.:format)         request#index
#                                          POST     /catalog/:solr_document_id/request(.:format)         request#create
#                solr_document_request_new GET      /catalog/:solr_document_id/request/new(.:format)     request#new
#            solr_document_request_success GET      /catalog/:solr_document_id/request/success(.:format) request#success
#                            solr_document GET      /catalog/:id(.:format)                               catalog#show
#                           email_bookmark GET|POST /bookmarks/:id/email(.:format)                       bookmarks#email
#                             sms_bookmark GET|POST /bookmarks/:id/sms(.:format)                         bookmarks#sms
#                        citation_bookmark GET      /bookmarks/:id/citation(.:format)                    bookmarks#citation
#                          email_bookmarks GET|POST /bookmarks/email(.:format)                           bookmarks#email
#                            sms_bookmarks GET|POST /bookmarks/sms(.:format)                             bookmarks#sms
#                       citation_bookmarks GET      /bookmarks/citation(.:format)                        bookmarks#citation
#                          clear_bookmarks DELETE   /bookmarks/clear(.:format)                           bookmarks#clear
#                                bookmarks GET      /bookmarks(.:format)                                 bookmarks#index
#                                          POST     /bookmarks(.:format)                                 bookmarks#create
#                             new_bookmark GET      /bookmarks/new(.:format)                             bookmarks#new
#                            edit_bookmark GET      /bookmarks/:id/edit(.:format)                        bookmarks#edit
#                                 bookmark GET      /bookmarks/:id(.:format)                             bookmarks#show
#                                          PATCH    /bookmarks/:id(.:format)                             bookmarks#update
#                                          PUT      /bookmarks/:id(.:format)                             bookmarks#update
#                                          DELETE   /bookmarks/:id(.:format)                             bookmarks#destroy
#                         account_requests GET      /account/requests(.:format)                          account#requests
#                  account_request_details GET      /account/requests/:request_id(.:format)              account#request_details
#                          account_profile GET      /account/profile(.:format)                           account#profile
#                     account_profile_edit GET      /account/profile/edit(.:format)                      account#profile_edit
#                                          POST     /account/profile/edit(.:format)                      account#profile_update
#                         search_thumbnail GET|POST /thumbnail(.:format)                                 thumbnail#index
#                advanced_search_thumbnail GET      /thumbnail/advanced(.:format)                        thumbnail#advanced_search
#                     page_links_thumbnail GET      /thumbnail/page_links(.:format)                      thumbnail#page_links
#                          track_thumbnail POST     /thumbnail/:id/track(.:format)                       thumbnail#track
#                            raw_thumbnail GET      /thumbnail/:id/raw(.:format)                         thumbnail#raw {:format=>"json"}
#                     opensearch_thumbnail GET      /thumbnail/opensearch(.:format)                      thumbnail#opensearch
#                  suggest_index_thumbnail GET      /thumbnail/suggest(.:format)                         thumbnail#suggest
#                          facet_thumbnail GET      /thumbnail/facet/:id(.:format)                       thumbnail#facet
#                    range_limit_thumbnail GET      /thumbnail/range_limit(.:format)                     thumbnail#range_limit
#                                          GET      /thumbnail/range_limit_panel/:id(.:format)           thumbnail#range_limit_panel
#                           show_thumbnail GET      /thumbnail/:id(.:format)                             thumbnail#thumbnail
#                       bento_search_index GET      /search(.:format)                                    search#index
#                      bento_single_search GET      /search/:engine(.:format)                            search#single_search
#                          not_found_error GET      /404(.:format)                                       errors#not_found
#                      unprocessable_error GET      /422(.:format)                                       errors#unprocessable
#                    internal_server_error GET      /500(.:format)                                       errors#internal_server
#                        unavailable_error GET      /503(.:format)                                       errors#unavailable
#                                          GET      /Record/:id(.:format)                                redirect(301, /catalog/%{id})
#                                          GET      /Record/:id/Offsite(.:format)                        redirect(301)
#                                     root GET      /                                                    static_pages#home
# user_catalogue_patron_omniauth_authorize GET|POST /users/auth/catalogue_patron(.:format)               users/omniauth_callbacks#passthru
#  user_catalogue_patron_omniauth_callback GET|POST /users/auth/catalogue_patron/callback(.:format)      users/omniauth_callbacks#catalogue_patron
#    user_catalogue_sol_omniauth_authorize GET|POST /users/auth/catalogue_sol(.:format)                  users/omniauth_callbacks#passthru
#     user_catalogue_sol_omniauth_callback GET|POST /users/auth/catalogue_sol/callback(.:format)         users/omniauth_callbacks#catalogue_sol
#    user_catalogue_spl_omniauth_authorize GET|POST /users/auth/catalogue_spl(.:format)                  users/omniauth_callbacks#passthru
#     user_catalogue_spl_omniauth_callback GET|POST /users/auth/catalogue_spl/callback(.:format)         users/omniauth_callbacks#catalogue_spl
# user_catalogue_shared_omniauth_authorize GET|POST /users/auth/catalogue_shared(.:format)               users/omniauth_callbacks#passthru
#  user_catalogue_shared_omniauth_callback GET|POST /users/auth/catalogue_shared/callback(.:format)      users/omniauth_callbacks#catalogue_shared
#                         new_user_session GET      /sign_in(.:format)                                   users/sessions#new
#                     destroy_user_session DELETE   /sign_out(.:format)                                  users/sessions#destroy
#                                   logout GET      /logout(.:format)                                    users/sessions#destroy
#                  expired_keycloak_logout GET      /expired_keycloak_logout(.:format)                   users/sessions#expired_keycloak_logout
#                       backchannel_logout POST     /backchannel_logout(.:format)                        users/sessions#backchannel_logout
#                         email_2fa_enable GET      /email_2fa/enable(.:format)                          email2fa#enable_email_2fa
#                        email_2fa_disable GET      /email_2fa/disable(.:format)                         email2fa#disable_email_2fa
#                          email_2fa_alert GET      /email_2fa/alert(.:format)                           email_2fa_alert#show
#                  email_2fa_alert_dismiss GET      /email_2fa/alert/dismiss(.:format)                   email_2fa_alert#dismiss
#         turbo_recede_historical_location GET      /recede_historical_location(.:format)                turbo/native/navigation#recede
#         turbo_resume_historical_location GET      /resume_historical_location(.:format)                turbo/native/navigation#resume
#        turbo_refresh_historical_location GET      /refresh_historical_location(.:format)               turbo/native/navigation#refresh
#
# Routes for Blacklight::Engine:
#       search_history GET    /search_history(.:format)       search_history#index
# clear_search_history DELETE /search_history/clear(.:format) search_history#clear
#
# Routes for BlacklightAdvancedSearch::Engine:
# advanced_search GET  /advanced(.:format) catalog#advanced_search

Rails.application.routes.draw do
  mount Blacklight::Engine => "/"
  mount BlacklightAdvancedSearch::Engine => "/"
  mount Yabeda::Prometheus::Exporter => "/metrics"

  concern :exportable, Blacklight::Routes::Exportable.new
  concern :marc_viewable, Blacklight::Marc::Routes::MarcViewable.new
  concern :searchable, Blacklight::Routes::Searchable.new
  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new
  concern :email2fa, Nla::BlacklightCommon::Routes::Email2fa.new

  concern :offsite do
    get ":id/offsite", action: "offsite", as: "offsite"
  end

  concern :requestable do
    get "request", controller: "request", action: "index"
    post "request", controller: "request", action: "create"
    get "request/new", controller: "request", action: "new"
    get "request/success", controller: "request", action: "success"
  end

  resource :catalog, only: [:index], as: "catalog", path: "/catalog", controller: "catalog" do
    concerns :searchable
    concerns :range_searchable

    concerns :offsite
  end

  resources :solr_documents, only: [:show], path: "/catalog", controller: "catalog" do
    concerns :exportable
    concerns :marc_viewable
    concerns :requestable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete "clear"
    end
  end

  scope path: "/account", as: "account" do
    get "/requests", to: "account#requests"
    get "/requests/:request_id", to: "account#request_details", as: "request_details"
    scope path: "/profile", as: "profile" do
      get "/", to: "account#profile"
      get "/edit", to: "account#profile_edit"
      post "/edit", to: "account#profile_update"
    end
  end

  resource :thumbnail, only: [:thumbnail], path: "/thumbnail", controller: "thumbnail" do
    concerns :searchable
    concerns :range_searchable

    get "/:id", to: "thumbnail#thumbnail", as: "show"
  end

  # bento search
  get "/search", to: "search#index", as: "bento_search_index"
  get "/search/:engine", to: "search#single_search", as: "bento_single_search"

  # email 2FA
  concerns :email2fa

  # error handlers
  get "/404", to: "errors#not_found", as: "not_found_error", via: :all
  get "/422", to: "errors#unprocessable", as: "unprocessable_error", via: :all
  get "/500", to: "errors#internal_server", as: "internal_server_error", via: :all
  get "/503", to: "errors#unavailable", as: "unavailable_error", via: :all

  # redirect old VuFind URLs
  scope :Record do
    get "/:id", to: redirect("/catalog/%{id}")
    get "/:id/Offsite", to: redirect { |params, request| "/catalog/#{params[:id]}/offsite?#{request.env["QUERY_STRING"]}" }
  end

  root to: "static_pages#home"
end
