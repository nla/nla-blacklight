# frozen_string_literal: true

require "benchmark"

class SearchController < ApplicationController
  include BentoQueryConcern

  def index
    if params["q"].present?
      @query = params["q"]

      @cat_per_page = params["cat_per_page"] || 10
      @eds_per_page = params["eds_per_page"] || 3
      @fa_per_page = params["fa_per_page"] || 5

      @results = {}

      Benchmark.bm do |x|
        x.report("catalogue") { @results["catalogue"] = BentoSearch.get_engine(:catalogue).search(@query, per_page: @cat_per_page, search_type: "simple") }
        x.report("ebsco_eds_keyword") { @results["ebsco_eds_keyword"] = BentoSearch.get_engine(:ebsco_eds_keyword).search(@query, per_page: @eds_per_page) }
        x.report("ebsco_eds_title") { @results["ebsco_eds_title"] = BentoSearch.get_engine(:ebsco_eds_title).search(@query, per_page: @eds_per_page, search_field: "TI") }
        x.report("finding_aids") { @results["finding_aids"] = BentoSearch.get_engine(:finding_aids).search(@query, per_page: @fa_per_page) }
      end
    end

    @total_results = 0
    @results&.each do |_key, res|
      # the search engines may return nil if there is an error, so we need to check for that
      @total_results += res.total_items.nil? ? 0 : res.total_items
    end

    render "single_search/index"
  end
end
