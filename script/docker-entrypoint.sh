#!/bin/sh

set -e

echo "Environment: $RAILS_ENV"

# Remove pre-existing puma/passenger server.pid
rm -f $APP_PATH/tmp/pids/server.pid

# Clear Rails cache to ensure fresh manifest
if [ "$RAILS_ENV" = "production" ]; then
  echo "Clearing Rails cache..."
  rm -rf $APP_PATH/tmp/cache/*
fi

# Execute the command passed to the container
exec "$@"