# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

SolrWrapper.default_instance_options = {
  verbose: true,
  cloud: true,
  port: '8888',
  version: '5.3.1',
  instance_dir: 'solr',
  download_dir: 'tmp'
}

require "solr_wrapper/rake_task" unless Rails.env.production? || Rails.env.staging?
