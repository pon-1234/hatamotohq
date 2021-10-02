<template>
  <div>
    <div :class="getClassName()">
        <media-preview :type="data.type" :src="data.previewImageUrl" :duration="getDuration()"  v-if="data" :showMedia="true" />
        <media-preview :src="data.originalContentUrl"  :type="data.type" :duration="getDuration()" :showMedia="true" v-else/>
    </div>
  </div>
</template>
<script>
import Util from '@/core/util';

export default {
  props: ['data'],
  methods: {
    getClassName() {
      let className = 'chat-item rounded';
      if (this.data.type === 'video') {
        className += ' video';
      }

      return className;
    },

    getDuration() {
      if (this.data.type === 'audio') {
        return Util.getDuration(this.data);
      }
    }
  }
};
</script>
<style lang="scss" scoped>
.chat-item {
  display: inline-flex;
  overflow: hidden;
}
</style>
