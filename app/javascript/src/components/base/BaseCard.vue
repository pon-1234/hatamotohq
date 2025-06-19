<template>
  <div
    class="card"
    :class="computedCardClass"
  >
    <!-- Card Header -->
    <div v-if="!hideHeader" class="card-header">
      <div class="d-flex justify-content-between align-items-center">
        <div class="card-header-content">
          <h5 v-if="title" class="mb-0">
            <i v-if="icon" :class="icon" class="me-2"></i>
            {{ title }}
          </h5>
          <p v-if="subtitle" class="mb-0 text-muted small mt-1">{{ subtitle }}</p>
          <slot name="header-content" />
        </div>
        <div v-if="$slots['header-actions']" class="card-header-actions">
          <slot name="header-actions" />
        </div>
      </div>
    </div>

    <!-- Card Body -->
    <div v-if="!noBody" class="card-body" :class="bodyClass">
      <!-- Loading State -->
      <div v-if="loading" class="text-center py-5">
        <BaseSpinner variant="primary" />
        <p class="mt-2 text-muted">{{ loadingText }}</p>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="text-center py-5">
        <i class="fas fa-exclamation-triangle fa-3x text-danger mb-3"></i>
        <p class="text-danger">{{ error }}</p>
        <button 
          v-if="showRetry" 
          class="btn btn-primary btn-sm"
          @click="$emit('retry')"
        >
          再試行
        </button>
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
    </div>

    <!-- No Body Content -->
    <slot v-else />

    <!-- Card Footer -->
    <div v-if="$slots.footer" class="card-footer">
      <slot name="footer" />
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import BaseSpinner from './BaseSpinner.vue';

// Props
const props = defineProps({
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
});

// Emits
defineEmits(['retry']);

// Computed
const computedCardClass = computed(() => {
  const classes = [props.cardClass];
  
  if (props.bgVariant) {
    classes.push(`bg-${props.bgVariant}`);
  }
  
  if (props.textVariant) {
    classes.push(`text-${props.textVariant}`);
  }
  
  if (props.borderVariant) {
    classes.push(`border-${props.borderVariant}`);
  }
  
  return classes.join(' ');
});
</script>

<style scoped>
.card {
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(0, 0, 0, 0.125);
  border-radius: 0.25rem;
  transition: box-shadow 0.3s ease;
  background-color: #fff;
  word-wrap: break-word;
}

.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.card-header {
  background-color: #f8f9fa;
  border-bottom: 1px solid rgba(0, 0, 0, 0.125);
  padding: 1rem 1.25rem;
  border-top-left-radius: calc(0.25rem - 1px);
  border-top-right-radius: calc(0.25rem - 1px);
}

.card-header:first-child {
  border-radius: calc(0.25rem - 1px) calc(0.25rem - 1px) 0 0;
}

.card-header-actions {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.card-body {
  flex: 1 1 auto;
  padding: 1.5rem;
}

.card-footer {
  padding: 0.75rem 1.25rem;
  background-color: rgba(0, 0, 0, 0.03);
  border-top: 1px solid rgba(0, 0, 0, 0.125);
  border-bottom-right-radius: calc(0.25rem - 1px);
  border-bottom-left-radius: calc(0.25rem - 1px);
}

.card-footer:last-child {
  border-radius: 0 0 calc(0.25rem - 1px) calc(0.25rem - 1px);
}

/* Background variants */
.bg-primary {
  background-color: #007bff !important;
  color: #fff;
}

.bg-secondary {
  background-color: #6c757d !important;
  color: #fff;
}

.bg-success {
  background-color: #28a745 !important;
  color: #fff;
}

.bg-danger {
  background-color: #dc3545 !important;
  color: #fff;
}

.bg-warning {
  background-color: #ffc107 !important;
  color: #212529;
}

.bg-info {
  background-color: #17a2b8 !important;
  color: #fff;
}

.bg-light {
  background-color: #f8f9fa !important;
  color: #212529;
}

.bg-dark {
  background-color: #343a40 !important;
  color: #fff;
}

/* Border variants */
.border-primary {
  border-color: #007bff !important;
}

.border-secondary {
  border-color: #6c757d !important;
}

.border-success {
  border-color: #28a745 !important;
}

.border-danger {
  border-color: #dc3545 !important;
}

.border-warning {
  border-color: #ffc107 !important;
}

.border-info {
  border-color: #17a2b8 !important;
}

.border-light {
  border-color: #f8f9fa !important;
}

.border-dark {
  border-color: #343a40 !important;
}

.me-2 {
  margin-right: 0.5rem !important;
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