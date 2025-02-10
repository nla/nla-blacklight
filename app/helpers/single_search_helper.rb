# frozen_string_literal: true

module SingleSearchHelper
  def downcast(str)
    str.tr("/", "_")
      .gsub("::", "/")
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr(" -", "_")
      .downcase
  end

  def ss_uri_encode(link_url)
    link_url = link_url.gsub("%", "%25") unless link_url.match?("%25")
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
    link = if key.start_with?("ebsco_eds_keyword")
      ebsco_link = if bento_query.present?
        "#{ENV["EBSCO_SEARCH_URL"]}&custid=#{ENV["EDS_ORG"]}&bquery=#{bento_query}"
      else
        "#{ENV["EBSCO_SEARCH_URL"]}&custid=#{ENV["EDS_ORG"]}"
      end
      ebsco_link
    elsif key == "ebsco_eds_title"
      ebsco_link = if bento_query.present?
        "#{ENV["EBSCO_SEARCH_URL"]}&custid=#{ENV["EDS_ORG"]}&bquery=TI+#{bento_query}"
      else
        "#{ENV["EBSCO_SEARCH_URL"]}&custid=#{ENV["EDS_ORG"]}"
      end
      ebsco_link
    elsif key == "finding_aids"
      fa_base_url = ENV["FINDING_AIDS_SEARCH_URL"].chomp("/catalog.json")
      "#{fa_base_url}?group=false&search_field=all_fields&q=#{bento_query}"
    else
      "#{search_catalog_url}?search_field=all_fields&q=#{bento_query&.gsub("&", "%26")}"
    end

    ss_uri_encode(link)
  end

  def advanced_search_link(key, query)
    qp2 = "all_fields=#{ss_uri_encode(query).gsub("&", "%26")}&search_field=advanced"
    "#{advanced_search_catalog_url}?#{qp2}"
  end

  def is_catalogued?(url)
    begin
      uri = Addressable::URI.parse(url) || nil
    rescue Addressable::URI::InvalidURIError
      uri = nil
    end

    if uri.nil?
      false
    else
      uri.host.start_with?("catalogue")
    end
  end
end
