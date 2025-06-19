<template>
  <div class="">
    <img
      :src="'https://stickershop.line-scdn.net/stickershop/v1/sticker/'+data+'/PC/sticker.png'"
      class="sticker-static"
    />
  </div>
</template>
<script setup>
defineProps(['data'])
</script>
<style lang="scss" scoped>
.sticker-static {
  max-width: 185px;
  max-height: 160px;
}
</style>
