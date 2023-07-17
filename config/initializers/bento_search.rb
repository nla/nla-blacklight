BentoSearch.register_engine("ebsco_eds_keyword") do |conf|
  conf.engine = "BentoSearch::EdsApiEngine"
  conf.user_id = ENV["EDS_USER"]
  conf.password = ENV["EDS_PASS"]
  conf.profile = ENV["EDS_PROFILE"]
  conf.title = "eResources (Online articles & ebooks)"
  conf.for_display = {decorator: "EbscoEdsArticleDecorator"}
  conf.all_results_link = ENV["EDS_ALL_RESULTS_LINK"]
end

BentoSearch.register_engine("ebsco_eds_title") do |conf|
  conf.engine = "BentoSearch::EdsApiEngine"
  conf.user_id = ENV["EDS_USER"]
  conf.password = ENV["EDS_PASS"]
  conf.profile = ENV["EDS_PROFILE"]
  conf.title = "eResources (Online journals)"
  conf.for_display = {decorator: "EbscoEdsArticleDecorator"}
  conf.all_results_link = ENV["EDS_ALL_RESULTS_LINK"]
  conf.search_field = "TI"
end

BentoSearch.register_engine("catalogue") do |conf|
  conf.engine = "BentoSearch::BlacklightEngine"
  conf.title = "Catalogue"
  conf.base_url = ENV["CATALOGUE_SEARCH_URL"]
end

BentoSearch.register_engine("finding_aids") do |conf|
  conf.engine = "BentoSearch::BlacklightEngine"
  conf.title = "Finding Aids"
  conf.base_url = ENV["FINDING_AIDS_SEARCH_URL"]
end
