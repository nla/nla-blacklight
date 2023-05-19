Rails.application.routes.draw do
  get "request/new"
  get "request/create"
  get "request/show"
  mount Blacklight::Engine => "/"
  mount BlacklightAdvancedSearch::Engine => "/"
  mount Flipper::UI.app(Flipper) => "/feats", :constraints => StaffOnlyConstraint.new

  concern :exportable, Blacklight::Routes::Exportable.new
  concern :searchable, Blacklight::Routes::Searchable.new
  concern :marc_viewable, Blacklight::Marc::Routes::MarcViewable.new
  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new

  concern :offsite do
    get ":id/offsite", action: "offsite", as: "offsite"
  end

  resource :catalog, only: [:index], as: "catalog", path: "/catalog", controller: "catalog" do
    concerns :searchable
    concerns :range_searchable
    concerns :offsite
  end

  resources :solr_documents, only: [:show], path: "/catalog", controller: "catalog" do
    concerns [:exportable, :marc_viewable]

    resources :requests, only: [:new, :create, :show], path: "/requests", controller: "request"
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete "clear"
    end
  end

  # bento search
  get "/search", to: "search#index", as: "bento_search_index"

  # error handlers
  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unprocessable"
  get "/500", to: "errors#internal_server"
  get "/503", to: "errors#unavailable"

  root to: "static_pages#home"
end
