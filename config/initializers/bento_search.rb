BentoSearch.register_engine("ebsco_eds_keyword") do |conf|
  conf.engine = "BentoSearch::EbscoEdsEngine"
  conf.user_id = ENV["EDS_USER"]
  conf.password = ENV["EDS_PASS"]
  conf.profile = ENV["EDS_PROFILE"]
  conf.title = "eResources (by keyword)"
  conf.for_display = {decorator: "EbscoEdsArticleDecorator"}
  conf.highlighting = false
end

BentoSearch.register_engine("ebsco_eds_title") do |conf|
  conf.engine = "BentoSearch::EbscoEdsEngine"
  conf.user_id = ENV["EDS_USER"]
  conf.password = ENV["EDS_PASS"]
  conf.profile = ENV["EDS_PROFILE"]
  conf.title = "eResources (by title)"
  conf.for_display = {decorator: "EbscoEdsArticleDecorator"}
  conf.highlighting = false
  conf.all_results_link = ENV["EDS_ALL_RESULTS_LINK"]
  conf.query_prefix = "TI"
end

BentoSearch.register_engine("catalogue") do |conf|
  conf.engine = "BentoSearch::BlacklightEngine"
  conf.title = "Catalogue"
  conf.search_url = ENV["CATALOGUE_SEARCH_URL"]
  conf.all_results_link = ENV["CATALOGUE_ALL_RESULTS_LINK"]
end

BentoSearch.register_engine("finding_aids") do |conf|
  conf.engine = "BentoSearch::BlacklightEngine"
  conf.title = "Finding Aids"
  conf.search_url = ENV["FINDING_AIDS_SEARCH_URL"]
  conf.all_results_link = ENV["FINDING_AIDS_ALL_RESULTS_LINK"]
end
