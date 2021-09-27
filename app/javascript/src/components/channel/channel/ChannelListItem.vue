<template>
  <div class="text-body">
    <div :class="active ? 'bg-light media mt-1 p-2' : 'media mt-1 p-2'" role="button">
      <img :src="channel.line_friend.avatar_url || '/img/no-image-profile.png'" class="mr-2 rounded-circle" height="48"
        alt="User avatar" />
      <div class="media-body">
        <h5 class="mt-0 mb-0 font-14">
          <span class="float-right text-muted font-12">{{getLastTime(channel.last_timetamp)}}</span>
          {{channel.line_friend.name}}
        </h5>
        <p class="mt-1 mb-0 text-muted font-14">
          <span class="w-25 float-right text-right"><span
              class="badge badge-danger-lighten">3</span></span>
          <span class="w-75"><last-message-text :message="channel.last_message"/></span>
        </p>
      </div>
    </div>
  </div>
<!--
  <div :class="getChannelClass()">
    <div class="avatar">
      <img :src="data.avatar ? data.avatar : '/img/no-image-profile.png'">
    </div>
    <div class="content">
      <div class="info">
        <div class="w">
            <div class="title">{{data.title}}</div>
            <div class="online" v-if="data.is_action">要対応</div>
        </div>
          <div class="timestamp">{{getLastTime(data.last_timetamp)}}</div>
      </div>
      <div class="d-flex">
        <div class="last-message" :class="data.un_read ? 'unread': ''">
          <last-message-text :message="data.last_message"/>
        </div>
        <div class="total-unread-message" v-if="data.total_unread_messages">{{getTotalUnreadMessage()}}</div>
      </div>
    </div>
  </div> -->
</template>
<script>
import moment from 'moment';

export default {
  props: ['channel', 'active'],
  methods: {
    getLastTime(time) {
      const timeMessage = moment(moment(time).format('YYYY-MM-DD'));
      const currentTime = moment(moment().format('YYYY-MM-DD'));
      const dif = currentTime.diff(timeMessage, 'days');
      if (dif >= 1) {
        return moment(time).format('YYYY.MM.DD');
      }

      return moment(time).format('HH:mm');
    },

    getChannelClass() {
      let className = 'item ';
      if (this.active) {
        className += 'active';
      }

      if (this.channel.status === 'blocked') {
        className += ' blocked';
      }

      return className;
    },

    getTotalUnreadMessage() {
      if (this.channel.total_unread_messages > 98) {
        return '99+';
      }
      return this.channel.total_unread_messages;
    }
  }
};
</script>

<style lang="scss" scoped>
.total-unread-message {
  width: 25px;
  height: 25px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: #00B900;
  color: white;
  font-weight: bold;
  border-radius: 50%;
  font-size: 10px;
  padding-left: 2px;
}
</style>
