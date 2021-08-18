<template>
  <div>
    <div :class="getClassName()">
        <media-preview :type="data.type" :src="getUrlMedia()" :duration="getDuration()"  v-if="data.contentProvider" :showMedia="true" />
        <media-preview :src="data.originalContentUrl"  :type="data.type" :duration="getDuration()" :showMedia="true" v-else/>
    </div>
  </div>
</template>
<script>
import Util from '@/core/util';

export default {
  props: ['data'],
  created() {
    console.log(this.data);
  },
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
    },

    getUrlFromLineId(id) {
      return Util.getMediaFromLine(id);
    },

    getUrlMedia() {
      if (this.data.contentProvider.type === 'line') {
        return this.getUrlFromLineId(this.data.id);
      }

      return this.data.originalContentUrl || this.data.contentProvider.originalContentUrl;
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
