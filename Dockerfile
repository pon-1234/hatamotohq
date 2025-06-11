FROM ruby:2.6.3-alpine

ENV APP_PATH /var/app
ENV BUNDLE_VERSION 2.2.14
ENV BUNDLE_PATH /usr/local/bundle/gems
ENV TMP_PATH /tmp/
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_PORT 3000
ENV RAILS_ENV production

# copy entrypoint scripts and grant execution permissions
COPY ./script/docker-entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# install dependencies for application
RUN apk -U add --no-cache \
build-base \
git \
postgresql-dev \
postgresql-client \
libxml2-dev \
libxslt-dev \
imagemagick \
tzdata \
less \
&& rm -rf /var/cache/apk/* \
&& mkdir -p $APP_PATH

# Install Node.js and Yarn - use current Alpine packages
RUN apk add --no-cache nodejs npm \
&& npm install -g yarn \
&& node --version 

RUN gem install bundler --version "$BUNDLE_VERSION" \
&& rm -rf $GEM_HOME/cache/*

# navigate to app directory
WORKDIR $APP_PATH

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle config set --local deployment 'true' \
&& bundle config set --local without 'development test' \
&& bundle install --jobs=4 --retry=3 \
&& rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git \
&& bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Install JavaScript dependencies 
RUN yarn install --ignore-engines

# Skip asset precompilation during build - will be done at runtime
# RUN NODE_OPTIONS="--max-old-space-size=4096" SECRET_KEY_BASE=dummy_key_for_precompile RAILS_ENV=production bundle exec rails assets:precompile

# Create a script to run db:migrate and then start the server
RUN echo '#!/bin/sh' > /usr/local/bin/start-server.sh \
&& echo 'set -e' >> /usr/local/bin/start-server.sh \
&& echo 'echo "Running database migrations..."' >> /usr/local/bin/start-server.sh \
&& echo 'bundle exec rails db:migrate' >> /usr/local/bin/start-server.sh \
&& echo 'echo "Starting Rails server..."' >> /usr/local/bin/start-server.sh \
&& echo 'exec bundle exec rails server -p $RAILS_PORT -b 0.0.0.0' >> /usr/local/bin/start-server.sh \
&& chmod +x /usr/local/bin/start-server.sh

EXPOSE $RAILS_PORT

CMD ["/usr/local/bin/start-server.sh"]