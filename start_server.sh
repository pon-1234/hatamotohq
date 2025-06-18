#!/bin/bash
# Rails server startup script

# Initialize rbenv
eval "$(rbenv init -)"

# Set Ruby version
rbenv local 3.3.6

# Start Rails server
echo "Starting Rails server..."
rails server -b 0.0.0.0