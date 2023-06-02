# frozen_string_literal: true

require "benchmark"

class SearchController < ApplicationController
  include BentoQueryConcern

  before_action :search_params

  def index
    q = search_params[:q]
    if q.present?
      @query = q
    end
  end

  def single_search
    @engine = search_params["engine"]

    @query = search_params["q"]

    set_per_page
    @per_page = case @engine
    when "catalogue"
      @cat_per_page
    when "finding_aids"
      @fa_per_page
    else
      @eds_per_page
    end

    @results = {}

    Benchmark.bm do |x|
      x.report(@engine) { @results[@engine] = BentoSearch.get_engine(@engine.to_sym).search(@query, per_page: @per_page) }
    end

    @total_results = @results[@engine].total_items.nil? ? 0 : @results[@engine].total_items
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
