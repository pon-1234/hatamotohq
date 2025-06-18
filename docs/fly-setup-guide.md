# Fly.io Setup Guide

## Prerequisites

1. Install Fly CLI:
   ```bash
   curl -L https://fly.io/install.sh | sh
   ```

2. Login to Fly.io:
   ```bash
   fly auth login
   ```

## Create Applications

### Development Environment

```bash
# Create app
fly apps create hatamotohq-dev --org your-org

# Create PostgreSQL database
fly postgres create --name hatamotohq-dev-db --region nrt --vm-size dedicated-cpu-1x --volume-size 10

# Attach database to app
fly postgres attach hatamotohq-dev-db --app hatamotohq-dev

# Create Redis instance
fly apps create hatamotohq-dev-redis --org your-org
fly deploy --app hatamotohq-dev-redis --image flyio/redis:7
```

### Staging Environment

```bash
# Create app
fly apps create hatamotohq-staging --org your-org

# Create PostgreSQL database
fly postgres create --name hatamotohq-staging-db --region nrt --vm-size dedicated-cpu-1x --volume-size 20

# Attach database to app
fly postgres attach hatamotohq-staging-db --app hatamotohq-staging

# Create Redis instance
fly apps create hatamotohq-staging-redis --org your-org
fly deploy --app hatamotohq-staging-redis --image flyio/redis:7
```

## Configure Secrets

### Required Environment Variables

Create a `.env.fly.development` file with your development environment variables:

```bash
RAILS_ENV=development
DATABASE_URL=postgres://... # Will be set automatically by Fly.io
REDIS_URL=redis://hatamotohq-dev-redis.internal:6379/0
SECRET_KEY_BASE=your-secret-key
LINE_CHANNEL_ID=your-line-channel-id
LINE_CHANNEL_SECRET=your-line-channel-secret
LINE_CHANNEL_ACCESS_TOKEN=your-access-token
AWS_ACCESS_KEY_ID=your-aws-key
AWS_SECRET_ACCESS_KEY=your-aws-secret
AWS_S3_BUCKET=your-s3-bucket
```

Set secrets for development:
```bash
fly secrets import < .env.fly.development --app hatamotohq-dev
```

Repeat for staging with `.env.fly.staging`.

## Deploy

### First Deployment

```bash
# Deploy to development
fly deploy --config fly.development.toml --app hatamotohq-dev

# Deploy to staging
fly deploy --config fly.staging.toml --app hatamotohq-staging
```

### Database Migration

The deployment process automatically runs migrations via the `release_command` in fly.toml.

To run migrations manually:
```bash
fly ssh console --app hatamotohq-dev -C "rails db:migrate"
```

## Monitoring and Debugging

### View Logs
```bash
fly logs --app hatamotohq-dev
fly logs --app hatamotohq-staging
```

### SSH into Container
```bash
fly ssh console --app hatamotohq-dev
```

### Rails Console
```bash
fly ssh console --app hatamotohq-dev -C "rails console"
```

### Check Application Status
```bash
fly status --app hatamotohq-dev
```

### Scale Resources
```bash
# Scale web processes
fly scale count web=2 worker=1 --app hatamotohq-dev

# Scale VM size
fly scale vm dedicated-cpu-1x --memory 2048 --app hatamotohq-dev
```

## Troubleshooting

### Common Issues

1. **Database Connection Failed**
   - Check DATABASE_URL is set correctly
   - Verify database is running: `fly status --app hatamotohq-dev-db`

2. **Asset Compilation Failed**
   - Increase memory during deployment
   - Check Node.js version compatibility

3. **Health Check Failed**
   - Verify `/health` endpoint is accessible
   - Check application logs for startup errors

### Rollback Deployment
```bash
fly releases --app hatamotohq-dev
fly deploy --app hatamotohq-dev --image registry.fly.io/hatamotohq-dev@sha256:previous-image-sha
```