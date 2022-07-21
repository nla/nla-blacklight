#!/bin/bash

ORIGDIR=$(pwd)
export ORIGDIR

echo "Build env $RAILS_ENV, unzip into $WEBROOT.. PWD $ORIGDIR"
export PATH=$GEM_PATH/bin:$PATH
export http_proxy=admin.nla.gov.au:3128
export https_proxy=admin.nla.gov.au:3128
cd "$ORIGDIR" || return

RUBY_VERSION=$(cat .ruby-version)
echo "Checking rbenv Ruby version $RUBY_VERSION is installed."
if [[ ! -d "/apps/etc/.rbenv/versions/$RUBY_VERSION" ]]; then
  echo "Ruby $RUBY_VERSION is not installed. Installing with rbenv..."
  rbenv install "$RUBY_VERSION"
  echo "Finished installing Ruby $RUBY_VERSION; continuing deployment..."
else
  echo "Ruby $RUBY_VERSION found; continuing deployment..."
fi

gem install bundler -v 2.2.22
bundle config --local job $(nproc)
bundle config --local path "vendor/bundle"
bundle config --local force_ruby_platform true

bundle _2.2.22_ install
RAILS_ENV=$RAILS_ENV bundle _2.2.22_ exec rails db:migrate
RAILS_ENV=$RAILS_ENV bundle _2.2.22_ exec rails assets:precompile

mkdir -p "$BLACKLIGHT_TMP_PATH"/pids

RAILS_ENV=$RAILS_ENV bundle _2.2.22_ exec rails log:clear tmp:clear

# Remove a potentially pre-existing server.pid for Rails.
rm -f "$PIDFILE"

cp -R .bundle .ruby-version ./** "$1"
