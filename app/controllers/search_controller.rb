# frozen_string_literal: true

require "benchmark"

class SearchController < ApplicationController
  include BentoQueryConcern

  before_action :search_params

  def index
    q = search_params[:q]
    if q.present?
      @query = q

      set_per_page

      @results = {}

      Benchmark.bm do |x|
        x.report("catalogue") { @results["catalogue"] = BentoSearch.get_engine(:catalogue).search(@query, per_page: @cat_per_page) }
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
  end

  def single_search
    engine = search_params["engine"]

    @query = search_params["q"]

    set_per_page
    case engine
    when "catalogue"
      @per_page = @cat_per_page
    when "finding_aids"
      @per_page = @fa_per_page
    else
      @per_page = @eds_per_page
    end

    @results = {}

    Benchmark.bm do |x|
      x.report(engine) { @results[engine] = BentoSearch.get_engine(engine.to_sym).search(@query, per_page: @per_page) }
    end

    @total_results = @results[engine].total_items.nil? ? 0 : @results[engine].total_items
  end

  private

  def set_per_page
    @cat_per_page = search_params["cat_per_page"] || 10
    @eds_per_page = search_params["eds_per_page"] || 3
    @fa_per_page = search_params["fa_per_page"] || 5
  end

  def search_params
    params.permit(:engine, :q, :cat_per_page, :eds_per_page, :fa_per_page)
  end
end
