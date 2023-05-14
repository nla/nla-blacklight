# frozen_string_literal: true

class RequestDetailsComponent < ViewComponent::Base
  with_collection_parameter :holding

  def initialize(holding:, holding_iteration:)
    @holding = holding
    @iteration = holding_iteration
  end

end
