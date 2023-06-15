# frozen_string_literal: true

module BentoSearch
  class EdsApiEngine
    include BentoSearch::SearchEngine

    def search_implementation(args)
      session = EBSCO::EDS::Session.new({
        caller: "blacklight-bento-search",
        debug: ENV.fetch("EDS_DEBUG", true),
        profile: ENV["EDS_PROFILE"],
        guest: false,
        user: ENV["EDS_USER"],
        pass: ENV["EDS_PASS"],
        use_cache: true,
        eds_cache_dir: ENV.fetch("BLACKLIGHT_TMP_PATH", "tmp"),
        log: ENV.fetch("BLACKLIGHT_TMP_PATH", "tmp") + "/eds_faraday.log"
      })

      results = Results.new
      begin
        results = Results.new

        q = construct_query(args)

        sq = {
          query: q,
          results_per_page: args[:per_page],
          highlight: false,
          include_facets: false
        }

        response = session.search(sq, add_actions: false)
        total_hits = response.stat_total_hits

        results.total_items = total_hits.to_i

        response.records.each do |record|
          item = BentoSearch::ResultItem.new
          item.link_is_fulltext = true

          item.title = (record.eds_title.presence || I18n.t("bento_search.eds.record_not_available"))
          item.title = prepare_ebsco_eds_payload(item.title, true)

          item.abstract = record.eds_abstract
          item.abstract = prepare_ebsco_eds_payload(item.abstract, true)

          item.unique_id = record.id
          authors = record.eds_authors
          authors.each do |author|
            item.authors << BentoSearch::Author.new(display: author)
          end
          item.link = record.eds_plink

          item.format_str = record.eds_publication_type
          item.doi = record.eds_document_doi
          if record.eds_page_start.present?
            item.start_page = record.eds_page_start.to_s
            if record.eds_page_count.present?
              item.end_page = (record.eds_page_start.to_i + record.eds_page_count.to_i - 1).to_s
            end
          end
          date = record.eds_publication_date
          if date.present?
            ymd = date.split("-").map(&:to_i)
            item.publication_date = Date.new(ymd[0], ymd[1], ymd[2])
          end
          year = record.eds_publication_year
          if year.present?
            item.year = year
          end
          item.source_title = record.eds_source_title
          item.volume = record.eds_volume
          results << item
        end

        results
      rescue StandardError, BentoSearch::RubyTimeoutClass => e
        results.total_items = 0
        results.error ||= {}
        results.error[:exception] = e
        results
      end
    end

    def construct_query(args)
      query = "AND,"
      if args[:search_field]
        query += "#{args[:search_field]}:"
      end
      # Can't have any commas in query, it turns out, although
      # this is not documented.
      query + args[:query].gsub(",", " ")
    end

    def prepare_ebsco_eds_payload(str, html_safe = false)
      str = HTMLEntities.new.decode str

      if str.present?
        if configuration.highlighting
          str.gsub!(/<highlight>/, "<b class='bento_search_highlight'>")
          str.gsub!(/<\/hilight>/, "</b>")
        elsif html_safe
          # rubocop:disable Rails/OutputSafety
          str = str.html_safe
          # rubocop:enable Rails/OutputSafety
        end
      end

      str
    end
  end
end
