require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load dotenv only in development or test environment
if %w[development test].include? ENV["RAILS_ENV"]
  require "dotenv/load"
end

module NlaBlacklight
  VERSION = "4.2.1"

  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # customise the error pages
    config.exceptions_app = routes

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.add_autoload_paths_to_load_path = false

    config.autoload_paths << "#{Rails.root}/app/components"
    config.time_zone = "Canberra"

    config.assets.configure do |env|
      env.cache = ActiveSupport::Cache.lookup_store(:file_store, File.join(ENV.fetch("BLACKLIGHT_TMP_PATH", "./tmp"), "asset/cache"))
    end

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Try to support Internet Explorer
    config.action_dispatch.default_headers = {
      "X-Frame-Options" => "SAMEORIGIN",
      "X-XSS-Protection" => "0",
      "X-Content-Type-Options" => "nosniff",
      "X-Permitted-Cross-Domain-Policies" => "none",
      "X-Download-Options" => "noopen",
      "Referrer-Policy" => "strict-origin-when-cross-origin"
    }

    # Override default format of error messages per model
    config.active_model.i18n_customize_full_message = true
    config.action_view.field_error_proc = proc do |html_tag, instance|
      input_tag = Nokogiri::HTML5::DocumentFragment.parse(html_tag).at_css(".form-control")
      if input_tag
        # rubocop:disable Rails/OutputSafety
        input_tag.add_class("is-invalid").to_s.html_safe
        # rubocop:enable Rails/OutputSafety
      else
        html_tag
      end
    end

    Prometheus::Client.config.data_store = Prometheus::Client::DataStores::DirectFileStore.new(dir: File.join(ENV.fetch("BLACKLIGHT_TMP_PATH", "./tmp"), "prometheus_direct_file_store"))

    config.version = VERSION
  end
end
