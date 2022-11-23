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
    entry = nil
    caption = ""
    icon = ""

    if document.has_eresources?
      entry, caption, icon = makelink_eresource href
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

    # rubocop:disable Rails/OutputSafety
    if extended_info && caption.present?
      result << content_tag(:div, class: "linkCaption") do
        content_tag(:small, "#{icon}#{caption}".html_safe)
      end
    end
    # rubocop:enable Rails/OutputSafety

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

  def makelink_eresource(href)
    entry = nil
    caption = ""
    icon = ""

    if href.present?
      entry = Eresources.new.known_url(href)
    end

    if entry.present?
      caption = if entry[:entry]["remoteaccess"] == "yes"
        icon = <<~ICON
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-key-fill" viewBox="0 0 16 16">
            <path d="M3.5 11.5a3.5 3.5 0 1 1 3.163-5H14L15.5 8 14 9.5l-1-1-1 1-1-1-1 1-1-1-1 1H6.663a3.5 3.5 0 0 1-3.163 2zM2.5 9a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"/>
          </svg>
        ICON
        if user_location == :offsite
          if current_user
            t("eresource.remote_access.logged_in")
          else
            t("eresource.remote_access.logged_out")
          end
        else
          t("eresource.onsite")
        end
      else
        icon = <<~ICON
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-building-fill" viewBox="0 0 16 16">
            <path d="M3 0a1 1 0 0 0-1 1v14a1 1 0 0 0 1 1h3v-3.5a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 .5.5V16h3a1 1 0 0 0 1-1V1a1 1 0 0 0-1-1H3Zm1 2.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1Zm3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1Zm3.5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5ZM4 5.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1ZM7.5 5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5Zm2.5.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1ZM4.5 8h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5Zm2.5.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1Zm3.5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5Z"/>
          </svg>
        ICON
        if user_location == :offsite
          t("eresource.offsite")
        else
          t("eresource.onsite")
        end
      end
    end

    [entry, caption, icon]
  end
end
