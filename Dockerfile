FROM ruby:3.3.6-alpine

ENV APP_PATH /var/app
ENV BUNDLE_VERSION 2.5.23
ENV BUNDLE_PATH /usr/local/bundle/gems
ENV TMP_PATH /tmp/
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_PORT 8080
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
&& npm install -g yarn@1.22.22 \
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

# Build frontend assets with Vite
RUN NODE_OPTIONS="--max-old-space-size=4096" npm run build

# Build CSS
RUN npm run build:css

EXPOSE $RAILS_PORT

# Use the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default command is to start Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]