require 'parsing_nesting/tree'
module BlacklightAdvancedSearch::ParsingNestingParser
  def process_query(_params, config)
    queries = keyword_queries.map do |field, query|

      param_hash = local_param_hash(field, config)

      # BLAC-326 add boosts to the anchored title index fields
      add_anchored_title_boosts(param_hash)

      ParsingNesting::Tree.parse(query, config.advanced_search[:query_parser]).to_query(param_hash)
    end
    queries.join(" #{keyword_op} ")
  end

  # BLAC-326 add boosts to the anchored title index fields
  def add_anchored_title_boosts(param_hash)
    if param_hash.key?(:add_boost_query) && param_hash[:add_boost_query] && param_hash.key?(:qf) && param_hash[:qf].present?
      param_hash[:qf] = param_hash[:qf] << " anchored_title_tsi^600 anchored_title_only_tsi^500"
      param_hash.delete(:add_boost_query)
    end
  end

  def local_param_hash(key, config)
    field_def = config.search_fields[key] || {}

    (field_def[:solr_adv_parameters] || field_def[:solr_parameters] || {}).merge(field_def[:solr_local_parameters] || {})
  end
end
