# frozen_string_literal: true

module SingleSearchHelper
  def downcast(str)
    str.tr("/", "_")
      .gsub(/::/, "/")
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr(" -", "_")
      .downcase
  end

  def ss_uri_encode(link_url)
    link_url = link_url.gsub("% ", "%25%20") unless link_url.match?("%25")
    link_url = link_url.gsub("$", "%24")
    link_url = link_url.gsub(";", "%3B")
    link_url = link_url.gsub(" ", "%20")
    link_url = link_url.gsub("[", "%5B")
    link_url = link_url.gsub("]", "%5D")
    link_url = link_url.gsub('"', "%22")
    link_url = link_url.gsub("(", "%28")
    link_url.gsub(")", "%29")
  end

  def is_catalog_pane?(pane)
    pane == "Catalogue"
  end

  def bento_all_results_link(key)
    bento_query = params[:q] || params[:query]
    link = if key.start_with?("ebsco_eds_")
      ebsco_link = if bento_query.present?
        "#{ENV["EBSCO_SEARCH_URL"]}&custid=#{ENV["EDS_ORG"]}&bquery=#{bento_query}"
      else
        "#{ENV["EBSCO_SEARCH_URL"]}&custid=#{ENV["EDS_ORG"]}"
      end
      ebsco_link
    elsif key == "finding_aids"
      fa_base_url = ENV["FINDING_AIDS_SEARCH_URL"].chomp("/catalog.json")
      "#{fa_base_url}?group=false&search_field=all_fields&q=#{bento_query}"
    else
      cat_link = controller.all_items_url(key, bento_query, BentoSearch.get_engine(key).configuration.blacklight_format)
      "#{request.protocol}#{request.host_with_port}#{cat_link}"
    end

    ss_uri_encode(link)
  end

  def advanced_search_link(key, query)
    qp2 = "all_fields=#{ss_uri_encode(query).gsub("&", "%26")}&search_field=advanced"
    "/advanced?#{qp2}"
  end

  def access_url_is_list?(args)
    args["url_access_json"].present? && args["url_access_json"].size != 1
  end

  # def access_url_single(args)
  #   if !args["url_access_json"].present? || access_url_is_list?(args)
  #     nil
  #   else
  #     url_access = JSON.parse(args["url_access_json"][0])
  #     if url_access['url'].present?
  #       url_access['url']
  #     else
  #       nil
  #     end
  #   end
  # end

  def is_catalogued?(url)
    if url.nil?
      false
    else
      # (url.include?("/catalog/") && !url.include?( "library.cornell.edu"))
      url.start_with?("/catalog/")
    end
  end
end
