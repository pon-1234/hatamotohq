<template>
  <div class="base-spinner" :class="spinnerClasses" role="status">
    <span class="sr-only">{{ label }}</span>
  </div>
</template>

<script>
export default {
  name: 'BaseSpinner',
  props: {
    type: {
      type: String,
      default: 'border',
      validator: (value) => ['border', 'grow'].includes(value)
    },
    variant: {
      type: String,
      default: 'primary'
    },
    size: {
      type: String,
      default: 'md',
      validator: (value) => ['sm', 'md', 'lg'].includes(value)
    },
    label: {
      type: String,
      default: 'Loading...'
    }
  },
  computed: {
    spinnerClasses() {
      return [
        `spinner-${this.type}`,
        `text-${this.variant}`,
        {
          [`spinner-${this.type}-${this.size}`]: this.size !== 'md'
        }
      ];
    }
  }
};
</script>

<style scoped>
@keyframes spinner-border {
  to {
    transform: rotate(360deg);
  }
}

@keyframes spinner-grow {
  0% {
    transform: scale(0);
  }
  50% {
    opacity: 1;
    transform: none;
  }
}

.spinner-border {
  display: inline-block;
  width: 2rem;
  height: 2rem;
  vertical-align: text-bottom;
  border: 0.25em solid currentColor;
  border-right-color: transparent;
  border-radius: 50%;
  animation: spinner-border 0.75s linear infinite;
}

.spinner-border-sm {
  width: 1rem;
  height: 1rem;
  border-width: 0.2em;
}

.spinner-border-lg {
  width: 3rem;
  height: 3rem;
  border-width: 0.3em;
}

.spinner-grow {
  display: inline-block;
  width: 2rem;
  height: 2rem;
  vertical-align: text-bottom;
  background-color: currentColor;
  border-radius: 50%;
  opacity: 0;
  animation: spinner-grow 0.75s linear infinite;
}

.spinner-grow-sm {
  width: 1rem;
  height: 1rem;
}

.spinner-grow-lg {
  width: 3rem;
  height: 3rem;
}

.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}

/* Text color variants */
.text-primary { color: #007bff; }
.text-secondary { color: #6c757d; }
.text-success { color: #28a745; }
.text-danger { color: #dc3545; }
.text-warning { color: #ffc107; }
.text-info { color: #17a2b8; }
.text-light { color: #f8f9fa; }
.text-dark { color: #343a40; }
</style>