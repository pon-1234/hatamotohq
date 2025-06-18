# Fly.io Deployment Checklist

## Pre-Deployment Checklist

### 1. Local Setup
- [ ] Install Fly CLI: `curl -L https://fly.io/install.sh | sh`
- [ ] Login to Fly.io: `fly auth login`
- [ ] Verify organization: `fly orgs list`

### 2. Environment Preparation
- [ ] Copy `.env.development.example` to `.env.development`
- [ ] Copy `.env.staging.example` to `.env.staging`
- [ ] Fill in all required environment variables
- [ ] Generate SECRET_KEY_BASE: `rails secret`

### 3. Run Setup Script
```bash
./scripts/fly_setup.sh
```

This will:
- Create Fly.io applications
- Set up PostgreSQL databases
- Configure Redis instances
- Create storage volumes
- Set environment variables

## Deployment Steps

### Development Environment

1. **Initial Setup**
   ```bash
   # Run the setup script and choose option 1
   ./scripts/fly_setup.sh
   ```

2. **Configure Secrets**
   ```bash
   # Import environment variables
   fly secrets import < .env.development --app hatamotohq-dev
   ```

3. **Deploy Application**
   ```bash
   fly deploy --config fly.development.toml --app hatamotohq-dev
   ```

4. **Migrate Database**
   ```bash
   # Run from existing server
   ./scripts/database_migration.sh
   # Choose option 7 for full development migration
   ```

5. **Verify Deployment**
   ```bash
   fly status --app hatamotohq-dev
   fly logs --app hatamotohq-dev
   ```

### Staging Environment

Repeat the above steps with:
- Use `.env.staging` instead of `.env.development`
- Use `hatamotohq-staging` instead of `hatamotohq-dev`
- Use `fly.staging.toml` instead of `fly.development.toml`
- Choose option 8 in migration script for staging

## Post-Deployment Verification

### 1. Health Check
```bash
curl https://hatamotohq-dev.fly.dev/health
```

Expected response:
```json
{
  "status": "ok",
  "timestamp": "2025-06-18T...",
  "version": "7.2.1",
  "checks": {
    "database": {"status": "ok"},
    "redis": {"status": "ok"}
  }
}
```

### 2. Application Access
- Development: https://hatamotohq-dev.fly.dev
- Staging: https://hatamotohq-staging.fly.dev

### 3. Background Jobs
```bash
# Check Sidekiq is running
fly ssh console --app hatamotohq-dev -C "ps aux | grep sidekiq"
```

### 4. Logs Monitoring
```bash
# Real-time logs
fly logs --app hatamotohq-dev

# Filter by process
fly logs --app hatamotohq-dev | grep worker
```

## Troubleshooting

### Common Issues

1. **Database Connection Failed**
   ```bash
   # Check database status
   fly status --app hatamotohq-dev-db
   
   # Get connection string
   fly postgres db-url --app hatamotohq-dev-db
   ```

2. **Redis Connection Failed**
   ```bash
   # Check Redis status
   fly status --app hatamotohq-dev-redis
   
   # Test connection
   fly ssh console --app hatamotohq-dev -C "redis-cli -h hatamotohq-dev-redis.internal ping"
   ```

3. **Asset Compilation Error**
   ```bash
   # SSH into container
   fly ssh console --app hatamotohq-dev
   
   # Manually compile assets
   bundle exec rails assets:precompile
   ```

4. **Migration Failed**
   ```bash
   # Run migrations manually
   fly ssh console --app hatamotohq-dev -C "rails db:migrate"
   ```

## Rollback Procedure

1. **List releases**
   ```bash
   fly releases --app hatamotohq-dev
   ```

2. **Rollback to previous version**
   ```bash
   fly deploy --app hatamotohq-dev --image registry.fly.io/hatamotohq-dev@sha256:[previous-sha]
   ```

## Monitoring Commands

```bash
# Application metrics
fly metrics --app hatamotohq-dev

# Database metrics
fly metrics --app hatamotohq-dev-db

# SSH access
fly ssh console --app hatamotohq-dev

# Rails console
fly ssh console --app hatamotohq-dev -C "rails console"

# Database console
fly postgres connect --app hatamotohq-dev-db
```

## Security Checklist

- [ ] All secrets are set via `fly secrets`
- [ ] SSL is enforced (FORCE_SSL=true)
- [ ] Database credentials are not hardcoded
- [ ] API keys are properly secured
- [ ] No sensitive data in logs

## Final Steps

1. **Update DNS Records**
   - Point development subdomain to Fly.io
   - Point staging subdomain to Fly.io

2. **Update Webhooks**
   - Update LINE webhook URLs
   - Update any third-party service callbacks

3. **Monitor for 24 hours**
   - Check application logs
   - Monitor error rates
   - Verify background jobs

4. **Decommission Old Servers**
   - Take final backups
   - Stop old services
   - Terminate instances