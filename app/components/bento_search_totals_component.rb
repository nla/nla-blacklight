# frozen_string_literal: true

class BentoSearchTotalsComponent < ViewComponent::Base
  def initialize(engines)
    @engines = engines
  end
end
