# frozen_string_literal: true

require "blacklight/solr_cloud/repository"

class BentoSearch::SolrEngineSingle
  include BentoSearch::SearchEngine

  # Next, at a minimum, you need to implement a #search_implementation method,
  # which takes a normalized hash of search instructions as input (see documentation
  # at #normalized_search_arguments), and returns BentoSearch::Results item.
  #
  # The Results object should have #total_items set with total hitcount, and contain
  # BentoSearch::ResultItem objects for each hit in the current page. See individual class
  # documentation for more info.
  def search_implementation(args)
    # 'args' should be a normalized search arguments hash including the following elements:
    # :query, :per_page, :start, :page, :search_field, :sort
    bento_results = BentoSearch::Results.new
    # solr search must be transformed to match simple search transformation.
    q = SearchController.transform_query args[:query]

    blacklight_config = CatalogController.blacklight_config.inheritable_copy(self)
    search_service = Blacklight.repository_class.new(blacklight_config)

    solr_response = search_service.search(
      q: q,
      rows: args[:per_page]
    )

    total_items = solr_response["response"]["numFound"]

    if total_items == 0
      bento_results.total_items = 0
    else
      bento_results.total_items = total_items

      solr_response["response"]["docs"].each do |doc|
        item = BentoSearch::ResultItem.new

        item.unique_id = doc["id"]
        item.title = doc["title_ssim"][0]

        if doc["pub_date_ssim"].present?
          item.year = doc["pub_date_ssim"][0]
        end

        if doc["author_with_relator_ssim"].present?
          item.authors << BentoSearch::Author.new(display: doc["author_with_relator_ssim"][0])
        end

        if doc["additional_author_with_relator_ssim"].present?
          item.authors << BentoSearch::Author.new(display: doc["additional_author_with_relator_ssim"][0])
        end

        if doc["language_ssim"].present?
          item.language_str = doc["language_ssim"][0]
        end

        if doc["call_number_ssim"].present?
          item.custom_data[:callnumber] = doc["call_number_ssim"][0]
        end

        item.link = "/catalog/#{doc["id"]}"

        bento_results << item
      end
    end

    bento_results
  end
end
