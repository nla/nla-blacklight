# frozen_string_literal: true

class RequestDetailsComponent < ViewComponent::Base
  with_collection_parameter :holding

  def initialize(holding:, holding_iteration:)
    @holding = holding
    @iteration = holding_iteration
  end

  def recent_item_issue_held
    most_recent = @holding["holdingsStatements"].last

    if most_recent.present?
      if most_recent["statement"].present?
        most_recent["statement"]
      elsif most_recent["note"].present?
        most_recent["enumerationAndChronology"]
      end
    end
  end

  def items_issues_held
    @holding["holdingsStatements"].map do |statement|
      if statement["statement"].present?
        statement["statement"]
      elsif statement["note"].present?
        statement["note"]
      end
    end
  end

  def supplements
    @holding["holdingsStatementsForSupplements"].pluck("note")
  end

  def indexes
    @holding["holdingsStatementsForIndexes"].pluck("note")
  end

end
