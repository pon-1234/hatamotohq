<template>
  <div>
    <div :class="getClassName()">
      <media-preview
        :type="data.type"
        :src="data.originalContentUrl"
        :duration="getDuration()"
        :showMedia="true"
      ></media-preview>
    </div>
  </div>
</template>
<script setup>
import Util from '@/core/util'

const props = defineProps(['data'])

const getClassName = () => {
  let className = 'chat-item rounded'
  if (props.data.type === 'video') {
    className += ' video'
  }

  return className
}

const getDuration = () => {
  if (props.data.type === 'audio') {
    return Util.getDuration(props.data)
  }
}
</script>
<style lang="scss" scoped>
  .chat-item {
    display: inline-flex;
    overflow: hidden;
  }
</style>
