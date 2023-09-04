Rails.application.routes.draw do
  mount Yabeda::Prometheus::Exporter => "/metrics"

  root "rails/welcome#index"
end
