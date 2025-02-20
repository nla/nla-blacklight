#!/bin/bash

ORIGDIR=$(pwd)
export ORIGDIR
source ~/.bashrc

export GEM_HOME=$ORIGDIR/gems
export GEM_PATH=$ORIGDIR/gems

echo "Build env $RAILS_ENV, unzip into $WEBROOT.. PWD $ORIGDIR"
export PATH=$GEM_PATH/bin:$PATH
export http_proxy=admin.nla.gov.au:3128
export https_proxy=admin.nla.gov.au:3128
cd "$ORIGDIR" || return

echo "Updating ruby-build"
git -C /apps/etc/.rbenv/plugins/ruby-build pull

RUBY_VERSION=$(cat .ruby-version)
echo "Checking rbenv Ruby version $RUBY_VERSION is installed."
if [[ ! -d "/apps/etc/.rbenv/versions/$RUBY_VERSION" ]]; then
  echo "Ruby $RUBY_VERSION is not installed. Installing with rbenv..."
  rbenv install "$RUBY_VERSION"
  echo "Finished installing Ruby $RUBY_VERSION; continuing deployment..."
else
  echo "Ruby $RUBY_VERSION found; continuing deployment..."
fi

# update system gems
gem update --system

gem install bundler
bundle config --local jobs $(nproc)
bundle config --local path "vendor/bundle"
bundle config set force_ruby_platform true

if [[ "$RAILS_ENV" == "staging" || "$RAILS_ENV" == "production" ]]; then
 bundle config --local without "development:test"
fi

bundle install
RAILS_ENV=$RAILS_ENV bundle exec rails db:migrate

# clear the external asset cache
RAILS_ENV=$RAILS_ENV bundle exec rails assets:clobber

RAILS_ENV=$RAILS_ENV bundle exec rails assets:precompile
if [[ "$RAILS_CACHE_DEV" == "y" ]]; then
  RAILS_ENV=$RAILS_ENV bundle exec rails dev:cache
fi

# try to fix permissions in vendor/bundle
chmod -R o+r ./vendor/bundle

mkdir -p "$BLACKLIGHT_TMP_PATH"/pids

# Using file cache, so tmp:clear will also clear the cache
RAILS_ENV=$RAILS_ENV bundle exec rails log:clear tmp:clear
# Clear the Redis cache
redis-cli -n 0 KEYS "blacklight:*" | xargs redis-cli -n 0 DEL

# Remove a potentially pre-existing server.pid for Rails.
rm -f "$PIDFILE"

cp -R .bundle .ruby-version ./** "$1"
