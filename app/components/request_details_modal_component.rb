# frozen_string_literal: true

class RequestDetailsModalComponent < ViewComponent::Base

  renders_one :trigger
  renders_one :modal

  def initialize(request_details)
    @request_details = request_details
  end
end
