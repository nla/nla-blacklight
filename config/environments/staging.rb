# Based on production
require Rails.root.join("config", "environments", "production")

Rails.application.configure do
  # Use a real queuing backend for Active Job (and separate queues per environment).
  # config.active_job.queue_adapter     = :resque
  config.active_job.queue_name_prefix = "nla_blacklight_staging"

  # allow requests to
  config.hosts.clear
  config.hosts << "localhost"
  config.hosts << ".nla.gov.au"
end
