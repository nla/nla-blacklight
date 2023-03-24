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
end

BentoSearch.register_engine("catalogue") do |conf|
  conf.engine = "BentoSearch::SolrEngineSingle"
  conf.title = "Catalogue"
end

BentoSearch.register_engine("finding_aids") do |conf|
  conf.engine = "BentoSearch::FindingAidsEngine"
  conf.title = "Finding Aids"
end
