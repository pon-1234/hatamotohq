# HatamotoHQ

HatamotoHQ is a LINE Bot Management Platform - a multi-tenant SaaS application for managing LINE messaging bot accounts.

## Requirements

- Ruby version: 3.3.6
- Rails version: 7.2.1
- Node.js: 18.x or higher
- npm: 8.x or higher
- Database: PostgreSQL
- Redis (for Sidekiq background jobs)

## System Dependencies

- ffmpeg (for media processing)
- imagemagick (for image processing)

## Setup

### Database Setup

```bash
# Complete database refresh (drops, creates, migrates, seeds)
rails db:refresh

# Or run individually:
rails db:create
rails db:migrate
rails db:seed
```

### Frontend Setup

```bash
# Install JavaScript dependencies
npm install

# Build assets for production
npm run build
npm run build:css

# Or use Foreman to start all services
foreman start -f Procfile.dev
```

## Development

### Running the Application

```bash
# Start Rails server
rails server

# In another terminal, start Sidekiq for background jobs
sidekiq

# For frontend development with hot reloading (Vite)
npm run dev

# Or run all development services
foreman start -f Procfile.dev
```

### Running Tests

```bash
# Run full test suite
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/user_spec.rb

# Run specific test
bundle exec rspec spec/models/user_spec.rb:25
```

## Background Jobs

The application uses Sidekiq for background job processing. Key scheduled workers include:
- DispatchBroadcastWorker (runs every minute)
- DispatchScenarioEventWorker (runs every minute)
- DispatchReminderEventWorker (runs every minute)
- DailySyncFriendsWorker (runs daily at 3 AM)

Monitor jobs via Sidekiq web UI (typically http://localhost:3000/sidekiq)

## Deployment

```bash
# Deploy to staging
cap staging deploy

# Deploy to production
cap production deploy
```

## Architecture

The application uses subdomain-based multi-tenancy with three user types:
- **Admin** (`admin.domain.com`) - Platform administrators
- **Agency** (`agency.domain.com`) - Agencies managing multiple clients
- **User** (`client.domain.com`) - Individual LINE bot account owners

For more detailed information, see [CLAUDE.md](CLAUDE.md)
