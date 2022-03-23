<template>
  <div v-if="messages.length > 0">
    <div v-for="(message, index) in messages" :key="index" class="text-left">
      <message-content :data="message"></message-content>
      <divider v-if="index < messages.length - 1"></divider>
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