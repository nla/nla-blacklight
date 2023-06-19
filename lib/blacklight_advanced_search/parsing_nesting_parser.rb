require "parsing_nesting/tree"
module BlacklightAdvancedSearch::ParsingNestingParser
  def process_query(_params, config)
    queries = keyword_queries.map do |field, query|
      param_hash = local_param_hash(field, config)

      # BLAC-326 add boosts to the anchored title index fields
      if field == "title" || field == "all_fields"
        add_anchored_title_boosts(param_hash, query)
      end
      ParsingNesting::Tree.parse(query, config.advanced_search[:query_parser]).to_query(param_hash)
    end

    queries.join(" #{keyword_op} ")
  end

  # BLAC-326 add boosts to the anchored title index fields
  def add_anchored_title_boosts(param_hash, query)
    param_hash[:bq] = "anchored_title_tsi:\"FINLLFIIJQ " + query + " AICULEDSSUL\"^600 OR anchored_title_only_tsi:\"FINLLFIIJQ " +
      query + " AICULEDSSUL\"^500 OR anchored_title_no_format_tsi:\"FINLLFIIJQ " + query +
      " AICULEDSSUL\"^500 OR left_anchored_title_tsi:\"FINLLFIIJQ " + query + "\"^800"
  end

  def local_param_hash(key, config)
    field_def = config.search_fields[key] || {}

    (field_def[:solr_adv_parameters] || field_def[:solr_parameters] || {}).merge(field_def[:solr_local_parameters] || {})
  end
end
