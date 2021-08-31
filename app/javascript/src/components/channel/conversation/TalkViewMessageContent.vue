<template>
  <div :class="'chat '+ data.attr">
    <div class="avatar" v-if="data.attr == 'chat-secondary'">
      <img :src="data.customer.line_picture_url ? data.customer.line_picture_url :  '/img/no-image-profile.png'">
    </div>
    <div class="chat-content">
      <div class="chat-body">
        <div class="chat-main" :class="data.is_bot_sender ? ' is_bot' : ''">
          <message-content-view :data="data.line_content" :time="getTimeMessage(data)" :source="data.source || 'sended'"></message-content-view>
        </div>
      </div>
    </div>
    <div class="created-message" v-if="data.attr !== 'chat-log'">
      {{getTimeMessage(data)}}
    </div>
    <div :class="'more-option option-'+ data.attr" v-if="data.attr !== 'chat-log'">
       <b-dropdown>
        <template v-slot:button-content>
          <i class="fas fa-ellipsis-h"></i>
        </template>
        <b-dropdown-item @click="setUnreadMessage">未読</b-dropdown-item>
      </b-dropdown>
    </div>
  </div>
</template>
<script>
import moment from 'moment';

export default {
  props: ['data'],
  methods: {
    setUnreadMessage() {
      this.$emit('unread', this.data.id);
    },

    getTimeMessage(value) {
      return moment(parseInt(value.line_timestamp)).format('HH:mm');
    }
  }
};
</script>
<style lang="scss" scoped>
::v-deep {
  .more-option {
    display: none;
    margin:  0 5px;

    button {
      cursor: pointer;
      display: flex;
      flex-shrink: 0;
      height: 25px;
      justify-content: center;
      width: 20px;
      background: transparent!important;
      border: none!important;
    }

    button:active {
      box-shadow: none!important;
    }

    .dropdown-menu {
      width: 50px!important;
      min-width: 50px!important;
      a{
        padding: 3px 10px !important;
      }
    }
  }
}

  .chat:hover {
    .more-option {
      display: block;
    }
  }

  .created-message {
    margin-top: auto;
    margin-left: 5px;
    margin-right: 5px;
  }

</style>
