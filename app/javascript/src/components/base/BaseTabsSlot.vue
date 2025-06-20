<template>
  <div class="base-tabs-slot">
    <!-- Tab Navigation -->
    <ul class="nav" :class="navClasses" role="tablist">
      <li
        v-for="tab in tabs"
        :key="tab.id"
        class="nav-item"
        :class="tab.titleItemClass"
        role="presentation"
      >
        <button
          class="nav-link"
          :class="[
            { 
              active: activeTabId === tab.id,
              disabled: tab.disabled 
            },
            tab.titleLinkClass
          ]"
          type="button"
          role="tab"
          :aria-selected="activeTabId === tab.id"
          :disabled="tab.disabled"
          @click="selectTab(tab.id)"
        >
          {{ tab.title }}
        </button>
      </li>
    </ul>

    <!-- Tab Content -->
    <div class="tab-content" :class="contentClass">
      <slot></slot>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, provide } from 'vue'

const props = defineProps({
  modelValue: {
    type: Number,
    default: 0
  },
  pills: {
    type: Boolean,
    default: false
  },
  fill: {
    type: Boolean,
    default: false
  },
  justified: {
    type: Boolean,
    default: false
  },
  vertical: {
    type: Boolean,
    default: false
  },
  small: {
    type: Boolean,
    default: false
  },
  navClass: {
    type: [String, Array, Object],
    default: null
  },
  navWrapperClass: {
    type: [String, Array, Object],
    default: null
  },
  contentClass: {
    type: [String, Array, Object],
    default: null
  },
  card: {
    type: Boolean,
    default: false
  },
  noFade: {
    type: Boolean,
    default: false
  },
  lazy: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['update:modelValue', 'input'])

const tabs = ref([])
const activeTabId = ref(null)

const navClasses = computed(() => {
  const classes = [
    props.pills ? 'nav-pills' : 'nav-tabs'
  ]
  
  if (props.fill) classes.push('nav-fill')
  if (props.justified) classes.push('nav-justified')
  if (props.vertical) classes.push('flex-column')
  if (props.small) classes.push('small')
  if (props.card) classes.push('card-header-tabs')
  
  if (props.navClass) {
    if (Array.isArray(props.navClass)) {
      classes.push(...props.navClass)
    } else if (typeof props.navClass === 'object') {
      classes.push(props.navClass)
    } else {
      classes.push(props.navClass)
    }
  }
  
  return classes
})

const registerTab = (tab) => {
  tabs.value.push(tab)
  
  // Set first tab as active if none is set
  if (!activeTabId.value || tab.active) {
    activeTabId.value = tab.id
  }
}

const unregisterTab = (tabId) => {
  const index = tabs.value.findIndex(tab => tab.id === tabId)
  if (index > -1) {
    tabs.value.splice(index, 1)
    
    // If active tab was removed, activate first available tab
    if (activeTabId.value === tabId && tabs.value.length > 0) {
      activeTabId.value = tabs.value[0].id
    }
  }
}

const selectTab = (tabId) => {
  const tab = tabs.value.find(t => t.id === tabId)
  if (tab && !tab.disabled) {
    activeTabId.value = tabId
    const index = tabs.value.findIndex(t => t.id === tabId)
    emit('update:modelValue', index)
    emit('input', index)
  }
}

// Provide methods to child tabs
provide('tabs-provider', {
  registerTab,
  unregisterTab,
  activeTabId
})
</script>

<style scoped>
.base-tabs-slot {
  width: 100%;
}

.nav {
  display: flex;
  flex-wrap: wrap;
  padding-left: 0;
  margin-bottom: 0;
  list-style: none;
}

.nav-tabs {
  border-bottom: 1px solid #dee2e6;
}

.nav-tabs .nav-item {
  margin-bottom: -1px;
}

.nav-tabs .nav-link {
  border: 1px solid transparent;
  border-top-left-radius: 0.25rem;
  border-top-right-radius: 0.25rem;
  background: none;
  padding: 0.5rem 1rem;
  color: #495057;
  text-decoration: none;
  cursor: pointer;
}

.nav-tabs .nav-link:hover {
  border-color: #e9ecef #e9ecef #dee2e6;
  color: #495057;
}

.nav-tabs .nav-link.disabled {
  color: #6c757d;
  background-color: transparent;
  border-color: transparent;
  cursor: not-allowed;
}

.nav-tabs .nav-link.active {
  color: #495057;
  background-color: #fff;
  border-color: #dee2e6 #dee2e6 #fff;
}

.nav-pills .nav-link {
  border-radius: 0.25rem;
  background: none;
  border: none;
  padding: 0.5rem 1rem;
  color: #007bff;
  text-decoration: none;
  cursor: pointer;
}

.nav-pills .nav-link.active {
  color: #fff;
  background-color: #007bff;
}

.nav-pills .nav-link:hover:not(.active):not(.disabled) {
  color: #0056b3;
}

.nav-fill .nav-item {
  flex: 1 1 auto;
  text-align: center;
}

.nav-justified .nav-item {
  flex-basis: 0;
  flex-grow: 1;
  text-align: center;
}

.flex-column {
  flex-direction: column;
}

.flex-column .nav-link {
  width: 100%;
}

.small .nav-link {
  padding: 0.25rem 0.5rem;
  font-size: 0.875rem;
}

.tab-content {
  padding-top: 1rem;
}

.card-header-tabs {
  margin-right: -0.625rem;
  margin-bottom: -0.75rem;
  margin-left: -0.625rem;
  border-bottom: 0;
}

/* Vertical tabs layout */
.base-tabs-slot:has(.flex-column) {
  display: flex;
}

.base-tabs-slot:has(.flex-column) .nav {
  width: 200px;
  border-bottom: none;
  border-right: 1px solid #dee2e6;
  margin-bottom: 0;
  margin-right: 1rem;
}

.base-tabs-slot:has(.flex-column) .tab-content {
  flex: 1;
  padding: 0 0 0 1rem;
}
</style> 