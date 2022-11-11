class ErrorsController < ApplicationController
  def not_found
    @exception = request.env["action_dispatch.exception"]
    render status: :not_found
  end

  def internal_server
    render status: :internal_server_error
  end

  def unprocessable
    render status: :unprocessable_entity
  end

  def unavailable
    render status: :service_unavailable
  end
end
