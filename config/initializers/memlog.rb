# frozen_string_literal: true

# Thread.new do
#   File.unlink(File.join(ENV.fetch("BLACKLIGHT_TMP_PATH", "./tmp"), "mem_log.txt"))
#   logger = Logger.new(File.join(ENV.fetch("BLACKLIGHT_TMP_PATH", "./tmp"), "mem_log.txt"))
#   logger.formatter = proc { |sev, date, prog, msg|
#     msg
#   }
#   headers = [
#     "RSS",
#     "Live slots",
#     "Free slots",
#     ObjectSpace.count_objects.keys
#   ].flatten
#   logger.info headers.join(",")
#   loop do
#     pid = Process.pid
#     rss = `ps -eo pid,rss | grep #{pid} | awk '{print $2}'`
#     memory_info = [
#       rss.strip,
#       GC.stat[:heap_live_slots],
#       GC.stat[:heap_free_slots],
#       ObjectSpace.count_objects.values
#     ].flatten
#     logger.info memory_info.join(",")
#     logger.info "\n"
#     sleep 5
#   end
# end
