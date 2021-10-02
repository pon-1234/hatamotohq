<template>
  <div class="text-body">
    <div :class="itemClass" role="button">
      <img :src="friend.avatar_url || '/img/no-image-profile.png'" class="mr-2 rounded-circle" height="48"
        alt="User avatar" />
      <div class="media-body">
        <h5 class="mt-0 mb-0 font-14">
          <span class="float-right text-muted font-12">{{ readableTime }}</span>
          {{ friend.name }}
        </h5>
        <p class="mt-1 mb-0 text-muted font-14">
          <span class="w-25 float-right text-right"><span
              class="badge badge-danger-lighten" v-show="channel.unread_count > 0">{{ unreadCountLabel }}</span></span>
          <span class="w-75"><last-message :message="channel.last_message"/></span>
        </p>
      </div>
    </div>
  </div>
</template>
<script>
import moment from 'moment';

export default {
  props: ['channel', 'active'],
  computed: {
    friend() {
      return this.channel.line_friend;
    },
    readableTime() {
      const timeMessage = moment(moment(this.channel.last_activity_at).format('YYYY-MM-DD'));
      const currentTime = moment(moment().format('YYYY-MM-DD'));
      const dif = currentTime.diff(timeMessage, 'days');
      if (dif >= 1) {
        return moment(this.channel.last_activity_at).format('MM/DD');
      }

      return moment(this.channel.last_activity_at).format('HH:mm');
    },
    itemClass() {
      return this.active ? 'bg-light media mt-1 p-2' : 'media mt-1 p-2';
    },
    unreadCountLabel() {
      return this.channel.unread_count > 99 ? '99+' : this.channel.unread_count;
    }
  },
  methods: {
    getChannelClass() {
      let className = 'item ';
      if (this.active) {
        className += 'active';
      }

      if (this.channel.locked) {
        className += ' blocked';
      }

      return className;
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
