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

  def is_excluded_blacklight_searchbar_display_path?
    if (current_page?(root_path) || current_page?(search_catalog_path)) && !has_search_parameters?
      true
    else
      current_page?(bento_search_index_path)
    end
  end

  # This will exclude displaying the global message on the home page because the
  # GlobalMessageComponent is displayed inside the _home_text.html.erb template and would cause
  # the message to be displayed twice.
  def display_global_message_on_page?
    # !current_page?(root_path) && (current_page?(search_catalog_path) && has_search_parameters?)
    if current_page?(search_catalog_path)
      has_search_parameters?
    elsif !current_page?(root_path)
      true
    elsif current_page?(root_path)
      has_search_parameters?
    else
      false
    end
  end

  private

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
