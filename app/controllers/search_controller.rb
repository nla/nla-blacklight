# frozen_string_literal: true

class SearchController < ApplicationController
  include BentoQueryConcern

  def index
    if params["q"].present?
      @query = params["q"]

      @cat_per_page = params["cat_per_page"] || 10
      @eds_per_page = params["eds_per_page"] || 3
      @fa_per_page = params["fa_per_page"] || 3

      @results = {}

      engines = [:catalogue, :ebsco_eds_keyword, :ebsco_eds_title, :finding_aids]

      bench = Benchmark.measure {
        futures = engines.collect do |engine_id|
          per_page = case engine_id
          when :catalogue
            @cat_per_page
          when :finding_aids
            @fa_per_page
          when :ebsco_eds_keyword, :ebsco_eds_title
            @eds_per_page
          else
            3
          end

          # Spawn a thread to perform searches concurrently.
          # Threads are taken from the local Concurrent::CachedThreadPool in BentoQueryConcern.
          #
          # ConcurrentRuby suggests that forking and threading should not be mixed:
          # https://github.com/ruby-concurrency/concurrent-ruby/blob/master/docs-source/thread_pools.md#forking
          #
          # Local thread pool is used to avoid issues with Puma if it ever gets switched to
          # using cluster mode (which forks processes) in the future.
          Concurrent::Future.execute(executor: @context[:pool]) do
            Rails.application.executor.wrap {
              searcher = BentoSearch.get_engine(engine_id)
              searcher.search(@query, per_page: per_page)
            }
          end
        end

        # wait here for the threads to resolve
        pairs = ActiveSupport::Dependencies.interlock.permit_concurrent_loads do
          # use `future.value!` to make ConcurrentRuby raise any exceptions
          futures.collect { |future| [future.value!.engine_id, future.value!] }
        end
        @results = pairs.to_h.freeze
      }
      Rails.logger.debug { "Bento parallel search benchmark: #{bench}" }
    end

    @total_results = 0
    @results&.each do |_key, res|
      @total_results += res.total_items
    end

    render "single_search/index"
  end
end
