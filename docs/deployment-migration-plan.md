# Deployment Migration Plan: Capistrano to Fly.io

## Overview
This document outlines the plan to migrate from the current mixed deployment system (Capistrano for dev/staging, Fly.io for production) to a unified Fly.io deployment across all environments.

## Current State

### Production
- **Platform**: Fly.io
- **Branch**: main
- **Region**: nrt (Tokyo)
- **Deployment**: Automated via GitHub Actions

### Staging  
- **Platform**: GCP VM (104.198.81.172)
- **Branch**: staging
- **User**: dotops
- **Deployment**: Capistrano via GitHub Actions

### Development
- **Platform**: AWS EC2 (18.176.164.49)
- **Branch**: develop
- **User**: deploy
- **Deployment**: Capistrano via GitHub Actions

## Migration Benefits

1. **Unified Platform**: Single deployment method reduces complexity
2. **Container-based**: Consistent environments across dev/staging/prod
3. **Built-in features**: Auto-scaling, health checks, zero-downtime deploys
4. **Cost efficiency**: Pay-per-use model vs. always-on VMs
5. **Better observability**: Built-in metrics and logging

## Migration Plan

### Phase 1: Environment Setup (Week 1)

1. **Create Fly.io apps for each environment**
   ```bash
   fly apps create hatamotohq-dev --org your-org
   fly apps create hatamotohq-staging --org your-org
   ```

2. **Set up PostgreSQL databases**
   ```bash
   fly postgres create --name hatamotohq-dev-db --region nrt
   fly postgres create --name hatamotohq-staging-db --region nrt
   ```

3. **Configure secrets for each environment**
   - Copy .env variables to Fly secrets
   - Set up Rails master key
   - Configure LINE API credentials

### Phase 2: Configuration Updates (Week 1-2)

1. **Create environment-specific fly.toml files**
   - fly.development.toml
   - fly.staging.toml
   - fly.production.toml (update existing)

2. **Update GitHub Actions workflows**
   - Modify dep_dev.yml to deploy to Fly.io
   - Modify dep_stg.yml to deploy to Fly.io
   - Add environment-specific deployment commands

3. **Update Dockerfile**
   - Ensure compatibility with all environments
   - Add environment-specific build args if needed

### Phase 3: Data Migration (Week 2)

1. **Database migration**
   - Export data from current databases
   - Import to Fly.io PostgreSQL instances
   - Test data integrity

2. **File storage migration**
   - Migrate Active Storage files to cloud storage
   - Update storage configuration

### Phase 4: Testing & Validation (Week 3)

1. **Deploy to development first**
   - Test all functionality
   - Verify background jobs (Sidekiq)
   - Check WebSocket connections

2. **Deploy to staging**
   - Run full regression tests
   - Performance testing
   - Security validation

3. **Update DNS and SSL certificates**
   - Point development/staging domains to Fly.io
   - Configure SSL certificates

### Phase 5: Cutover (Week 4)

1. **Final data sync**
2. **Switch DNS for staging/development**
3. **Monitor for 24-48 hours**
4. **Decommission old servers**

## Rollback Plan

1. Keep Capistrano configuration intact during migration
2. Maintain database backups on old servers
3. DNS can be switched back if issues arise
4. Document all changes for quick reversal

## Post-Migration Tasks

1. **Remove Capistrano dependencies**
   - Delete Capfile
   - Remove config/deploy.rb and config/deploy/*
   - Update Gemfile to remove capistrano gems

2. **Update documentation**
   - Update README with new deployment instructions
   - Update CLAUDE.md with Fly.io commands
   - Create runbooks for common operations

3. **Set up monitoring**
   - Configure alerts for each environment
   - Set up log aggregation
   - Performance monitoring

## Success Criteria

- All environments running on Fly.io
- Zero data loss during migration
- No increase in deployment time
- Improved deployment reliability
- Reduced infrastructure costs

## Timeline

- Week 1: Environment setup and configuration
- Week 2: Data migration and testing prep
- Week 3: Testing and validation
- Week 4: Production cutover and cleanup

## Commands Reference

### Deployment
```bash
# Deploy to specific environment
fly deploy --config fly.development.toml --app hatamotohq-dev
fly deploy --config fly.staging.toml --app hatamotohq-staging
fly deploy --config fly.production.toml --app hatamotohq

# View logs
fly logs --app hatamotohq-dev
fly logs --app hatamotohq-staging

# SSH into container
fly ssh console --app hatamotohq-dev

# Run Rails console
fly ssh console --app hatamotohq-dev -C "rails console"

# Run migrations
fly ssh console --app hatamotohq-dev -C "rails db:migrate"
```

### Secrets Management
```bash
# Set secrets
fly secrets set KEY=value --app hatamotohq-dev

# List secrets
fly secrets list --app hatamotohq-dev

# Import from .env file
fly secrets import < .env.development --app hatamotohq-dev
```