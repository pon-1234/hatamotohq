# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Application Overview

HatamotoHQ is a **LINE Bot Management Platform** - a multi-tenant SaaS application for managing LINE messaging bot accounts. It enables businesses to create, manage, and automate LINE bot interactions including messaging, rich menus, surveys, reservations, and customer engagement campaigns.

## Development Commands

### Database Operations
```bash
# Complete database refresh (drops, creates, migrates, seeds)
rails db:refresh

# Standard operations
rails db:create
rails db:migrate  
rails db:seed
```

### Testing
```bash
# Run full test suite
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/user_spec.rb

# Run specific test
bundle exec rspec spec/models/user_spec.rb:25
```

### Background Jobs
```bash
# Start Sidekiq for background job processing
sidekiq

# Monitor jobs via web UI (typically http://localhost:4567/sidekiq)
```

### Deployment
```bash
# Deploy to staging
cap staging deploy

# Deploy to production  
cap production deploy
```

### Frontend Development
```bash
# Install JavaScript dependencies
npm install --legacy-peer-deps

# Start development servers (Rails + Vite + CSS)
foreman start -f Procfile.dev

# Or start separately:
rails server      # Terminal 1
bin/vite dev      # Terminal 2
npm run watch:css # Terminal 3

# Build for production
npm run build
npm run build:css
```

### Vue 3 Migration Status (2025年1月 - 完了)
- **Build Tool**: Vite (migrated from esbuild)
- **Vue Version**: 3.5.16 (Native mode - @vue/compat removed)
- **Component Status**: 
  - New components: Use `<script setup>` Composition API
  - Existing components: 87 files still using Options API (working fine)
  - Core components (BaseSpinner, BaseDropdown, BaseTabs) migrated to Composition API
- **All Vue 2 libraries successfully migrated to Vue 3 alternatives**

## Technical Stack

### Frontend (Vue 3)
- **Framework**: Vue 3.5.16 (Native mode - no compatibility layer)
- **State Management**: Vuex 4.1.0
- **Build Tool**: Vite
- **CSS**: SCSS with Bootstrap utilities
- **Bundle Size**: ~2.17MB (21% reduction from Vue 2)

### Backend
- **Framework**: Ruby on Rails 7.2.1
- **Ruby Version**: 3.3.6
- **Database**: PostgreSQL
- **Cache/Queue**: Redis + Sidekiq

### Key Frontend Features
- **Component Architecture**: Mix of Options API and Composition API
- **Global Properties**: Filters migrated to global properties (`$formatted_time`, `$formatted_date`, etc.)
- **Custom Components**: BaseModal, BaseTable, BaseForm, BasePagination, BaseDropdown, etc.
- **Validation**: VeeValidate v4 with custom validation components
- **Rich Text**: CKEditor 5 Vue 3 integration

## Architecture Overview

### Multi-Tenant Structure
The application uses **subdomain-based multi-tenancy** with three user types:
- **Admin** (`admin.domain.com`) - Platform administrators
- **Agency** (`agency.domain.com`) - Agencies managing multiple clients  
- **User** (`client.domain.com`) - Individual LINE bot account owners

Each tenant type has separate controllers in `app/controllers/admin/`, `app/controllers/agency/`, and `app/controllers/user/` with corresponding route constraints in `app/constraints/subdomain/`.

### Core Domain Models

**LINE Bot Core:**
- `LineAccount` - Represents LINE bot accounts
- `LineFriend` - Users who follow the LINE bot
- `Channel` - Chat conversations between staff and LINE friends
- `Message` - Individual messages with support for text, media, rich content

**Content Management:**
- `Scenario` - Automated message sequences/campaigns  
- `Template` - Reusable message templates
- `RichMenu` - LINE's interactive bottom menu interface
- `AutoResponse` - Keyword-triggered automatic responses
- `Broadcast` - Mass messaging campaigns

**Customer Engagement:**
- `Survey` - Custom surveys with response collection
- `Reservation` - Hotel/restaurant booking system with PMS integration
- `Review` - Service review collection
- `Reminder` - Scheduled message reminders

### Background Job System

Critical Sidekiq workers run on schedules:
- **DispatchBroadcastWorker** - Sends queued broadcasts (every minute)
- **DispatchScenarioEventWorker** - Processes scenario automation (every minute)  
- **DispatchReminderEventWorker** - Sends scheduled reminders (every minute)
- **DailySyncFriendsWorker** - Syncs LINE friend data (daily 3 AM)

Job classes are in `app/workers/` and `app/jobs/` - workers handle scheduled tasks, jobs handle event-driven processing.

### Frontend Architecture  

**Vue.js Application:**
- Components in `app/javascript/src/components/`
- Page-specific scripts in `app/javascript/src/page/`
- Vuex stores in `app/javascript/src/stores/`
- Real-time chat via ActionCable WebSocket in `app/javascript/src/core/websocket.js`

**Asset Structure:**
- Webpacker configuration in `config/webpack/`
- SCSS stylesheets organized by user type in `app/assets/stylesheets/`
- Shared utilities in `app/javascript/src/core/`

### API Integration

**External APIs:**
- LINE Messaging API services in `app/services/line_api/`
- Google Sheets API services in `app/services/google_api/`
- PMS (Property Management System) services in `app/services/pms/`

**Internal API:**
- Staff mobile API in `app/controllers/api/v1/`
- JWT authentication with `app/models/allowlisted_jwt.rb`
- API validators in `app/validators/api/v1/`

### Key Business Logic

**Webhook Processing:**
- `WebhookHandler` in `app/services/webhook_handler.rb` processes LINE webhook events
- Postback handlers in `app/services/postback/` manage interactive button responses
- Message normalization in `app/services/normalizer/`

**Message Building:**
- `MessageBuilder` in `app/builders/messages/` constructs complex message payloads
- Flex message templates stored in `FlexTemplate` model
- Rich content rendering with template variables

### Authorization

Uses CanCanCan with separate ability classes:
- `AdminAbility` for admin users
- `AgencyAbility` for agency users  
- `UserAbility` for regular users

### File Storage

Active Storage configuration for media files:
- Images, audio, video support
- Cloud storage integration (AWS S3/Google Cloud)
- Media processing with `app/services/media_converter/`

### Testing Structure

RSpec test suite in `spec/`:
- Model specs test business logic and validations
- Request specs test controller behavior  
- Factory definitions in `spec/factories/`
- Shared examples and utilities in `spec/support/`

When working with this codebase, pay attention to the multi-tenant architecture and ensure changes respect the subdomain-based user separation. Most business logic flows through background jobs, so consider job processing when making changes to core functionality.