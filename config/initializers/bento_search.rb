BentoSearch.register_engine("ebsco_eds_keyword") do |conf|
  conf.engine = "BentoSearch::EdsEngine"
  conf.user_id = ENV["EDS_USER"]
  conf.password = ENV["EDS_PASS"]
  conf.auth = true
  conf.highlighting = false
  conf.profile = ENV["EDS_PROFILE"]
  conf.title = "eResources (Keyword)"
  conf.base_url = "https://eds-api.ebscohost.com/edsapi/rest/"
end

BentoSearch.register_engine("ebsco_eds_title") do |conf|
  conf.engine = "BentoSearch::EdsPublicationEngine"
  conf.user_id = ENV["EDS_USER"]
  conf.password = ENV["EDS_PASS"]
  conf.auth = true
  conf.highlighting = false
  conf.profile = ENV["EDS_PROFILE"]
  conf.publication_base_url = "https://eds-api.ebscohost.com/edsapi/publication/"
  conf.title = "eResources (Publications)"
  conf.base_url = "https://eds-api.ebscohost.com/edsapi/rest/"
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
