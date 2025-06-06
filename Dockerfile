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

# Install Node.js 14 and Yarn
RUN apk add --no-cache curl \
&& curl -fsSL https://deb.nodesource.com/setup_14.x | sh - || true \
&& curl -fsSL https://unofficial-builds.nodejs.org/download/release/v14.21.3/node-v14.21.3-linux-x64-musl.tar.gz | tar -xz -C /tmp \
&& cp -r /tmp/node-v14.21.3-linux-x64-musl/* /usr/local/ \
&& rm -rf /tmp/node-* \
&& npm install -g yarn@1.22.22 \
&& node --version \
&& yarn --version 

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

# Copy package.json and yarn.lock
COPY package.json yarn.lock ./

# Install node modules
RUN yarn install --frozen-lockfile --production \
&& yarn cache clean

# Copy application code
COPY . .

# Precompile assets
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

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