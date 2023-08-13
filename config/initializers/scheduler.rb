require "rufus-scheduler"
require "rake"

Rake.load_rakefile(Rails.root.join("Rakefile"))

# Do not schedule if Rails is run from the console, a test/spec or a Rake task
return if defined?(Rails::Console) || Rails.env.test? || File.split($PROGRAM_NAME).last == "rake"

# Generate a lockfile in the tmp directory to prevent multiple instances of the scheduler from running
scheduler = Rufus::Scheduler.singleton(lockfile: File.join(ENV.fetch("BLACKLIGHT_TMP_PATH", "./tmp"), ".rufus-scheduler.lock"))

def scheduler.on_error(job, error)
  Rails.logger.error(
    "err#{error.object_id} rufus-scheduler intercepted #{error.inspect} in job #{job.inspect}"
  )
  error.backtrace.each_with_index do |line, i|
    Rails.logger.error(
      "err#{error.object_id} #{i}: #{line}"
    )
  end
  Rails.logger.flush
end

# This will return a CronJob model and starts 15 minutes after it's first scheduled, to allow for the system
# to process migrations and warm up.
scheduler.cron "59 1 * * *", name: "db:sessions:trim", overlap: false, first_at: 6.hours.from_now do |job|
  Rails.logger.info("Starting schedule '#{job.name}': Trimming database sessions older than 30 days")
  Rails.logger.info("Last run at #{job.previous_time}. Next run will be around #{job.next_time}.")
  Rake::Task["db:sessions:trim"].invoke
  Rake::Task["db:sessions:trim"].reenable
  Rails.logger.flush
end
