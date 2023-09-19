if ENV.fetch("MINIPROFILER_REDIS", "n") == "y"
  Rack::MiniProfiler.config.storage_options = {url: ENV["REDIS_SERVER_URL"]}
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::RedisStore
end
