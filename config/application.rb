require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load dotenv only in development or test environment
if %w[development test].include? ENV["RAILS_ENV"]
  Dotenv::Railtie.load
end

if %w[development staging production].include? ENV["RAILS_ENV"]
  # Silence deprecation warnings in staging/production
  require "deprecation"
  Deprecation.default_deprecation_behavior = :silence
end

module NlaBlacklight
  VERSION = "2.5.0"

  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # customise the error pages
    config.exceptions_app = routes

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.autoload_paths << "#{Rails.root}/app/components"
    config.time_zone = "Canberra"

    config.assets.configure do |env|
      env.cache = ActiveSupport::Cache.lookup_store(:file_store, File.join(ENV.fetch("BLACKLIGHT_TMP_PATH", "./tmp"), "asset/cache"))
    end

    # [CVE-2022-32224] Possible RCE escalation bug with Serialized Columns in Active Record
    # https://discuss.rubyonrails.org/t/cve-2022-32224-possible-rce-escalation-bug-with-serialized-columns-in-active-record/81017
    config.active_record.yaml_column_permitted_classes = [ActiveSupport::HashWithIndifferentAccess]

    if %w[staging production].include? ENV["RAILS_ENV"]
      # Use default logging formatter so that PID and timestamp are not suppressed.
      config.log_formatter = ::Logger::Formatter.new
    end

    # print to stdout when deployed to the VM
    if ENV["RAILS_LOG_TO_STDOUT"].present?
      logger = ActiveSupport::Logger.new($stdout)
      logger.formatter = config.log_formatter
      config.logger = ActiveSupport::TaggedLogging.new(logger)
    end

    Prometheus::Client.config.data_store = Prometheus::Client::DataStores::DirectFileStore.new(dir: File.join(ENV.fetch("BLACKLIGHT_TMP_PATH", "./tmp"), "prometheus_direct_file_store"))

    config.version = VERSION
  end
end
