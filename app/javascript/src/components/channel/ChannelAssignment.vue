<template>
  <div>
    <staff-selection 
      :selected="channel.assignee_id" 
      @select="assignAgent" 
      @open="openStaffSelect" 
      @close="emit('close')"
    />
  </div>
</template>

<script setup>
import { useStore } from 'vuex'

const props = defineProps({
  channel: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['open', 'close'])

const store = useStore()

const assignAgent = async (agentId) => {
  const payload = {
    channel_id: props.channel.id,
    assignee_id: agentId || null
  }
  const response = await store.dispatch('channel/assign', payload)
  if (response) {
    window.toastr.success('担当者が変更されました。')
  } else {
    window.toastr.error('失敗しました。')
  }
}

const openStaffSelect = (staffCount) => {
  emit('open', staffCount)
}
</script>
