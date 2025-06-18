#!/bin/bash

# Fly.io Setup Script for HatamotoHQ
# This script automates the creation of Fly.io applications for dev/staging environments

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
FLY_ORG="${FLY_ORG:-personal}"  # Default to personal org
REGION="nrt"  # Tokyo region

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if fly CLI is installed
check_fly_cli() {
    if ! command -v fly &> /dev/null; then
        print_error "Fly CLI is not installed"
        print_info "Install it with: curl -L https://fly.io/install.sh | sh"
        exit 1
    fi
    print_status "Fly CLI is installed"
}

# Check if logged in to Fly.io
check_fly_auth() {
    if ! fly auth whoami &> /dev/null; then
        print_error "Not logged in to Fly.io"
        print_info "Please run: fly auth login"
        exit 1
    fi
    local user=$(fly auth whoami)
    print_status "Logged in as: $user"
}

# Create app if it doesn't exist
create_app() {
    local app_name=$1
    local env=$2
    
    print_info "Checking if app '$app_name' exists..."
    
    if fly apps list | grep -q "^$app_name"; then
        print_warning "App '$app_name' already exists"
    else
        print_info "Creating app '$app_name'..."
        fly apps create "$app_name" --org "$FLY_ORG"
        print_status "App '$app_name' created"
    fi
}

# Create PostgreSQL database
create_postgres() {
    local db_name=$1
    local env=$2
    local size=$3
    
    print_info "Checking if PostgreSQL '$db_name' exists..."
    
    if fly apps list | grep -q "^$db_name"; then
        print_warning "PostgreSQL '$db_name' already exists"
    else
        print_info "Creating PostgreSQL database '$db_name'..."
        fly postgres create \
            --name "$db_name" \
            --region "$REGION" \
            --vm-size "shared-cpu-1x" \
            --volume-size "$size" \
            --initial-cluster-size 1
        print_status "PostgreSQL '$db_name' created"
    fi
}

# Attach database to app
attach_database() {
    local app_name=$1
    local db_name=$2
    
    print_info "Attaching database '$db_name' to app '$app_name'..."
    fly postgres attach "$db_name" --app "$app_name" || true
    print_status "Database attached"
}

# Create Redis instance
create_redis() {
    local redis_name=$1
    local env=$2
    
    print_info "Checking if Redis '$redis_name' exists..."
    
    if fly apps list | grep -q "^$redis_name"; then
        print_warning "Redis '$redis_name' already exists"
    else
        print_info "Creating Redis instance '$redis_name'..."
        # Create Redis app
        fly apps create "$redis_name" --org "$FLY_ORG"
        
        # Create fly.toml for Redis
        cat > /tmp/fly-redis-$redis_name.toml <<EOF
app = "$redis_name"
primary_region = "$REGION"

[build]
  image = "flyio/redis:7-alpine"

[[services]]
  internal_port = 6379
  protocol = "tcp"

  [[services.ports]]
    port = 6379

[mounts]
  destination = "/data"
  source = "redis_data"

[[vm]]
  cpu_kind = "shared"
  cpus = 1
  memory_mb = 256
EOF
        
        # Deploy Redis
        fly deploy --config /tmp/fly-redis-$redis_name.toml --app "$redis_name"
        
        # Create volume for Redis data
        fly volumes create redis_data --size 1 --app "$redis_name" --region "$REGION" || true
        
        print_status "Redis '$redis_name' created"
        
        # Clean up temp file
        rm -f /tmp/fly-redis-$redis_name.toml
    fi
}

# Set up secrets from .env file
setup_secrets() {
    local app_name=$1
    local env_file=$2
    
    if [ ! -f "$env_file" ]; then
        print_warning "Environment file '$env_file' not found"
        print_info "Please create $env_file with your environment variables"
        return
    fi
    
    print_info "Setting up secrets for '$app_name' from '$env_file'..."
    
    # Use the env_to_fly_secrets.rb script if available
    if [ -f "./scripts/env_to_fly_secrets.rb" ]; then
        print_info "Generating Fly secrets commands..."
        ./scripts/env_to_fly_secrets.rb "$env_file" "$app_name"
    else
        print_info "Importing secrets directly..."
        fly secrets import < "$env_file" --app "$app_name"
    fi
    
    print_status "Secrets configured"
}

# Create volume for storage
create_storage_volume() {
    local app_name=$1
    local size=$2
    
    print_info "Creating storage volume for '$app_name'..."
    fly volumes create storage --size "$size" --app "$app_name" --region "$REGION" || true
    print_status "Storage volume created"
}

# Main setup function
setup_environment() {
    local env=$1
    
    echo
    echo "========================================="
    echo "Setting up Fly.io $env environment"
    echo "========================================="
    echo
    
    local app_name="hatamotohq-$env"
    local db_name="hatamotohq-$env-db"
    local redis_name="hatamotohq-$env-redis"
    local env_file=".env.$env"
    
    # Determine sizes based on environment
    local db_size=10
    local storage_size=5
    if [ "$env" = "staging" ]; then
        db_size=20
        storage_size=10
    fi
    
    # Create main app
    create_app "$app_name" "$env"
    
    # Create PostgreSQL
    create_postgres "$db_name" "$env" "$db_size"
    
    # Attach database
    attach_database "$app_name" "$db_name"
    
    # Create Redis
    create_redis "$redis_name" "$env"
    
    # Create storage volume
    create_storage_volume "$app_name" "$storage_size"
    
    # Set up secrets
    setup_secrets "$app_name" "$env_file"
    
    echo
    print_status "Environment setup complete!"
    echo
    print_info "Next steps:"
    print_info "1. Create $env_file with your environment variables"
    print_info "2. Run: fly deploy --config fly.$env.toml --app $app_name"
    print_info "3. Check status: fly status --app $app_name"
    echo
}

# Main menu
show_menu() {
    echo "================================"
    echo "Fly.io Setup for HatamotoHQ"
    echo "================================"
    echo "1) Setup Development Environment"
    echo "2) Setup Staging Environment"
    echo "3) Setup Both Environments"
    echo "4) Check Status"
    echo "5) Exit"
}

# Check prerequisites
print_info "Checking prerequisites..."
check_fly_cli
check_fly_auth

# Main script
while true; do
    show_menu
    read -p "Select an option: " choice
    
    case $choice in
        1)
            setup_environment "development"
            ;;
        2)
            setup_environment "staging"
            ;;
        3)
            setup_environment "development"
            setup_environment "staging"
            ;;
        4)
            print_info "Current Fly.io apps:"
            fly apps list
            ;;
        5)
            print_info "Exiting..."
            exit 0
            ;;
        *)
            print_error "Invalid option"
            ;;
    esac
    
    echo
    read -p "Press Enter to continue..."
    clear
done