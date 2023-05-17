module RequestHelper
  def recent_item_issue_held(holding)
    most_recent = holding["holdingsStatements"].last

    if most_recent.present?
      if most_recent["statement"].present?
        most_recent["statement"]
      elsif most_recent["note"].present?
        most_recent["enumeration"]
      end
    end
  end

  def items_issues_held(holding)
    holding["holdingsStatements"].map do |statement|
      if statement["statement"].present?
        statement["statement"]
      elsif statement["note"].present?
        statement["note"]
      end
    end
  end

  def supplements(holding)
    holding["holdingsStatementsForSupplements"].pluck("note")
  end

  def indexes(holding)
    holding["holdingsStatementsForIndexes"].pluck("note")
  end
end
