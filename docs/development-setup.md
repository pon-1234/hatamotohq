# Development Setup Guide

## Starting the Application with Vite

### Prerequisites
1. Ruby 3.3.6
2. Node.js 18.x or higher
3. PostgreSQL
4. Redis

### Setup Steps

1. **Install dependencies**
   ```bash
   bundle install
   npm install --legacy-peer-deps
   ```

2. **Database setup**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   # Or simply:
   rails db:refresh
   ```

3. **Start the development servers**
   ```bash
   # Using foreman (recommended)
   foreman start -f Procfile.dev
   
   # Or start separately:
   # Terminal 1: Rails server
   rails server
   
   # Terminal 2: Vite dev server
   bin/vite dev
   
   # Terminal 3: CSS watcher
   npm run watch:css
   
   # Terminal 4: Sidekiq (for background jobs)
   sidekiq
   ```

4. **Access the application**
   - Main app: http://localhost:3000
   - Vite dev server: http://localhost:3036
   - Sidekiq dashboard: http://localhost:3000/sidekiq

### Development Tips

1. **Hot Module Replacement (HMR)**
   - Vite provides HMR for Vue components
   - Changes to .vue files will update instantly in the browser

2. **Vue DevTools**
   - Install Vue DevTools browser extension
   - Works with Vue 3 in compatibility mode

3. **Creating New Components**
   - Use Vue 3 Composition API with `<script setup>` for new components
   - Place components in `app/javascript/src/components/`

### Troubleshooting

1. **Port conflicts**
   - Rails: 3000 (change with `rails s -p 3001`)
   - Vite: 3036 (configured in `config/vite.json`)

2. **Asset compilation issues**
   - Run `bin/vite clobber` to clear cache
   - Rebuild with `npm run build`

3. **Vue compatibility warnings**
   - ::v-deep warnings are expected in compatibility mode
   - Update to :deep() syntax when convenient