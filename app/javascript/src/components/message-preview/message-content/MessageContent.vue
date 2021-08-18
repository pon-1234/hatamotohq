<template>
  <div>
    <div v-for="(item, index) in messages" :key="index">
      <div class="chat chat-text-light chat-secondary" v-if="isDisplay(item)">
        <div class="avatar mb-1 rounded-circle avatar-sm">
          <div
            class="w-100 h-100"
            v-show="index === 0"
            style="background: url('/img/no-image-profile.png') center center / cover;"
          ></div>
        </div>
        <div class="chat-content w-min-0">
          <div v-if="user" class="chat-header">{{user.line_name}}</div>
          <div class="chat-body">
            <div class="chat-main w-min-0">
              <view-message-content :data="item.content" ></view-message-content>
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
  name: 'MessageContent',
  computed: {
    ...mapState('global', {
      user: state => state.user
    }),
    ...mapState('preview', {
      messages: state =>
        state.messages
    })
  },
  mounted() {
    this.$store.dispatch('global/fetchUserData');
  },
  methods: {
    isDisplay(item) {
      return !Util.checkMessageContentForPreview(item);
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

  .chat {
    position: relative;
    display: flex;
    -webkit-box-orient: horizontal;
    -webkit-box-direction: normal;
    flex-direction: row;
    -webkit-box-align: start;
    align-items: flex-start;
    margin-bottom: 15px;
    font-size: 12px;
  }

  .chat .avatar,
  .chat .avatars {
    margin-right: 15px;
    -webkit-box-flex: 0;
    flex-grow: 0;
    flex-shrink: 0;
  }

  .avatar.avatar-sm {
    width: 48px;
    height: 48px;
  }

  .avatar {
    display: inline-block;
    position: relative;
    overflow: hidden;
    vertical-align: middle;
  }

  .w-min-0 {
    min-width: 0px;
  }

  .chat-main {
    display: flex;
    flex-wrap: nowrap;
    -webkit-box-orient: vertical;
    -webkit-box-direction: normal;
    flex-direction: column;
  }

  .chat.chat-text-light .chat-header,
  .chat.chat-text-light .chat-sub,
  .chat.chat-text-light .chat-footer {
    color: #dee2e6 !important;
  }

  .chat .chat-content .chat-header {
    line-height: 1;
    margin-bottom: 8px;
    color: #868e96;
  }

  .chat-item {
    position: relative;
  }

  .baloon:after {
    content: "";
    position: absolute;
    left: 0;
    top: 0.75rem;
    width: 0;
    height: 0;
    border: 8px solid transparent;
    border-right-color: #edeff0;
    border-left: 0;
    border-top: 0;
    margin-left: -7px;
  }

  .chat-body .chat-main .chat-item.baloon {
    margin-right: 1.25rem;
  }

  .chat-item.baloon {
    border-radius: 1rem;
    display: inline-block;
    background: white;
  }

  .chat-item.rounded {
    background: #f2f3f5 !important;
    color: #505769 !important;
  }

  .chat .rounded {
    border-radius: 0.5rem !important;
    overflow: hidden;
  }

  .chat-body {
    display: -webkit-box;
    display: flex;
    -webkit-box-orient: horizontal;
    -webkit-box-direction: normal;
    flex-direction: row;
    margin-bottom: 0.5rem;
  }
}
</style>
