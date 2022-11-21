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

  def in_local_subnet?
    client_in_subnets(local_subnets)
  end

  def in_staff_subnet?
    client_in_subnets(staff_subnets)
  end

  def user_location
    if in_local_subnet?
      :onsite
    elsif in_staff_subnet?
      :staff
    else
      :offsite
    end
  end

  def user_type
    if in_local_subnet?
      :local
    elsif in_staff_subnet?
      :staff
    else
      :external
    end
  end

  def makelink(document:, href:, text:, classes: "", extended_info: false, longtext: "")
    caption = ""
    entry = nil

    if document.has_eresources?
      if href.present?
        entry = Eresources.new.known_url(href)
      end

      if entry.present?
        caption = if entry["remoteaccess"] == "yes"
          if user_location == :offsite
            if current_user
              "You are logged in and can access this resource"
            else
              "Log in with your Library card to access this resource"
            end
          else
            "You can access this resource because you are inside the National Library building"
          end
        elsif user_location == :offsite
          "You can access this resource if you visit the National Library building"
        else
          "You can access this resource because you are inside the National Library building"
        end
      end
    end

    result = []

    if text.present? && href.present?
      # if an eResources link, route to offsite handler
      result << if entry.present?
        link_to(text, offsite_catalog_path(id: document.id, url: href))
      else
        link_to(text, href)
      end
    end

    if extended_info
      result << content_tag(:div, class: "linkCaption") do
        content_tag(:small, caption)
      end
    end

    result
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
