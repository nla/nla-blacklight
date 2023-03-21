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

BentoSearch.register_engine("Book") do |conf|
  conf.engine = "SolrEngine"
  conf.title = "Books"
  conf.blacklight_format = "Book"
end

BentoSearch.register_engine("Journal") do |conf|
  conf.engine = "SolrEngine"
  conf.title = "Journals"
  conf.blacklight_format = "Journal"
end

BentoSearch.register_engine("Picture") do |conf|
  conf.engine = "SolrEngine"
  conf.title = "Pictures"
  conf.blacklight_format = "Picture"
end

BentoSearch.register_engine("Online") do |conf|
  conf.engine = "SolrEngine"
  conf.title = "Online"
  conf.blacklight_format = "Online"
end

BentoSearch.register_engine("Music") do |conf|
  conf.engine = "SolrEngine"
  conf.title = "Music"
  conf.blacklight_format = "Music"
end

BentoSearch.register_engine("Object") do |conf|
  conf.engine = "SolrEngine"
  conf.title = "Objects"
  conf.blacklight_format = "Object"
end

BentoSearch.register_engine("Manuscript") do |conf|
  conf.engine = "SolrEngine"
  conf.title = "Manuscripts"
  conf.blacklight_format = "Manuscript"
end

BentoSearch.register_engine("Audio") do |conf|
  conf.engine = "SolrEngine"
  conf.title = "Audio"
  conf.blacklight_format = "Audio"
end

BentoSearch.register_engine("Video") do |conf|
  conf.engine = "SolrEngine"
  conf.title = "Videos"
  conf.blacklight_format = "Video"
end

BentoSearch.register_engine("Map") do |conf|
  conf.engine = "SolrEngine"
  conf.title = "Maps"
  conf.blacklight_format = "Map"
end

BentoSearch.register_engine("Kit") do |conf|
  conf.engine = "SolrEngine"
  conf.title = "Kits"
  conf.blacklight_format = "Kit"
end

BentoSearch.register_engine("Other") do |conf|
  conf.engine = "SolrEngine"
  conf.title = "Other"
  conf.blacklight_format = "Other"
end

BentoSearch.register_engine("Newspaper") do |conf|
  conf.engine = "SolrEngine"
  conf.title = "Newspaper"
  conf.blacklight_format = "Newspaper"
end
