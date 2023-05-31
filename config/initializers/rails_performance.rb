if defined?(RailsPerformance)
  RailsPerformance.setup do |config|
    config.redis = Redis::Namespace.new("#{Rails.env}-rails-performance", redis: Redis.new)
    config.duration = 4.hours

    config.debug = false # currently not used>
    config.enabled = true

    config.verify_access_proc = proc { |controller| true }

    config.ignored_endpoints = %w[RailsPerformance::RailsPerformanceController#index RailsPerformance::RailsPerformanceController#summary RailsPerformance::RailsPerformanceController#trace RailsPerformance::RailsPerformanceController#crashes RailsPerformance::RailsPerformanceController#recent]

    config.home_link = "/"
  end
end
