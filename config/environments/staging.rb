# Based on production
require Rails.root.join("config", "environments", "production")

Rails.application.configure do
  # Use a real queuing backend for Active Job (and separate queues per environment).
  # config.active_job.queue_adapter     = :resque
  config.active_job.queue_name_prefix = "nla_blacklight_staging"

  # allow requests to
  config.hosts << "delong.nla.gov.au"
  config.hosts << "deshort.nla.gov.au"
  config.hosts << "catalogue-devel.nla.gov.au"
  config.hosts << "catalogue-test.nla.gov.au"
  config.hosts << "blacklight-test.nla.gov.au"
end
