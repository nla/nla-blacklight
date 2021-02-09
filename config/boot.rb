ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)
require 'bundler/setup' # Set up gems listed in the Gemfile.

##
# Missing environment variable error handler
ENV_MISSING_MESSAGE = 'Startup aborted: Need to set %s environment variable'
def set_environment_variable(env_var_name)
  abort(ENV_MISSING_MESSAGE % env_var_name) unless ENV[env_var_name]
  ENV[env_var_name]
end

BL_TMP_PATH          = set_environment_variable('BLACKLIGHT_TMP_PATH')          # Enable moving writable tmp directory outside of deploy dirs
BL_STORAGE_PATH      = set_environment_variable('BLACKLIGHT_STORAGE_PATH')      # Enable setting active storage path
BL_SOLR_URL          = set_environment_variable('BLACKLIGHT_SOLR_URL')          # Solr url
BL_IMAGE_SERVICE_URL = set_environment_variable('BLACKLIGHT_IMAGE_SERVICE_URL') # Image and thumbnail service url

require 'bootsnap' # Speed up boot time by caching expensive operations.
env = ENV['RAILS_ENV'] || 'development'
Bootsnap.setup(
  cache_dir:            File.join(BL_TMP_PATH,'bootsnap/cache'),    # Path to your cache
  development_mode:     env == 'development',                              # Current working environment, e.g. RACK_ENV, RAILS_ENV, etc
  load_path_cache:      true,                                              # Optimize the LOAD_PATH with a cache
  autoload_paths_cache: true,                                              # Optimize ActiveSupport autoloads with cache
  compile_cache_iseq:   true,                                              # Compile Ruby code into ISeq cache, breaks coverage reporting.
  compile_cache_yaml:   true                                               # Compile YAML into a cache
)