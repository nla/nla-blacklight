# frozen_string_literal: true

return unless Rails.env.production? || Rails.env.staging?

require "rufus/scheduler"

scheduler = Rufus::Scheduler.new

cron_schedule = ENV.fetch("SESSION_CLEANUP_CRON", "0 * * * *")

scheduler.cron(cron_schedule) do
  begin
    Rails.logger.info "Starting scheduled session cleanup"
    Rake::Task["db:sessions:trim_in_batches"].invoke
    Rails.logger.info "Scheduled session cleanup completed"
  rescue => e
    Rails.logger.error "Session cleanup failed: #{e.message}"
  end
end
