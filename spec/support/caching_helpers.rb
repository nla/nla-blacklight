# frozen_string_literal: true

module CachingHelpers
  def file_caching_path
    path = "#{ENV["BLACKLIGHT_TMP_PATH"]}/cache"
    FileUtils.mkdir_p(path)

    path
  end
end
