#!/bin/bash

export ORIGDIR=`pwd`

echo "Build env $RAILS_ENV, unzip into $WEBROOT.. PWD $ORIGDIR"
export PATH=$GEM_PATH/bin:$PATH

cd $ORIGDIR

RUBY_VERSION=`cat .ruby-version`
echo "Checking rbenv Ruby version $RUBY_VERSION is installed."
if [[ ! -d "/apps/etc/.rbenv/versions/$RUBY_VERSION" ]]; then
  echo "Ruby $RUBY_VERSION is not installed. Installing with rbenv..."
  rbenv install $RUBY_VERSION
  echo "Finished installing Ruby $RUBY_VERSION; continuing deployment..."
else
  echo "Ruby $RUBY_VERSION found; continuing deployment..."
fi

gem install bundler -v 2.1.4
bundle config set path $GEM_HOME

# run yarn check
yarn install --check-files

bundle _2.1.4_ install
bundle _2.1.4_ exec rake db:migrate RAILS_ENV=$RAILS_ENV
RAILS_ENV=$RAILS_ENV bundle _2.1.4_ exec rake assets:precompile

cp -R .bundle .ruby-version .ruby-gemset * $1