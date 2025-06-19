# Vue 3 Migration Guide

## Migration Status

### ✅ Completed
- Vue 3.5.16 installed with compatibility mode
- Vuex 4.1.0 installed with updated syntax
- README.md updated with current Ruby version (3.3.6)
- Migrated from esbuild to Vite for better Vue 2/3 compatibility
- Successfully building with Vue 3 + Vue 2 libraries in compatibility mode

### 🚧 Remaining Tasks

## 1. Vue 2 Library Migration (Priority: High)

### Libraries to Replace:

| Current Library | Version | Vue 3 Alternative | Status |
|----------------|---------|-------------------|---------|
| @ckeditor/ckeditor5-vue2 | ^1.0.5 | @ckeditor/ckeditor5-vue | ❌ |
| bootstrap-vue | ^2.17.3 | bootstrap-vue-next or Bootstrap 5 | ❌ |
| v-clipboard | ^2.2.3 | vue-clipboard3 | ❌ |
| v-tooltip | ^2.0.3 | floating-vue | ❌ |
| v-viewer | ^1.6.4 | viewerjs with custom Vue 3 wrapper | ❌ |
| vee-validate | ^2.2.15 | vee-validate@4 | ❌ |
| vue-click-outside | ^1.1.0 | Custom directive or @vueuse/core | ❌ |
| vue-datetime | ^1.0.0-beta.14 | @vuepic/vue-datepicker | ❌ |
| vue-google-oauth2 | ^1.5.8 | vue3-google-oauth2 | ❌ |
| vue-lazyload | ^1.3.3 | vue-lazyload@3 | ❌ |
| vue-multiselect | ^2.1.6 | @vueform/multiselect | ❌ |
| vue-qrcode-component | ^2.1.1 | qrcode.vue | ❌ |
| vue-select | ^3.11.2 | vue-select@4 (beta) or @vueform/select | ❌ |
| vue2-daterange-picker | ^0.6.2 | vue-daterange-picker or custom | ❌ |
| vue2-google-maps | ^0.10.7 | @fawmi/vue-google-maps | ❌ |

### Dev Dependencies to Update:
- vue-loader ^15.9.5 → vue-loader@17
- vue-template-compiler ^2.7.16 → Remove (not needed for Vue 3)

## 2. Vuex v3 to v4 Syntax Migration (Priority: High) ✅

### Main Store Updates:
- ✅ Replace `new Vuex.Store()` with `createStore()`
- ✅ Remove `Vue.use(Vuex)`
- ✅ Update main store file `/app/javascript/src/stores/index.js`
- ⏳ Update imports in all 32 store modules (if needed)

### Application.js Updates:
- ✅ Replace `new Vue()` with `createApp()`
- ✅ Update plugin registrations to use app instance
- ✅ Move global properties from Vue.prototype to app.config.globalProperties
- ✅ Register components on app instance instead of Vue.component

## 3. Pinia Migration (Priority: Medium - Optional)

### Benefits:
- Better TypeScript support
- Simpler API
- Better devtools integration
- No mutations (direct state changes)

### Migration Steps:
1. Install Pinia: `yarn add pinia`
2. Convert store modules one by one
3. Update component usage
4. Remove Vuex once all stores are migrated

## 4. Remove Vue Compatibility Mode (Priority: Low)

### Prerequisites:
- All Vue 2 libraries replaced
- All components updated to Vue 3 syntax
- Vuex migration completed

### Steps:
1. Remove `@vue/compat` from dependencies
2. Update `application.js` to use standard Vue 3 import
3. Remove `configureCompat()` calls
4. Test entire application

## Migration Order

1. **Phase 1**: Replace Vue 2 libraries with Vue 3 alternatives
2. **Phase 2**: Update Vuex syntax from v3 to v4
3. **Phase 3**: (Optional) Migrate from Vuex to Pinia
4. **Phase 4**: Remove compatibility mode

## Current Build Setup

### Using Vite with Vue 3 Compatibility Mode

The application now uses Vite as the build tool, which provides better support for Vue 2/3 hybrid applications.

#### Build Commands:
```bash
# Development build with hot reload
npm run dev

# Production build
npm run build

# Build CSS separately
npm run build:css

# Watch CSS changes
npm run watch:css
```

#### Key Configuration:
- **Vite Config**: `/vite.config.js` - Configured for Vue 3 with compatibility mode
- **Vue Compatibility**: Using `@vue/compat` to support Vue 2 syntax and libraries
- **Build Output**: Files are output to `app/assets/builds/`

### Working in Hybrid Mode

1. **New Components**: Use Vue 3 Composition API with `<script setup>`
2. **Existing Components**: Continue using Vue 2 Options API
3. **Libraries**: Most Vue 2 libraries work with compatibility mode
4. **Warnings**: ::v-deep warnings can be ignored for now or updated to :deep()

## Testing Strategy

After each major change:
1. Run test suite: `bundle exec rspec`
2. Test critical user flows manually
3. Check browser console for warnings
4. Verify background jobs still function
5. Check that Vite build completes without errors