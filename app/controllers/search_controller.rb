# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    unless params["q"].nil?
      @query = params["q"]
      original_query = @query

      if @query.include?('""')
        @query = check_mixed_quoted_bento(@query)
      end

      @cat_per_page = params["cat_per_page"] || 10
      @eds_per_page = params["eds_per_page"] || 3
      @fa_per_page = params["fa_per_page"] || 3

      @hide_empty = params["hide_empty"] || false

      @results = {}

      searcher = BentoSearch.get_engine("ebsco_eds_keyword")
      @results["ebsco_eds_keyword"] = searcher.search("#{@query}", per_page: @eds_per_page)

      searcher = BentoSearch.get_engine("ebsco_eds_title")
      @results["ebsco_eds_title"] = searcher.search("TI #{@query}", oq: original_query, per_page: @eds_per_page)

      searcher = BentoSearch.get_engine("catalogue")
      @results["catalogue"] = searcher.search(@query, per_page: @cat_per_page)

      searcher = BentoSearch.get_engine("finding_aids")
      @results["finding_aids"] = searcher.search(@query, server_addr: request.server_name, per_page: @fa_per_page)
    end

    render "single_search/index"
  end

  # def single_search
  #   begin
  #     @engine = BentoSearch.get_engine(params[:engine])
  #   rescue BentoSearch::NoSuchEngine => e
  #     @engine = params[:engine]
  #     @error_msg = e.message
  #     flash.now[:error] = "There is no registered search engine for the type #{@engine}."
  #     render status: 404, text: e.message, template: "single_search/single_search"
  #     return
  #   end
  #
  #   if params[:q]
  #     args = {}
  #     args[:query] = params[:q]
  #     args[:oq] = params[:q]
  #     args[:page] = params[:page]
  #     args[:semantic_search_field] = params[:field]
  #     args[:per_page] = 3
  #     args[:sort] = params[:sort]
  #     args[:per_page] = params[:per_page]
  #     @results = @engine.search(params[:q], args)
  #   end
  #
  #   render "single_search/single_search"
  # end

  def self.transform_query(search_query)
    # Don't do anything for already-quoted queries or single-term queries
    if search_query !~ (/["'].*?["']/) &&
        search_query !~ (/AND|OR|NOT/)

      # create modified query: (+x +y +z) OR "x y z"
      new_query = search_query.split.map { |w| "\"#{w}\"" }.join(" AND ")
      # (have to use double quotes; single returns an incorrect result set from Solr!)
      search_query = "(#{new_query}) OR \"#{search_query}\""
    else
      if (search_query.first == "'") && (search_query.last == "'")
        search_query = search_query.delete("'")
        search_query = "(#{search_query}) OR \"#{search_query}\""
      end
      search_query
    end

    search_query
  end

  def all_items_url(engine_id, query, format)
    if engine_id.start_with? "ebsco_eds_"
      query = query.gsub("&", "%26")
      "https://proxy.library.cornell.edu/login?url=https://discovery.ebsco.com/c/u2yil2/results?q=#{query}"
    else
      # Need to pass pluses through as urlencoded characters in order to preserve
      # the Solr query format.
      path = "/"
      escaped = if format == "all"
        {q: query}.to_param
      else
        {q: query, search_field: "all_fields"}.to_param
      end
      "#{path}?#{escaped}"
    end
  end

  protected

  def sort_panes(results, display_type, max_scores)
    top1 = top4 = secondary = []

    # Sort formats alphabetically for more results
    more = results.sort_by { |key, _result| BentoSearch.get_engine(key).configuration.title }

    # Top 2 are books and articles, regardless of display type
    top1 << ["ebsco_eds", results.delete("ebsco_eds")]
    top4 = top1

    # Sort the remaining format results by max relevancy score
    results = results.sort_by { |key, _result| max_scores[key] }
    results = results.reverse

    if display_type == "dynamic"
      # Take the top2 plus the next 2 formats with the highest result counts
      results.to(2).each do |result|
        top4 << result
      end
      secondary = results.from(3)
    else
      # We already took the top four before sorting
      secondary = results
    end

    [top4, secondary, more]
  end

  # In order to trick bento_search into thinking that our results from our single Solr query are
  # a group of results for different item formats, we have to take an extra step here to parse out
  # the one result from the Solr query into the different formats and create a BentoSearch:: Results
  # object for each one.
  #
  # Also sort the results by max relevancy
  def facet_solr_results(unfaceted_results)
    groups = unfaceted_results
    max_relevancy_scores = {}
    output = {}

    groups.each do |g|
      # Each group is a format, e.g., Book
      bento_set = BentoSearch::Results.new
      bento_set.total_items = g["doclist"]["numFound"]
      docs = g["doclist"]["docs"]
      # Iterate through each book search result and create a ResultItem for it.
      docs.each do |d|
        item = BentoSearch::ResultItem.new
        item.title = d["title_ssim"].present? ? d["title_ssim"][0] : ""
        if d["author_with_relator_ssim"].present?
          d["author_with_relator_ssim"].each do |author|
            a = BentoSearch::Author.new(display: author)
            item.authors << a
          end
        end
        item.year = d["pub_date_ssim"].present? ? d["pub_date_ssim"][0] : ""
        # item.link = "http://" + @catalog_host + "/catalog/#{d['id']}"
        item.unique_id = (d["id"]).to_s
        item.link = "/catalog/#{d["id"]}"
        item.custom_data = {
          language: d["language_ssim"],
          callnumber: d["call_number_ssim"]
        }
        item.format = d["format"].present? ? d["format"][0] : ""
        bento_set << item

        # The first search result should have the maximum relevancy score. Save this for later
        max_relevancy_scores[g["groupValue"]] ||= d["score"]
      end

      output[g["groupValue"]] = bento_set
    end

    [output, max_relevancy_scores]
  end

  def check_mixed_quoted_bento(query)
    return_array = []
    add_fields_array = []
    if (query.first == '"') && (query.last == '"')
      if query.count('"') > 2
        return_array = parse_quoted_query_bento(query)
        return_array.each do |token|
          token = if token.first == '"'
            "+quoted:" + token
          else
            "+" + token
          end

          add_fields_array << token
        end
        return_array = add_fields_array
      else
        return_array << query
      end
      return_array
    else
      clear_array = []
      return_array = parse_quoted_query_bento(query)
      return_array.each do |token|
        clear_array << if token.first == '"'
          "+quoted:" + token
        else
          "+" + token
        end
      end
      clear_array
    end
  end

  def parse_quoted_query_bento(quoted_array)
    query_array = []
    token_string = ""
    length_counter = 0
    quote_flag = 0
    quoted_array.each_char do |x|
      length_counter += 1
      if (x != '"') && (x != " ")
        token_string += x
      end
      if x == " "
        if quote_flag != 0
          token_string += x
        else
          query_array << token_string
          token_string = ""
        end
      end
      if (x == '"') && (quote_flag == 0)
        if token_string != ""
          query_array << token_string
        end
        token_string = x
        quote_flag = 1
      end
      if (x == '"') && (quote_flag == 1)
        if (token_string != "") && (token_string != '"')
          token_string += x
          query_array << token_string
          token_string = ""
          quote_flag = 0
        end
      end
      if length_counter == quoted_array.size
        query_array << token_string
      end
    end
    clean_array = []
    query_array.each do |toke|
      if toke != ""
        if toke.present?
          clean_array << toke.rstrip
        end
      end
    end
    clean_array
  end
end
