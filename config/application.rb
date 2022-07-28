require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load dotenv only in development or test environment
if ["development", "test"].include? ENV["RAILS_ENV"]
  Dotenv::Railtie.load
end

module NlaBlacklight
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.assets.configure do |env|
      env.cache = ActiveSupport::Cache.lookup_store(:file_store, File.join(ENV["BLACKLIGHT_TMP_PATH"], "asset/cache"))
    end

    # [CVE-2022-32224] Possible RCE escalation bug with Serialized Columns in Active Record
    # https://discuss.rubyonrails.org/t/cve-2022-32224-possible-rce-escalation-bug-with-serialized-columns-in-active-record/81017
    config.active_record.yaml_column_permitted_classes = [ActiveSupport::HashWithIndifferentAccess]

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end

def isDev
  ENV["RAILS_ENV"] == "development"
end

def isTest
  ENV["RAILS_ENV"] == "test"
end

def isStaging
  ENV["RAILS_ENV"] == "staging"
end

def isProd
  ENV["RAILS_ENV"] == "production"
end
