ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

# Enable moving writable tmp directory outside of deploy dirs
bl_tmp_dir = ENV['BLACKLIGHT_TMP_DIR'] || "/apps/data/blacklight"

# require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
 require 'bootsnap'
 env = ENV['RAILS_ENV'] || "development"
 Bootsnap.setup(
   cache_dir:            File.join(bl_tmp_dir,'bootsnap/cache'),    # Path to your cache
   development_mode:     env == 'development',                      # Current working environment, e.g. RACK_ENV, RAILS_ENV, etc
   load_path_cache:      true,                                      # Optimize the LOAD_PATH with a cache
   autoload_paths_cache: true,                                      # Optimize ActiveSupport autoloads with cache
   compile_cache_iseq:   true,                                      # Compile Ruby code into ISeq cache, breaks coverage reporting.
   compile_cache_yaml:   true                                       # Compile YAML into a cache
)