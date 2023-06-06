require 'parsing_nesting/tree'
module BlacklightAdvancedSearch::ParsingNestingParser
  def process_query(_params, config)
    title_boost_query_string = ""
    queries = keyword_queries.map do |field, query|

      param_hash = local_param_hash(field, config)

      # BLAC-326 add boosts to the anchored title index fields
      if field == "title"
        add_anchored_title_boosts(param_hash)
        title_boost_query_string = add_title_boost_queries(config, query, param_hash)
      end
      ParsingNesting::Tree.parse(query, config.advanced_search[:query_parser]).to_query(param_hash)
    end

    if title_boost_query_string.empty?
      queries.join(" #{keyword_op} ")
    else
      queries.join(" #{keyword_op} ") + " OR " + title_boost_query_string
    end
  end

  # BLAC-326 add boosts to the anchored title index fields
  def add_title_boost_queries(config, query, param_hash)
    title_boost_query = []
    title_boost_query << ParsingNesting::Tree.parse("\"FINLLFIIJQ " + query + " AICULEDSSUL\"", config.advanced_search[:query_parser]).to_query(param_hash)
    title_boost_query << ParsingNesting::Tree.parse("\"FINLLFIIJQ " + query + "\"", config.advanced_search[:query_parser]).to_query(param_hash)
    title_boost_query.join(" OR ")
  end

  # BLAC-326 add boosts to the anchored title index fields
  def add_anchored_title_boosts(param_hash)
    if param_hash.key?(:add_boost_query) && param_hash[:add_boost_query] && param_hash.key?(:qf) && param_hash[:qf].present?
      param_hash[:qf] = param_hash[:qf] << " anchored_title_tsi^600 anchored_title_only_tsi^500 anchored_title_no_format_tsi^500 left_anchored_title_tsi^800"
      param_hash.delete(:add_boost_query)
    end
  end

  def local_param_hash(key, config)
    field_def = config.search_fields[key] || {}

    (field_def[:solr_adv_parameters] || field_def[:solr_parameters] || {}).merge(field_def[:solr_local_parameters] || {})
  end
end
