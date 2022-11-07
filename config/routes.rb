Rails.application.routes.draw do
  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new
  mount Blacklight::Engine => "/"
  mount BlacklightAdvancedSearch::Engine => "/"

  concern :marc_viewable, Blacklight::Marc::Routes::MarcViewable.new
  root to: "catalog#index"
  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: "catalog", path: "/catalog", controller: "catalog" do
    concerns :searchable
    concerns :range_searchable
  end
  # devise_scope :user do
  #   delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  # end
  devise_for :users, controllers: {
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  concern :exportable, Blacklight::Routes::Exportable.new

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
end
