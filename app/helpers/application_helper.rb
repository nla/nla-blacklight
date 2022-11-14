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

  def local_subnets
    config = Rails.application.config_for(:catalogue)
    config.subnet[:local].split(",")
  end

  def staff_subnets
    config = Rails.application.config_for(:catalogue)
    config.subnet[:staff].split(",")
  end

  def client_in_subnets(subnets)
    subnets.each do |subnet|
      if client_in_subnet(subnet)
        return true
      end
    end

    false
  end

  private

  def get_client_ip
    client_ip = request.remote_ip

    if client_ip.include? ","
      client_ip = client_ip.split(",")
      client_ip = client_ip.last
    end

    client_ip
  end

  def client_in_subnet(subnet)
    client_ip = get_client_ip

    client_ranges = client_ip.split(".")
    subnet_ranges = subnet.split(".")

    match = false
    4.times { |i|
      if subnet_ranges[i] == "0" || client_ranges[i] == subnet_ranges[i]
        match = true
      else
        return false
      end
    }

    match
  end
end
