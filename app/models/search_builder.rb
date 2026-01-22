# frozen_string_literal: true

class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightRangeLimit::RangeLimitBuilder

  include BlacklightAdvancedSearch::AdvancedSearchBuilder

  self.default_processor_chain += [:add_advanced_parse_q_to_solr, :add_advanced_search_to_solr, :handle_empty_advanced_search]

  ##
  # @example Adding a new step to the processor chain
  #   self.default_processor_chain += [:add_custom_data_to_query]
  #
  #   def add_custom_data_to_query(solr_parameters)
  #     solr_parameters[:custom] = blacklight_params[:user_value]
  #   end

  ##
  # Handles the case where all advanced search clause queries are empty.
  # When the user submits an advanced search form with all empty fields,
  # this adds a match-all query to return results instead of no results.
  #
  # @param [Hash] solr_parameters the Solr query parameters being built
  def handle_empty_advanced_search(solr_parameters)
    return unless advanced_search_with_empty_clauses?

    solr_parameters[:q] = "*:*"
    solr_parameters[:defType] = "lucene"
  end

  private

  ##
  # Determines if this is an advanced search where all clause queries are empty.
  #
  # @return [Boolean] true if advanced search with all empty clauses
  def advanced_search_with_empty_clauses?
    clause_params = blacklight_params[:clause]
    return false if clause_params.blank?

    clause_params.values.all? { |clause| clause[:query].blank? }
  end
end
