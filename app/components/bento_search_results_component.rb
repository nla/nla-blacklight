# frozen_string_literal: true

class BentoSearchResultsComponent < ViewComponent::Base
  def initialize(engine, url)
    @engine = engine
    @url = url
  end
end
