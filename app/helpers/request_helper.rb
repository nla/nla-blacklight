module RequestHelper
  def recent_item_issue_held(holding)
    most_recent = holding["holdingsStatements"].last

    if most_recent.present?
      merge_statements(holding["holdingsStatements"].map)
    else
      []
    end
  end

  def items_issues_held(holding)
    merge_statements(holding["holdingsStatements"])
  end

  def supplements(holding)
    merge_statements(holding["holdingsStatementsForSupplements"])
  end

  def merge_statements(statements)
    statements = statements.map do |statement|
      if statement["statement"].present?
        statement["statement"]
      elsif statement["note"].present?
        statement["note"]
      end
    end

    if statements.present?
      statements.compact
    else
      []
    end
  end

  def indexes(holding)
    holding["holdingsStatementsForIndexes"].map do |statement|
      if statement["statement"].present?
        statement["statement"]
      elsif statement["note"].present?
        statement["note"]
      end
    end
  end

  def pickup_location_text(item)
    if pickup_location_code(item).start_with? "MRR"
      link = link_to "Main Reading Room", "https://www.nla.gov.au/reading-rooms/main"
      t("requesting.collect_from.base", link: link, location: "Ground Level")
    elsif pickup_location_code(item).start_with? "SCRR"
      link = link_to "Special Collections Reading Room", "https://www.nla.gov.au/reading-rooms/special-collections"
      t("requesting.collect_from.base", link: link, location: "Level 1")
    else
      link = link_to "Newspapers and Family History", "https://www.nla.gov.au/reading-rooms/main/newspapers-and-family-history"
      t("requesting.collect_from.base", link: link, location: "Main Reading Room, Ground Level")
    end
  end

  def pickup_location_img(item)
    if pickup_location_code(item).start_with? "MRR"
      image_tag "pickup-locations/main_reading_room.jpeg", class: "img-fluid"
    elsif pickup_location_code(item).start_with? "SCRR"
      image_tag "pickup-locations/special_collections.jpeg", class: "img-fluid"
    else
      image_tag "pickup-locations/newspapers_and_family_history_zone.jpg", class: "img-fluid"
    end
  end

  def pickup_location_code(item)
    item["pickupLocation"]["code"]
  end
end
