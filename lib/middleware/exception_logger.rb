module Middleware
  class ExceptionLogger
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue => exception
      Rails.logger.error "EXCEPTION: #{exception.class.name} - #{exception.message}"
      Rails.logger.error exception.backtrace.join("\n")
      raise exception
    end
  end
end
