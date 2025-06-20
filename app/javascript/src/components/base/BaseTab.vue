<template>
  <div v-if="isActive" class="tab-pane fade show active" role="tabpanel">
    <slot></slot>
  </div>
</template>

<script setup>
import { inject, computed, onMounted, onUnmounted } from 'vue'

const props = defineProps({
  title: {
    type: String,
    required: true
  },
  disabled: {
    type: Boolean,
    default: false
  },
  active: {
    type: Boolean,
    default: false
  },
  titleItemClass: {
    type: [String, Array, Object],
    default: null
  },
  titleLinkClass: {
    type: [String, Array, Object],
    default: null
  }
})

const tabsProvider = inject('tabs-provider', null)
const tabId = Symbol('tab')

const isActive = computed(() => {
  if (!tabsProvider) return true
  return tabsProvider.activeTabId.value === tabId
})

onMounted(() => {
  if (tabsProvider) {
    tabsProvider.registerTab({
      id: tabId,
      title: props.title,
      disabled: props.disabled,
      active: props.active,
      titleItemClass: props.titleItemClass,
      titleLinkClass: props.titleLinkClass
    })
  }
})

onUnmounted(() => {
  if (tabsProvider) {
    tabsProvider.unregisterTab(tabId)
  }
})
</script> 