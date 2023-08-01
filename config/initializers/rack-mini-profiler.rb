require "rack-mini-profiler"

Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore
