pipeline {
  agent { docker { image 'registry.access.redhat.com/ubi8/ruby-30' } }
  environment {
    RAILS_ENV = 'test'
    CI = true
    DATABASE_URL = 'sqlite3::db/test.sqlite3:'
    DISABLE_SPRING = true
    SOLR_URL = 'http://delong.nla.gov.au:10001/solr/blacklight'
    IMAGE_SERVICE_URL = 'https://catalogue.nla.gov.au/fcgi-bin/nlathumb.fcgi?id=%s'
    BLACKLIGHT_TMP_PATH = './tmp'
    BUNDLE_APP_CONFIG = '.bundle'
    BUNDLE_JOBS = 4
    BUNDLE_RETRY = 3
    BUNDLE_PATH = 'vendor/bundle'
    BUNDLE_FORCE_RUBY_PLATFORM = true
  }
  stages {
    stage('Build') {
      steps {
        sh 'bundle check || bundle install'
      }
    }
    stage("Tests") {
      steps {
        sh 'bin/ci'
      }
    }
  }
}
