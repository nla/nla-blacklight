module ApplicationHelper
  ##
  # Get a display value from embedded marc record rather than a solr index field.
  #
  # example for catalog_controller:
  #     config.add_show_field '020aq', label: 'ISBN', field: 'id', helper_method: :from_marc
  #
  # field: can be any existing solr field. Needs to be included to force display of the results
  def from_marc(options = {})
    options[:document].get_marc_derived_field(options[:config][:key])
  end

  def get_thumbnail(document, options = {})
    url = from_marc({document: document, config: {key: "856u"}}).first
    unless url.blank? || url.include?("nla.arc")
      image_tag(url + "/image?wid=123", options.merge(alt: presenter(document).heading))
    end
  end
end
