Rails.application.routes.draw do
  mount Blacklight::Engine => "/"
  mount BlacklightAdvancedSearch::Engine => "/"
  mount Flipper::UI.app(Flipper) => "/feats", :constraints => StaffOnlyConstraint.new
  mount RailsPerformance::Engine => "/monitor", :constraints => StaffOnlyConstraint.new

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

  get "/thumbnail/:id", to: "thumbnail#thumbnail", as: "thumbnail"

  # bento search
  get "/search", to: "search#index", as: "bento_search_index"
  get "/search/:engine", to: "search#single_search", as: "bento_single_search"

  # error handlers
  get "/404", to: "errors#not_found", as: "not_found_error"
  get "/422", to: "errors#unprocessable", as: "unprocessable_error"
  get "/500", to: "errors#internal_server", as: "internal_server_error"
  get "/503", to: "errors#unavailable", as: "unavailable_error"

  root to: "static_pages#home"
end
