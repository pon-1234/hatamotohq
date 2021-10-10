<template>
  <div v-if="messages.length > 0">
    <div v-for="(message, index) in messages" :key="index" class="text-left">
      <message-content :data="message.content"></message-content>
    </div>
  </div>
  <div v-else>メッセージなし</div>
</template>

<script>
export default {
  props: {
    episode: {
      type: Object,
      required: true
    }
  },

  computed: {
    messages() {
      return this.episode.messages;
    }
  }
};
</script>

<style>
</style>