# frozen_string_literal: true

namespace "db:sessions" do
  desc "Trim old sessions in batches to avoid long-running queries (default: > 30 days, batch size: 10000)"
  task trim_in_batches: :environment do
    cutoff_days = (ENV["SESSION_DAYS_TRIM_THRESHOLD"] || 30).to_i
    cutoff_days = 30 if cutoff_days <= 0

    cutoff = cutoff_days.days.ago

    batch_size = (ENV["SESSION_TRIM_BATCH_SIZE"] || 10_000).to_i
    batch_size = 10_000 if batch_size <= 0

    sleep_interval = (ENV["SESSION_TRIM_SLEEP_SECONDS"] || 0.5).to_f
    sleep_interval = 0.5 if sleep_interval <= 0

    session_class = ActionDispatch::Session::ActiveRecordStore.session_class
    total_deleted = 0

    puts "Session cleanup: deleting sessions older than #{cutoff_days} days (before #{cutoff}) in batches of #{batch_size}"
    Rails.logger.info "Session cleanup: deleting sessions older than #{cutoff_days} days (before #{cutoff}) in batches of #{batch_size}"

    loop do
      deleted = session_class.where(updated_at: ...cutoff).limit(batch_size).delete_all
      total_deleted += deleted
      puts "Session cleanup: deleted #{deleted} rows (#{total_deleted} total so far)"
      Rails.logger.info "Session cleanup: deleted #{deleted} rows (#{total_deleted} total so far)"
      break if deleted < batch_size
      sleep(sleep_interval)
    end

    puts "Session cleanup complete: #{total_deleted} rows deleted"
    Rails.logger.info "Session cleanup complete: #{total_deleted} rows deleted"
  end
end
