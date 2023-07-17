# frozen_string_literal: true

class RequestsTableComponent < ViewComponent::Base
  def initialize(requests, caption)
    @requests = requests
    @caption = caption
  end

  def count
    @requests.present? ? @requests.size : 0
  end
end
