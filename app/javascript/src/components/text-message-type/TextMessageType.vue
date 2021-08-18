<template>
  <div class="message-text-content">
    <span v-if="data.type === 'text' ">【テキスト】</span>
    <span v-if="data.type === 'sticker' ">【スタンプ】</span>
    <span v-if="data.type === 'image' ">【画像】</span>
    <span v-if="data.type === 'video' ">【動画】</span>
    <span v-if="data.type === 'audio' ">【音声】</span>
    <span v-if="data.type === 'location' ">【位置情報】</span>
    <span v-if="data.type === 'imagemap' ">【イメージマップ】</span>
    <span v-if="data.type === 'flex' ">【Flex】</span>
    <span v-if="data.type === 'template' ">
        <span v-if="data.template.type === 'buttons' ">【ボタン】</span>
        <span v-if="data.template.type === 'confirm' ">【確認】</span>
        <span v-if="data.template.type === 'carousel' ">【カルーセル】</span>
        <span v-if="data.template.type === 'image_carousel' ">【画像カルーセル】</span>
    </span>
  </div>
</template>
<script>
export default {
  props: ['data']
};
</script>

<style lang="scss" scoped>
.message-text-content {
  display: inline-block;
    white-space: nowrap;
}
</style>
