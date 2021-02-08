module ApplicationHelper

  ##
  # Get a display value from embedded marc record rather than a solr index field.
  #
  # example for catalog_controller:
  #     config.add_show_field '020aq', label: 'ISBN', field: 'id', helper_method: :from_marc
  def from_marc(options={})
    options[:document].get_marc_derived_field(options[:config][:key])
  end

end
