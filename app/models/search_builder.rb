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
    if solr_parameters.key?("add_boost_query")
      if solr_parameters["add_boost_query"] && solr_parameters["qf"] && solr_parameters["q"] && solr_parameters["q"].present?
        solr_parameters["qf"] = solr_parameters["qf"] << " anchored_title_tsi^600 anchored_title_only_tsi^500 anchored_title_no_format_tsi^500 left_anchored_title_tsi^800"
        solr_parameters["q"] = solr_parameters["q"] << " OR \"FINLLFIIJQ " + solr_parameters["q"] + " AICULEDSSUL\" OR \"FINLLFIIJQ " + solr_parameters["q"] + "\""
        blacklight_params["search_type"] = "simple"
      end
    end
  end
end
