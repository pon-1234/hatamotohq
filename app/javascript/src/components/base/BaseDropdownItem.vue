<template>
  <component
    :is="componentType"
    :class="itemClass"
    :href="href"
    :disabled="disabled"
    @click="onClick"
    v-bind="componentProps"
  >
    <slot></slot>
  </component>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  href: {
    type: String,
    default: null
  },
  disabled: {
    type: Boolean,
    default: false
  },
  active: {
    type: Boolean,
    default: false
  },
  variant: {
    type: String,
    default: null
  },
  linkClass: {
    type: [String, Array, Object],
    default: null
  }
})

const emit = defineEmits(['click'])

const componentType = computed(() => {
  return props.href ? 'a' : 'button'
})

const itemClass = computed(() => {
  const classes = ['dropdown-item']
  
  if (props.active) {
    classes.push('active')
  }
  
  if (props.disabled) {
    classes.push('disabled')
  }
  
  if (props.variant) {
    classes.push(`text-${props.variant}`)
  }
  
  if (props.linkClass) {
    if (Array.isArray(props.linkClass)) {
      classes.push(...props.linkClass)
    } else if (typeof props.linkClass === 'object') {
      classes.push(props.linkClass)
    } else {
      classes.push(props.linkClass)
    }
  }
  
  return classes
})

const componentProps = computed(() => {
  const attrs = {}
  
  if (componentType.value === 'button') {
    attrs.type = 'button'
  }
  
  if (props.disabled) {
    attrs['aria-disabled'] = 'true'
    if (componentType.value === 'a') {
      attrs.tabindex = '-1'
    }
  }
  
  return attrs
})

const onClick = (event) => {
  if (props.disabled) {
    event.preventDefault()
    event.stopPropagation()
    return
  }
  
  emit('click', event)
}
</script>

<style scoped>
.dropdown-item {
  display: block;
  width: 100%;
  padding: 0.25rem 1.5rem;
  clear: both;
  font-weight: 400;
  color: #212529;
  text-align: inherit;
  text-decoration: none;
  white-space: nowrap;
  background-color: transparent;
  border: 0;
}

.dropdown-item:hover,
.dropdown-item:focus {
  color: #16181b;
  text-decoration: none;
  background-color: #f8f9fa;
}

.dropdown-item.active,
.dropdown-item:active {
  color: #fff;
  text-decoration: none;
  background-color: #007bff;
}

.dropdown-item.disabled,
.dropdown-item:disabled {
  color: #6c757d;
  pointer-events: none;
  background-color: transparent;
}

button.dropdown-item {
  text-align: left;
}
</style> 