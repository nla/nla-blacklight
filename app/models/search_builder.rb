# frozen_string_literal: true

class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightRangeLimit::RangeLimitBuilder

  self.default_processor_chain += [:handle_empty_advanced_search]

  ##
  # Handle empty advanced searches to return all results (match BL8 behavior).
  #
  # In BL9's native advanced search, when all clause fields are empty:
  # - add_adv_search_clauses sets defType='lucene' because clause_params is present
  # - But no actual query is added because all clause[:query] values are blank
  # - This results in zero results from Solr
  #
  # This method detects that condition and adds a match-all query (*:*) to restore
  # the expected behavior where empty advanced search returns all results.
  def handle_empty_advanced_search(solr_parameters)
    # Only apply when advanced search clause params are present
    return unless search_state.clause_params.present?

    # Check if all clause queries are empty
    all_clauses_empty = search_state.clause_params.values.all? do |clause|
      clause[:query].blank?
    end

    return unless all_clauses_empty

    # If defType is lucene (set by add_adv_search_clauses) but no query was added,
    # add a match-all query to get results
    if solr_parameters[:defType] == "lucene" &&
        solr_parameters[:q].blank? &&
        solr_parameters.dig(:json, :query).blank?
      solr_parameters[:q] = "*:*"
    end
  end
end
