# frozen_string_literal: true

class AccountController < ApplicationController
  before_action :authenticate_user!

  # :nocov:
  def requests
    @requests = {
      readyForCollection: [],
      itemsRequested: [],
      notAvailable: [],
      previousRequests: [],
      numRequestsRemaining: 999
    }
  end
  # :nocov:
end
