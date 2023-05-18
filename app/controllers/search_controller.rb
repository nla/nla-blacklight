# frozen_string_literal: true

class SearchController < ApplicationController
  include BentoQueryConcern

  def index
    if params["q"].present?
      @query = params["q"]

      @cat_per_page = params["cat_per_page"] || 10
      @eds_per_page = params["eds_per_page"] || 3
      @fa_per_page = params["fa_per_page"] || 10

      @results = {}

      @results["catalogue"] = BentoSearch.get_engine(:catalogue).search(@query, per_page: @cat_per_page)
      @results["finding_aids"] = BentoSearch.get_engine(:finding_aids).search(@query, per_page: @fa_per_page)
    end

    @total_results = 0
    @results&.each do |_key, res|
      @total_results += res.total_items
    end

    render "single_search/index"
  end
end
