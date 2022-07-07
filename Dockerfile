FROM registry.access.redhat.com/ubi8/ruby-30

USER 0

WORKDIR /opt/app-root/src

# Common dependencies
RUN /bin/bash -c 'yum install -y -q -e 0 redhat-lsb-core && rm -rf /var/cache/yum'

# Install NodeJS and Yarn
RUN npm install -g yarn

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLE_APP_CONFIG=.bundle \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3 \
  BUNDLE_PATH='vendor/bundle' \
  BUNDLE_FORCE_RUBY_PLATFORM=true

# Configure Rails
ENV RAILS_ENV=production \
  RAILS_LOG_TO_STDOUT=true \
  RAILS_SERVE_STATIC_FILES=true

ENV DATABASE_URL='mysql2:does_not_exist'

# Copy the application source to the container
ADD . /opt/app-root/src
RUN bundle config --global frozen 1
RUN bundle install --without development test
RUN bin/rails assets:precompile

EXPOSE 3000

CMD ["bin/rails", "server", "--binding=0.0.0.0", "--port=3000"]
