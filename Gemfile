source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Brakeman analyzes our code for security vulnerabilities
gem "brakeman"

# bundler-audit checks our dependencies for vulnerabilities
gem "bundler-audit"

# lograge changes Rails' logging to a more
# traditional one-line-per-event format
gem "lograge"

# stores user session in the database rather than the browser cookie
gem "activerecord-session_store", "~> 2.0"

# in Rails scheduler
gem "rufus-scheduler", "~> 3.8"

# catch unsafe migrations
gem "strong_migrations", "~> 1.7"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.4"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use hiredis adapter for better performance than the "redis" gem
gem "hiredis", "~> 0.6.3"
gem "hiredis-client", "~> 0.18.0"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 5.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

gem "yabeda-rails"
gem "yabeda-puma-plugin"
gem "yabeda-prometheus"

gem "derailed_benchmarks", group: :development
gem "stackprof", group: :development

gem "blacklight", ">= 8.0.0", "< 9"
gem "blacklight-marc", "~> 8.0"
gem "blacklight_advanced_search", "8.0.0.alpha2"
gem "ebsco-eds", "~> 1.1", ">= 1.1.5"

gem "email_validator", "~> 2.2"
gem "phonelib", "~> 0.8.4"

gem "nla-blacklight_common", git: "https://github.com/nla/nla-blacklight_common", tag: "0.2.0"
gem "bento_search", git: "https://github.com/nla/bento_search.git", tag: "0.0.1"
gem "blacklight_range_limit", git: "https://github.com/nla/blacklight_range_limit", branch: "main"
# For local development, comment out above ⤴️ and uncomment below ⤵️
# gem "nla-blacklight_common", path: "../nla-blacklight_common"
# # gem "bento_search", path: "../bento_search"
# gem "blacklight_range_limit", path: "../blacklight_range_limit"

group :development, :test do
  # All runtime config comes from the UNIX environment
  # but we use dotenv to store that in files for development and testing
  gem "dotenv"

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "standard", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-performance", require: false
  gem "solr_wrapper", ">= 0.3"

  gem "rspec-rails", "~> 6.0"
  gem "fuubar"
  gem "shoulda-matchers"
  gem "factory_bot_rails"
  gem "faker"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  gem "awesome_print"

  # improve the Rails error console in development
  gem "better_errors"
  gem "binding_of_caller"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  gem "rack-mini-profiler"
  # append ?pp=flamegraph to URL for flamegraphs
  gem "flamegraph"
  # append ?pp=profile-memory to URL
  # append ?pp=profile-gc to report on GC statistics
  # append ?pp=analyze-memory to report on Object statistics
  gem "memory_profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver", "~> 4.17"
  gem "rails-controller-testing", "~> 1.0", ">= 1.0.5"
  gem "webmock"
  gem "cuprite"

  gem "simplecov", "~> 0.22.0"
  gem "simplecov-json", "~> 0.2.3"

  gem "mock_redis", "~> 0.44.0"
end
