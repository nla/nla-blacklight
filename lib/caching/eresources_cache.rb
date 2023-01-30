# frozen_string_literal: true

# This is a singleton instance of a FileStore cache used to retrieve
# and store the eresources.cfg file.
module Caching
  class EresourcesCache
    include Singleton

    def initialize
      @file_store = ActiveSupport::Cache::FileStore.new "#{ENV["BLACKLIGHT_TMP_PATH"]}/cache"
    end

    def method_missing(m, *args, &block)
      @file_store.send(m, *args, &block)
    end

    # :nocov:
    def respond_to_missing?(method_name, include_private = false)
      true
    end
    # :nocov:
  end
end
