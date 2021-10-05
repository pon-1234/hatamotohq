<template>
  <div class="text-left">
    <span class="text-sm" v-if="type === 'image'">
      ファイル形式：JPG、JPEG、PNG
      ファイルサイズ：10MB以下
    </span>
    <span
      class="text-sm"
      v-else-if="type === 'video'"
    >
      ファイル形式：MP4<br>
      ファイルサイズ：10MB以下
    </span>
    <span v-else-if="type === 'audio'"
      class="text-sm">
      ファイル形式：MP3<br>
      ファイルサイズ：10MB以下
    </span>
    <span class="text-sm" v-else-if="type === 'richmenu'"
    >
      ファイル形式：JPG、JPEG、PNG<br>
      ファイルサイズ：1MB以下<br>
      画像サイズ：2500px × 1686px、2500px × 843px、1200px × 810px、1200px × 405px、800px × 540px、800px × 270px
    </span>
    <span class="text-sm" v-else-if="type === 'pdf'">
      ファイル形式：PDF<br>
      ファイルサイズ：10MB以下
    </span>
    <span v-else>
      ファイル形式：JPG、JPEG、PNG、MP3、MP4<br>
    </span>
  </div>
</template>

<script>
export default {
  props: {
    type: {
      type: String,
      default: 'image'
    }
  }
};
</script>

<style lang="scss" scoped>
  .text-sm {
    font-size: 0.72rem !important;
  }
</style>