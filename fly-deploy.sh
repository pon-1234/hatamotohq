#!/bin/bash
set -e

echo "🚀 Fly.io Deployment Script for HatamotoHQ"
echo "=========================================="

# Check if fly CLI is installed
if ! command -v fly &> /dev/null; then
    echo "❌ fly CLI is not installed. Please install it first:"
    echo "   curl -L https://fly.io/install.sh | sh"
    exit 1
fi

# Check if master.key exists
if [ ! -f "config/master.key" ]; then
    echo "❌ config/master.key not found!"
    echo "   Please create it or retrieve it from another developer/backup"
    echo "   Example: echo 'your-32-char-hex-key' > config/master.key"
    exit 1
fi

echo "✅ Prerequisites check passed"
echo ""

# Function to check if app exists
app_exists() {
    fly apps list | grep -q "^$1"
}

# Function to check if postgres exists
postgres_exists() {
    fly postgres list | grep -q "$1"
}

# Function to check if redis exists
redis_exists() {
    fly redis list | grep -q "$1"
}

APP_NAME="hatamotohq"
DB_NAME="hatamotohq-db"
REDIS_NAME="hatamotohq-redis"
REGION="nrt"

echo "📋 Configuration:"
echo "  App Name: $APP_NAME"
echo "  Region: $REGION"
echo "  Database: $DB_NAME"
echo "  Redis: $REDIS_NAME"
echo ""

# Create app if it doesn't exist
if app_exists "$APP_NAME"; then
    echo "✅ App $APP_NAME already exists"
else
    echo "📦 Creating app $APP_NAME..."
    fly apps create "$APP_NAME" --org personal
fi

# Create PostgreSQL if it doesn't exist
if postgres_exists "$DB_NAME"; then
    echo "✅ PostgreSQL $DB_NAME already exists"
else
    echo "🗄️  Creating PostgreSQL database..."
    fly postgres create --name "$DB_NAME" --region "$REGION" --initial-cluster-size 1 --vm-size shared-cpu-1x --volume-size 1
    echo "⏳ Waiting for database to be ready..."
    sleep 10
fi

# Attach PostgreSQL
echo "🔗 Attaching PostgreSQL to app..."
fly postgres attach "$DB_NAME" --app "$APP_NAME" || echo "  Already attached"

# Create Redis if it doesn't exist
if redis_exists "$REDIS_NAME"; then
    echo "✅ Redis $REDIS_NAME already exists"
else
    echo "💾 Creating Redis instance..."
    fly redis create --name "$REDIS_NAME" --region "$REGION" --no-replicas
    echo "⏳ Waiting for Redis to be ready..."
    sleep 10
fi

# Create volume for Active Storage
echo "💿 Creating storage volume..."
fly volumes create hatamotohq_storage --size 10 --region "$REGION" --app "$APP_NAME" || echo "  Volume already exists"

# Set secrets
echo ""
echo "🔐 Setting environment variables..."

# Rails secrets
fly secrets set RAILS_MASTER_KEY=$(cat config/master.key) --app "$APP_NAME"

# Application URLs
APP_URL="https://$APP_NAME.fly.dev"
fly secrets set VITE_ROOT_PATH="$APP_URL" --app "$APP_NAME"
fly secrets set VITE_WS_FLEXA_URL="wss://$APP_NAME.fly.dev" --app "$APP_NAME"
fly secrets set VITE_SERVEY_MEDIA_FLEXA_URL="$APP_URL" --app "$APP_NAME"

# Rails settings
fly secrets set RAILS_SERVE_STATIC_FILES=true --app "$APP_NAME"
fly secrets set RAILS_LOG_TO_STDOUT=true --app "$APP_NAME"

echo ""
echo "⚠️  Please set the following secrets manually:"
echo "  fly secrets set LINE_CHANNEL_SECRET=your-value --app $APP_NAME"
echo "  fly secrets set LINE_CHANNEL_TOKEN=your-value --app $APP_NAME"
echo "  fly secrets set VITE_GOOGLE_MAP_KEY=your-value --app $APP_NAME"
echo "  fly secrets set SENTRY_DSN=your-value --app $APP_NAME (optional)"
echo ""

read -p "Have you set the required secrets above? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Please set the required secrets and run this script again"
    exit 1
fi

# Deploy
echo ""
echo "🚀 Starting deployment..."
echo "  Running: fly deploy --app $APP_NAME"
echo ""

fly deploy --app "$APP_NAME"

echo ""
echo "✅ Deployment complete!"
echo "🌐 Your app should be available at: $APP_URL"
echo ""
echo "📝 Post-deployment commands:"
echo "  Check status: fly status --app $APP_NAME"
echo "  View logs: fly logs --app $APP_NAME"
echo "  Open app: fly open --app $APP_NAME"
echo "  SSH access: fly ssh console --app $APP_NAME"