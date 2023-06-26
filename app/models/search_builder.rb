# frozen_string_literal: true

class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightRangeLimit::RangeLimitBuilder

  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  self.default_processor_chain += [:add_custom_data_to_query, :add_advanced_parse_q_to_solr, :add_advanced_search_to_solr]

  ##
  # @example Adding a new step to the processor chain
  #   self.default_processor_chain += [:add_custom_data_to_query]
  #
  #   def add_custom_data_to_query(solr_parameters)
  #     solr_parameters[:custom] = blacklight_params[:user_value]
  #   end

  # BLAC-326 Modify the query to add exactish title query and boost exactish title matches.
  def add_custom_data_to_query(solr_parameters)
    return if blacklight_params["action"] == "citation"

    if solr_parameters.key?("add_boost_query")
      if solr_parameters["add_boost_query"] && solr_parameters["qf"] && solr_parameters["q"] && solr_parameters["q"].present?
        blacklight_params["search_type"] = "simple"
        return if blacklight_params["search_field"] != "all_fields" && blacklight_params["search_field"] != "title"
        query = solr_parameters["q"].gsub(/["\\]/, "")
        solr_parameters["bq"] = "anchored_title_tsi:\"FINLLFIIJQ " + query +
          " AICULEDSSUL\"^600 OR anchored_title_only_tsi:\"FINLLFIIJQ " +
          query + " AICULEDSSUL\"^500 OR anchored_title_no_format_tsi:\"FINLLFIIJQ " + query +
          " AICULEDSSUL\"^500 OR left_anchored_title_tsi:\"FINLLFIIJQ " + query + "\"^800"
      end
    end
  end
end
