# frozen_string_literal: true

class SearchController < ApplicationController
  include BentoQueryConcern

  def index
    if params["q"].present?
      @query = params["q"]

      if @query.include?('""')
        @query = check_mixed_quoted_query(@query)
      end

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

  def self.transform_query(search_query)
    # Don't do anything for already-quoted queries or single-term queries
    if search_query !~ (/["'].*?["']/) &&
        search_query !~ (/AND|OR|NOT/)

      # create modified query: (+x +y +z) OR "x y z"
      new_query = search_query.split.map { |w| "\"#{w}\"" }.join(" AND ")
      # (have to use double quotes; single returns an incorrect result set from Solr!)
      search_query = "(#{new_query}) OR \"#{search_query}\""
    else
      if (search_query.first == "'") && (search_query.last == "'")
        search_query = search_query.delete("'")
        search_query = "(#{search_query}) OR \"#{search_query}\""
      end
      search_query
    end

    search_query
  end

  def all_items_url(engine_id, query, format)
    if engine_id.start_with? "ebsco_eds_"
      query = query.gsub("&", "%26")
      "https://proxy.library.cornell.edu/login?url=https://discovery.ebsco.com/c/u2yil2/results?q=#{query}"
    else
      # Need to pass pluses through as urlencoded characters in order to preserve
      # the Solr query format.
      path = "/"
      escaped = if format == "all"
        {q: query}.to_param
      else
        {q: query, search_field: "all_fields"}.to_param
      end
      "#{path}?#{escaped}"
    end
  end

  protected

  def check_mixed_quoted_query(query)
    return_array = []
    add_fields_array = []
    if (query.first == '"') && (query.last == '"')
      if query.count('"') > 2
        return_array = parse_quoted_query_string(query)
        return_array.each do |token|
          token = if token.first == '"'
            "+quoted:" + token
          else
            "+" + token
          end

          add_fields_array << token
        end
        return_array = add_fields_array
      else
        return_array << query
      end
      return_array
    else
      clear_array = []
      return_array = parse_quoted_query_string(query)
      return_array.each do |token|
        clear_array << if token.first == '"'
          "+quoted:" + token
        else
          "+" + token
        end
      end
      clear_array
    end
  end

  def parse_quoted_query_string(quoted_array)
    query_array = []
    token_string = ""
    length_counter = 0
    quote_flag = 0
    quoted_array.each_char do |x|
      length_counter += 1
      if (x != '"') && (x != " ")
        token_string += x
      end
      if x == " "
        if quote_flag != 0
          token_string += x
        else
          query_array << token_string
          token_string = ""
        end
      end
      if (x == '"') && (quote_flag == 0)
        if token_string != ""
          query_array << token_string
        end
        token_string = x
        quote_flag = 1
      end
      if (x == '"') && (quote_flag == 1)
        if (token_string != "") && (token_string != '"')
          token_string += x
          query_array << token_string
          token_string = ""
          quote_flag = 0
        end
      end
      if length_counter == quoted_array.size
        query_array << token_string
      end
    end
    clean_array = []
    query_array.each do |toke|
      if toke != ""
        if toke.present?
          clean_array << toke.rstrip
        end
      end
    end
    clean_array
  end
end
