<template>
  <div role="button" v-bind:class="getClass()" @click="selectPackageId">
    <img
      v-if="data.packageId"
      :src="`https://stickershop.line-scdn.net/stickershop/v1/product/${data.packageId}/ANDROID/tab_on.png`"
    />
    <i v-bind:class="data.icon" v-if="data.icon"></i>
  </div>
</template>

<script setup>
const props = defineProps(['data'])
const emit = defineEmits(['input'])

const selectPackageId = () => {
  emit('input', props.data.packageId)
}

const getClass = () => {
  let className = 'sticker-nav'
  if (props.data.active) {
    className += ' active'
  }
  if (props.data.animation) {
    className += ' sticker-nav-animation'
  }

  return className
}
</script>
