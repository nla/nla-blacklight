Rails.application.routes.draw do
  mount Blacklight::Engine => "/"
  mount BlacklightAdvancedSearch::Engine => "/"
  mount Flipper::UI.app(Flipper) => "/feats", constraints: StaffOnlyConstraint.new

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
  end

  get "/staff", to: "application#staff_login"

  resources :bookmarks do
    concerns :exportable

    collection do
      delete "clear"
    end
  end

  # error handlers
  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unprocessable"
  get "/500", to: "errors#internal_server"
  get "/503", to: "errors#unavailable"

  root to: "catalog#index"
end
