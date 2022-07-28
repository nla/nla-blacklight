ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require 'bootsnap'
env = ENV["RAILS_ENV"] || "development"
cache_path = ENV["BLACKLIGHT_TMP_PATH"] || "tmp/cache"
Bootsnap.setup(
  cache_dir:            cache_path,          # Path to your cache
  development_mode:     env == 'development', # Current working environment, e.g. RACK_ENV, RAILS_ENV, etc
  load_path_cache:      true,                 # Optimize the LOAD_PATH with a cache
  compile_cache_iseq:   false,                 # Compile Ruby code into ISeq cache, breaks coverage reporting.
  compile_cache_yaml:   true                  # Compile YAML into a cache
)
