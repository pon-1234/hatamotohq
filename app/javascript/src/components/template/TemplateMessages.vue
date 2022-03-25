<template>
  <div class="message-preview">
    <div v-for="(message, index) in messages" :key="index">
      <div class="template-message template-message-text-light template-message-secondary" v-if="isDisplay(message)">
        <div class="template-message-content w-min-0">
          <div class="template-message-body">
            <div class="template-message-main w-min-0">
              <message-content :data="message"></message-content>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { mapState } from 'vuex';

import Util from '@/core/util';

export default {
  computed: {
    ...mapState('preview', {
      messages: state => state.messages
    })
  },

  methods: {
    isDisplay(message) {
      return !Util.checkMessageContentForPreview(message);
    }
  }
};
</script>

<style lang="scss" scoped>
  ::v-deep {
    .mb-1,
    .my-1 {
      margin-bottom: 0.25rem !important;
    }

    .template-message {
      position: relative;
      display: flex;
      -webkit-box-orient: horizontal;
      -webkit-box-direction: normal;
      flex-direction: row;
      -webkit-box-align: center;
      align-items: flex-center;
      justify-content: center;
      margin-bottom: 15px;
      font-size: 12px;
    }

    .w-min-0 {
      min-width: 0px;
    }

    .template-message-main {
      display: flex;
      flex-wrap: nowrap;
      -webkit-box-orient: vertical;
      -webkit-box-direction: normal;
      flex-direction: column;
    }

    .template-message-body {
      display: -webkit-box;
      display: flex;
      -webkit-box-orient: horizontal;
      -webkit-box-direction: normal;
      flex-direction: row;
      margin-bottom: 0.5rem;
    }
  }
</style>
