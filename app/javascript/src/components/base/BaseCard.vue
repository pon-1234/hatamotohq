<template>
  <b-card
    :class="cardClass"
    :bg-variant="bgVariant"
    :text-variant="textVariant"
    :border-variant="borderVariant"
    :no-body="noBody"
  >
    <!-- Card Header -->
    <template v-if="!hideHeader" #header>
      <div class="d-flex justify-content-between align-items-center">
        <div class="card-header-content">
          <h5 v-if="title" class="mb-0">
            <i v-if="icon" :class="icon" class="mr-2"></i>
            {{ title }}
          </h5>
          <p v-if="subtitle" class="mb-0 text-muted small mt-1">{{ subtitle }}</p>
          <slot name="header-content" />
        </div>
        <div v-if="$slots['header-actions']" class="card-header-actions">
          <slot name="header-actions" />
        </div>
      </div>
    </template>

    <!-- Card Body -->
    <b-card-body v-if="!noBody" :class="bodyClass">
      <!-- Loading State -->
      <div v-if="loading" class="text-center py-5">
        <b-spinner variant="primary" />
        <p class="mt-2 text-muted">{{ loadingText }}</p>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="text-center py-5">
        <i class="fas fa-exclamation-triangle fa-3x text-danger mb-3"></i>
        <p class="text-danger">{{ error }}</p>
        <b-button v-if="showRetry" variant="primary" size="sm" @click="$emit('retry')">
          再試行
        </b-button>
      </div>

      <!-- Empty State -->
      <div v-else-if="empty" class="text-center py-5">
        <slot name="empty">
          <i :class="emptyIcon" class="fa-3x text-muted mb-3"></i>
          <p class="text-muted">{{ emptyText }}</p>
        </slot>
      </div>

      <!-- Content -->
      <div v-else>
        <slot />
      </div>
    </b-card-body>

    <!-- No Body Content -->
    <slot v-else />

    <!-- Card Footer -->
    <template v-if="$slots.footer" #footer>
      <slot name="footer" />
    </template>
  </b-card>
</template>

<script>
export default {
  name: 'BaseCard',
  props: {
    title: {
      type: String,
      default: ''
    },
    subtitle: {
      type: String,
      default: ''
    },
    icon: {
      type: String,
      default: ''
    },
    loading: {
      type: Boolean,
      default: false
    },
    error: {
      type: String,
      default: ''
    },
    empty: {
      type: Boolean,
      default: false
    },
    hideHeader: {
      type: Boolean,
      default: false
    },
    noBody: {
      type: Boolean,
      default: false
    },
    bgVariant: {
      type: String,
      default: null
    },
    textVariant: {
      type: String,
      default: null
    },
    borderVariant: {
      type: String,
      default: null
    },
    cardClass: {
      type: String,
      default: ''
    },
    bodyClass: {
      type: String,
      default: ''
    },
    loadingText: {
      type: String,
      default: '読み込み中...'
    },
    emptyText: {
      type: String,
      default: 'データがありません'
    },
    emptyIcon: {
      type: String,
      default: 'fas fa-inbox'
    },
    showRetry: {
      type: Boolean,
      default: true
    }
  }
};
</script>

<style scoped>
.card {
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  border: none;
  transition: box-shadow 0.3s ease;
}

.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.card-header {
  background-color: #f8f9fa;
  border-bottom: 1px solid #dee2e6;
  padding: 1rem 1.25rem;
}

.card-header-actions {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.card-body {
  padding: 1.5rem;
}

@media (max-width: 768px) {
  .card-body {
    padding: 1rem;
  }
  
  .card-header {
    padding: 0.75rem 1rem;
  }
}
</style>