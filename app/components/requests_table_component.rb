# frozen_string_literal: true

class RequestsTableComponent < ViewComponent::Base
  def initialize(requests, caption, no_requests_message = nil)
    @requests = requests
    @caption = caption
    @no_requests_message = no_requests_message
  end

  def count
    @requests.present? ? @requests.size : 0
  end
end
