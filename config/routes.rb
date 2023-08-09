Rails.application.routes.draw do
  mount Blacklight::Engine => "/"
  mount BlacklightAdvancedSearch::Engine => "/"
  mount Flipper::UI.app(Flipper) => "/feats", :constraints => StaffOnlyConstraint.new
  mount Yabeda::Prometheus::Exporter => "/metrics"

  concern :exportable, Blacklight::Routes::Exportable.new
  concern :searchable, Blacklight::Routes::Searchable.new
  concern :marc_viewable, Blacklight::Marc::Routes::MarcViewable.new
  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new

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
    concerns [:exportable, :marc_viewable, :requestable]
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete "clear"
    end
  end

  get "/account/requests", to: "account#requests", as: "account_requests"

  get "/thumbnail/:id", to: "thumbnail#thumbnail", as: "thumbnail"

  # bento search
  get "/search", to: "search#index", as: "bento_search_index"
  get "/search/:engine", to: "search#single_search", as: "bento_single_search"

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
