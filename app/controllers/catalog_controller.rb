# frozen_string_literal: true

require "nla/solr_cloud/repository"

class CatalogController < ApplicationController
  include Blacklight::Catalog
  include BlacklightRangeLimit::ControllerOverride

  include Blacklight::Marc::Catalog
  include BentoSessionResetConcern

  before_action do
    Blacklight::Rendering::Pipeline.operations = [
      # from the default pipeline:
      Blacklight::Rendering::HelperMethod,
      Blacklight::Rendering::LinkToFacet,
      Blacklight::Rendering::Microdata,
      # replace Blacklight::Rendering::Join with NlaJoin to split multiple titles into separate lines
      NlaJoin
    ]
  end

  # If you'd like to handle errors returned by Solr in a certain way,
  # you can use Rails rescue_from with a method you define in this controller,
  # uncomment:
  #
  # rescue_from Blacklight::Exceptions::InvalidRequest, with: :my_handling_method

  configure_blacklight do |config|
    # default advanced config values
    config.advanced_search ||= Blacklight::OpenStructWithHashAccess.new
    # config.advanced_search[:qt] ||= "advanced"
    # config.advanced_search[:url_key] ||= "advanced"
    config.advanced_search[:enabled] = true
    config.advanced_search[:form_solr_parameters] = {}
    config.advanced_search[:query_parser] ||= "edismax"

    ## Specify the style of markup to be generated (may be 4 or 5)
    # config.bootstrap_version = 5
    #
    ## Class for sending and receiving requests from a search index
    if ENV["ZK_HOST"].present? && ENV["SOLR_COLLECTION"].present?
      config.repository_class = Nla::SolrCloud::Repository
    end
    #
    ## Class for converting Blacklight's url parameters to into request parameters for the search index
    # config.search_builder_class = ::SearchBuilder
    #
    ## Model that maps search index responses to the blacklight response model
    # config.response_model = Blacklight::Solr::Response
    #
    ## The destination for the link around the logo in the header
    config.logo_link = "https://www.library.gov.au"
    config.logo_text = "National Library of Australia"

    ## Should the raw solr document endpoint (e.g. /catalog/:id/raw) be enabled
    config.raw_endpoint.enabled = false

    ## Default parameters to send to solr for all search-like requests. See also SearchBuilder#processed_parameters
    config.default_solr_params = {
      rows: 10,
      qf: "id^2 title_stim^20 title_tsim^20 title_addl_tsim author_search_tsim subject_tsimv allfields_stimv",
      pf: "id title_stim^30 title_tsim^30 title_addl_tsim author_search_tsim subject_tsimv title_only_tsim^40 call_number_tsim^20",
      mm: "0",
      "q.op": "AND",
      add_boost_query: false
    }

    # solr path which will be added to solr base url before the other solr params.
    config.solr_path = "select"
    config.document_solr_path = "select"

    # solr parameters to send on single-document requests to Solr.
    # The "q" param is formatted in Blacklight::SolrCloud::Repository.find to search the "id" field.
    config.document_unique_id_param = "q"
    # These are sent by default to ensure all document fields are returned.
    # Facets, spellcheck and response header are omitted, since they're not needed.
    config.default_document_solr_params = {fl: "*", facet: "false", spellcheck: "false", omitHeader: "true"}

    # set to nil otherwise, advanced search will expect a Solr JSON DSL query handler at path "advanced" to exist
    config.json_solr_path = nil

    # items to show per page, each number in the array represent another option to choose from.
    # config.per_page = [10,20,50,100]

    # solr field configuration for search results/index views
    config.index.title_field = "title_tsim" # CHANGE THIS FIELD IN nla_join.rb ALSO!!!
    config.index.display_type_field = "format"
    # thumbnail_method is defined in ThumbnailHelper
    config.index.thumbnail_method = :render_thumbnail
    config.index.thumbnail_presenter = NlaThumbnailPresenter

    # The presenter is the view-model class for the page
    # config.index.document_presenter_class = MyApp::IndexPresenter

    # Some components can be configured
    # config.index.document_component = MyApp::SearchResultComponent
    # config.index.constraints_component = MyApp::ConstraintsComponent
    # config.index.search_bar_component = MyApp::SearchBarComponent
    # config.index.search_header_component = MyApp::SearchHeaderComponent
    config.show.document_actions.delete(:refworks)

    config.add_results_document_tool(:bookmark, component: Blacklight::Document::BookmarkComponent, if: :render_bookmarks_control?)

    config.add_results_collection_tool(:sort_widget)
    config.add_results_collection_tool(:per_page_widget)
    config.add_results_collection_tool(:view_type_group)

    config.add_show_tools_partial(:bookmark, component: Blacklight::Document::BookmarkComponent, if: :render_bookmarks_control?)
    config.add_show_tools_partial(:citation)

    config.add_nav_action(:new_search, partial: "shared/nav/new_search")
    config.add_nav_action(:catalogue, partial: "shared/nav/catalogue")
    config.add_nav_action(:eresources, partial: "shared/nav/eresources")
    config.add_nav_action(:finding_aids, partial: "shared/nav/finding_aids")
    # config.add_nav_action(:ask_a_librarian, partial: "shared/nav/ask_a_librarian")
    config.add_nav_action(:help, partial: "shared/nav/help")

    # solr field configuration for document/show views
    config.show.title_field = "title_tsim"
    config.show.display_type_field = "format"
    # config.show.thumbnail_field = 'thumbnail_path_ss'
    #
    # The presenter is a view-model class for the page
    # config.show.document_presenter_class = MyApp::ShowPresenter
    #
    # These components can be configured
    # config.show.document_component = MyApp::DocumentComponent
    # config.show.sidebar_component = MyApp::SidebarComponent
    # config.show.embed_component = MyApp::EmbedComponent

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    #
    # set :index_range to true if you want the facet pagination view to have facet prefix-based navigation
    #  (useful when user clicks "more" on a large facet and wants to navigate alphabetically across a large set of results)
    # :index_range can be an array or range of prefixes that will be used to create the navigation (note: It is case sensitive when searching values)

    config.add_facet_field "format", label: "Format", limit: 20
    config.add_facet_field "access_ssim", label: "Access"
    # config.add_facet_field "decade_isim", label: "Year Range"
    config.add_facet_field "decade_isim",
      label: "Year Range",
      include_in_advanced_search: false,
      range: {
        num_segments: 6,
        assumed_boundaries: nil,
        segments: true,
        maxlength: 4
      }
    config.add_facet_field "author_ssim", label: "Author", limit: true, index_range: "A".."Z"
    config.add_facet_field "subject_ssim", label: "Subject", limit: 20, index_range: "A".."Z"
    config.add_facet_field "austlang_ssim", label: "Aboriginal and Torres Strait Islander Language", limit: 10
    config.add_facet_field "language_ssim", label: "Language", limit: 10
    config.add_facet_field "geographic_name_ssim", label: "Geographic", limit: true, index_range: "A".."Z"
    config.add_facet_field "series_ssim", label: "Series", limit: true, index_range: "A".."Z", single: true
    config.add_facet_field "parent_id_ssim", label: "In Collection", limit: true, include_in_simple_select: false, include_in_advanced_search: false, show: false
    config.add_facet_field "collection_id_ssim", label: "Collection", limit: true, include_in_simple_select: false, include_in_advanced_search: false, show: false

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field "author_with_relator_ssim", label: "Author"
    config.add_index_field "uniform_title_ssim", label: "Uniform Title"
    config.add_index_field "format", label: "Format"
    config.add_index_field "language_ssim", label: "Language"
    config.add_index_field "publication_date", label: "Published", field: "display_publication_date_ssim"

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    config.add_show_field "id", label: "Bib ID"
    config.add_show_field "format", label: "Format"
    config.add_show_field "form_of_work_tsim", label: "Form of work", helper_method: :list
    config.add_show_field "author_with_relator_ssim", label: "Author", helper_method: :author_search_list
    config.add_show_field "translated_title_ssim", label: "Translated Title"
    config.add_show_field "uniform_title_ssim", label: "Uniform Title"
    config.add_show_field "online_access", label: "Online Access", accessor: :online_access_urls, helper_method: :url_list
    config.add_show_field "map_search", label: "Online Version", accessor: :map_search_urls, helper_method: :map_search
    config.add_show_field "copy_access", label: "Online Version", accessor: :copy_access_urls, helper_method: :url_list
    config.add_show_field "related_access", label: "Related Online Resources", accessor: :related_access_urls, helper_method: :url_list
    config.add_show_field "edition_tsim", label: "Edition", helper_method: :list
    config.add_show_field "access_conditions_ssim", label: "Access Conditions", helper_method: :emphasized_list, if: ->(_controller, _config, document) do
      !document.has_eresources?
    end
    config.add_show_field "scale_tsim", label: "Scale"
    config.add_show_field "printer_tsim", label: "Printer", helper_method: :unstyled_list
    config.add_show_field "description", label: "Description", accessor: :description, helper_method: :unstyled_list
    config.add_show_field "file_characteristics_ssim", label: "File Characteristics", helper_method: :unstyled_list
    config.add_show_field "isbn_tsim", label: "ISBN", accessor: :valid_isbn, helper_method: :unstyled_list
    config.add_show_field "invalid_isbn", label: "Invalid ISBN", accessor: :invalid_isbn, helper_method: :unstyled_list
    config.add_show_field "issn_display_ssim", label: "ISSN"
    config.add_show_field "invalid_issn_ssim", label: "Invalid ISSN", helper_method: :unstyled_list
    config.add_show_field "ismn_ssim", label: "ISMN", accessor: :ismn, helper_method: :unstyled_list
    config.add_show_field "invalid_ismn_ssim", label: "Invalid ISMN", accessor: :invalid_ismn, helper_method: :unstyled_list
    config.add_show_field "series_tsim", label: "Series", helper_method: :list
    config.add_show_field "technical_details_tsim", label: "Technical Details", helper_method: :unstyled_list
    config.add_show_field "summary_tsim", label: "Summary", helper_method: :paragraphs
    config.add_show_field "cultural_sensitivity_note_tsim", label: "Cultural sensitivity advisory notice", helper_method: :notes
    config.add_show_field "icip_note_tsim", label: "ICIP notice", helper_method: :notes
    config.add_show_field "content_advisory_note_tsim", label: "Content advisory notice", helper_method: :notes
    config.add_show_field "full_contents_tsim", label: "Full contents", helper_method: :format_contents_list
    config.add_show_field "partial_contents_tsim", label: "Partial contents", helper_method: :format_contents_list
    config.add_show_field "incomplete_contents_tsim", label: "Incomplete contents", helper_method: :format_contents_list
    config.add_show_field "credits_tsim", label: "Credits", helper_method: :unstyled_list
    config.add_show_field "performers_tsim", label: "Performer", helper_method: :unstyled_list
    config.add_show_field "biography_history_tsim", label: "Biography/History", helper_method: :paragraphs
    config.add_show_field "numbering_note_tsim", label: "Numbering Note", helper_method: :list
    config.add_show_field "data_quality_tsim", label: "Data Quality", helper_method: :unstyled_list
    config.add_show_field "notes_tsim", label: "Notes", helper_method: :notes
    config.add_show_field "binding_tsim", label: "Binding", helper_method: :unstyled_list
    config.add_show_field "related_material_tsim", label: "Related Material", helper_method: :list
    config.add_show_field "provenance_tsim", label: "Source of Acquisition", helper_method: :unstyled_list
    config.add_show_field "cited_in_tsim", label: "Cited In", helper_method: :unstyled_list
    config.add_show_field "reproduction_tsim", label: "Reproduction", helper_method: :unstyled_list
    config.add_show_field "life_dates_tsim", label: "Life Dates", separator_options: {
      two_words_connector: " ",
      words_connector: " ",
      last_word_connector: " "
    }
    config.add_show_field "has_supplement_tsim", label: "Has Supplement", helper_method: :unstyled_list
    config.add_show_field "supplement_to_tsim", label: "Supplement To", helper_method: :unstyled_list
    config.add_show_field "has_subseries_tsim", label: "Has Sub-series", helper_method: :list
    config.add_show_field "subseries_of_tsim", label: "Sub-series Of", helper_method: :unstyled_list
    config.add_show_field "new_title_tsim", label: "Later Title", helper_method: :unstyled_list
    config.add_show_field "old_title_tsim", label: "Former Title", helper_method: :unstyled_list
    config.add_show_field "related_title_tsim", label: "Related Title", helper_method: :unstyled_list
    config.add_show_field "issued_with_tsim", label: "Issued With", helper_method: :unstyled_list
    config.add_show_field "frequency_tsim", label: "Frequency", helper_method: :list
    config.add_show_field "previous_frequency_tsim", label: "Previous Frequency", helper_method: :list
    config.add_show_field "index_finding_aid_note_tsim", label: "Index/Finding Aid Note", helper_method: :list
    config.add_show_field "awards_tsim", label: "Awards", helper_method: :unstyled_list
    config.add_show_field "indigenous_subject_ssim", label: "First Nations (AIATSIS) Subject", helper_method: :indigenous_subject_search_list
    config.add_show_field "subject_ssim", label: "Subject", helper_method: :subject_search_list
    config.add_show_field "genre_ssim", label: "Genre/Form", helper_method: :genre_search_list
    config.add_show_field "time_coverage", label: "Time Coverage", accessor: :time_coverage
    config.add_show_field "occupation_ssim", label: "Occupation", helper_method: :occupation_search_list
    config.add_show_field "place_tsim", label: "Place", helper_method: :list
    config.add_show_field "additional_author_with_relator_ssim", label: "Other authors/contributors", helper_method: :other_author_search_list
    config.add_show_field "also_titled_tsim", label: "Also Titled", helper_method: :list
    config.add_show_field "terms_of_use_tsim", label: "Terms of Use", helper_method: :emphasized_list
    config.add_show_field "copyright_ssim", label: "Copyright Information", helper_method: :emphasized_list
    config.add_show_field "available_from_tsim", label: "Available From", helper_method: :unstyled_list
    config.add_show_field "acknowledgement_tsim", label: "Acknowledgement", helper_method: :unstyled_list
    config.add_show_field "exhibited_tsim", label: "Exhibited", helper_method: :list
    config.add_show_field "govt_doc_number_tsim", label: "Govt. Doc. Number", helper_method: :list
    config.add_show_field "music_publisher_number_tsim", label: "Music Publisher Number", helper_method: :list
    config.add_show_field "related_records", label: "Related Records", accessor: :related_records, helper_method: :render_related_records_component
    config.add_show_field "rights_information", label: "Rights information", accessor: :rights_information, helper_method: :url_list, component: StaffOnlyComponent
    config.add_show_field "copyright_info", label: "Copyright", accessor: :copyright_status, helper_method: :render_copyright_component, if: ->(_controller, _config, document) do
      # if there is no contextMsg, there is no rights information from the copyright service
      document.copyright_status.present? && document.copyright_status["contextMsg"].present?
    end

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field "all_fields", label: "All Fields"

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    config.add_search_field("title") do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        "spellcheck.dictionary": "title",
        qf: "title_stim^20 title_tsim^20 title_addl_tsim",
        pf: "title_stim^30 title_tsim^30 title_addl_tsim title_only_tsim^40"
      }
      field.clause_params = {
        edismax: field.solr_parameters.dup
      }
    end

    config.add_search_field("author") do |field|
      field.solr_parameters = {
        "spellcheck.dictionary": "author",
        qf: "author_search_tesim",
        pf: "author_search_tesim"
      }
      field.clause_params = {
        edismax: field.solr_parameters.dup
      }
    end

    config.add_search_field("subject") do |field|
      field.label = "Subject"
      field.solr_parameters = {
        "spellcheck.dictionary": "subject",
        qf: "subject_tsimv",
        pf: "subject_tsimv"
      }
      field.clause_params = {
        edismax: field.solr_parameters.dup
      }
    end

    config.add_search_field("indigenous_subject") do |field|
      field.label = "AIATSIS Subject"
      field.solr_parameters = {
        "spellcheck.dictionary": "subject",
        qf: "indigenous_subject_tsimv",
        pf: "indigenous_subject_tsimv"
      }
      field.clause_params = {
        edismax: field.solr_parameters.dup
      }
      field.include_in_advanced_search = false
    end

    config.add_search_field("call_number") do |field|
      field.label = "Call Number"
      field.solr_parameters = {
        qf: "call_number_tsim",
        pf: "call_number_tsim"
      }
      field.clause_params = {
        edismax: field.solr_parameters.dup
      }
    end

    config.add_search_field("isbn") do |field|
      field.label = "ISBN/ISSN"
      field.solr_parameters = {
        qf: "isbn_tsim",
        pf: "isbn_tsim"
      }
      field.clause_params = {
        edismax: field.solr_parameters.dup
      }
    end

    config.add_search_field("id") do |field|
      field.label = "Bib Id"
      field.solr_parameters = {
        qf: "id",
        pf: "id"
      }
      field.clause_params = {
        edismax: field.solr_parameters.dup
      }
    end

    config.add_search_field("occupation") do |field|
      field.label = "Occupation"
      field.solr_parameters = {
        qf: "occupation_tesim",
        pf: "occupation_tesim"
      }
      field.clause_params = {
        edismax: field.solr_parameters.dup
      }
    end

    config.add_search_field("genre") do |field|
      field.label = "Genre"
      field.solr_parameters = {
        qf: "genre_tesim",
        pf: "genre_tesim"
      }
      field.clause_params = {
        edismax: field.solr_parameters.dup
      }
    end

    config.add_search_field("in_collection") do |field|
      field.label = "In Collection"
      field.solr_parameters = {
        qf: "parent_id_ssim",
        pf: "parent_id_ssim"
      }
      field.include_in_simple_select = false
      field.include_in_advanced_search = false
    end

    config.add_search_field("collection") do |field|
      field.label = "Collection"
      field.solr_parameters = {
        qf: "collection_id_ssim",
        pf: "collection_id_ssim"
      }
      field.include_in_simple_select = false
      field.include_in_advanced_search = false
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the Solr field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case). Add the sort: option to configure a
    # custom Blacklight url parameter value separate from the Solr sort fields.
    config.add_sort_field "relevance", sort: "score desc, pub_date_si desc, title_si asc", label: "Relevance"
    config.add_sort_field "date-desc", sort: "pub_date_si desc, title_si asc", label: "Date New to Old"
    config.add_sort_field "date-asc", sort: "pub_date_si asc, title_si asc", label: "Date Old to New"
    config.add_sort_field "author-asc", sort: "author_si asc, title_si asc", label: "Author A-Z"
    config.add_sort_field "author-desc", sort: "author_si desc, title_si asc", label: "Author Z-A"
    config.add_sort_field "title-asc", sort: "title_si asc, pub_date_si desc", label: "Title A-Z"
    config.add_sort_field "title-desc", sort: "title_si desc, pub_date_si desc", label: "Title Z-A"

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 0

    # Configuration for autocomplete suggester
    config.autocomplete_enabled = true
    config.autocomplete_path = "suggest"
    # if the name of the solr.SuggestComponent provided in your solrconfig.xml is not the
    # default 'mySuggester', uncomment and provide it below
    # config.autocomplete_suggester = 'mySuggester'
  end

  def offsite
    url = params[:url]

    unless url.match?(/^https?:\/\/.*/)
      raise t("offsite.invalid_url", url: url)
    end

    @eresource = Eresources.new.known_url(url)

    if @eresource.present?
      if helpers.user_type == :local || helpers.user_type == :staff
        CatalogueServicesClient.new.post_stats EresourcesStats.new(@eresource, helpers.user_type)

        # This is used to find users who have made too many requests to a resource
        helpers.log_eresources_offsite_access(url)

        # send to EzyProxy
        return redirect_to EzproxyUrl.new(@eresource[:url]).url, allow_other_host: true

      elsif @eresource[:entry]["remoteaccess"] == "yes"
        # already logged in
        if current_user.present?
          CatalogueServicesClient.new.post_stats EresourcesStats.new(@eresource, helpers.user_type)

          # This is used to find users who have made too many requests to a resource
          helpers.log_eresources_offsite_access(url)

          return redirect_to @eresource[:url], allow_other_host: true if @eresource[:type] == "remoteurl"

          return redirect_to EzproxyUrl.new(@eresource[:url]).url, allow_other_host: true
        else
          info_msg = if @eresource[:entry]["title"].strip.casecmp? "ebsco"
            t("offsite.ebsco")
          else
            begin
              @document = search_service.fetch(params[:id])
              # if for some reason we can't find the document title, just use the title from the eResource entry
              t("offsite.other", title: @document.fetch("title_tsim", [@eresource[:entry]["title"]]).first.strip)
            rescue Blacklight::Exceptions::RecordNotFound
              t("offsite.other", title: [@eresource[:entry]["title"]].first&.strip)
            end
          end

          return redirect_to new_user_session_url, flash: {alert: info_msg}
        end
      else
        @requested_url = url
        @record_url = solr_document_path(id: params[:id])
        return render "onsite_only"
      end
    end

    # if all else fails, redirect back to the same catalogue record page
    redirect_to solr_document_path(id: params[:id])
  end
end
