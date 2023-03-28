# frozen_string_literal: true

module BentoQueryConcern
  extend ActiveSupport::Concern

  included do
    before_action :start_request
    after_action :finish_request

    def start_request
      @context ||= {pool: Concurrent::CachedThreadPool.new}
    end

    def finish_request
      @context[:pool].shutdown
      @context[:pool].wait_for_termination
    end
  end
end
