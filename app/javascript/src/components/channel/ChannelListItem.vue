<template>
  <div class="text-body">
    <div :class="itemClass" role="button">
      <img v-lazy="avatarImgObj" class="mr-2 rounded-circle" height="48" alt="User avatar" />
      <div class="media-body">
        <h5 class="my-0 font-14">
          <span class="float-right text-muted font-12">{{ readableTime }}</span>
          {{ truncate(friend.display_name || friend.line_name, 15) }}
        </h5>
        <p class="mt-1 mb-0 text-muted font-14">
          <span class="w-25 float-right text-right"
            ><span class="badge badge-danger-lighten" v-show="isUnread">{{ unreadCountLabel }}</span></span
          >
          <span :class="isUnread ? 'w-75 font-weight-bold' : 'w-75'"
            ><last-message :message="channel.last_message"
          /></span>
        </p>
      </div>
    </div>
  </div>
</template>
<script>
import moment from 'moment';
import Util from '@/core/util';

export default {
  props: ['channel', 'active'],
  data() {
    return {
      avatarImgObj: {
        src: '',
        error: '/img/no-image-profile.png',
        loading: '/images/loading.gif'
      }
    };
  },

  created() {
    this.avatarImgObj.src = this.friend.avatar_url;
  },

  computed: {
    friend() {
      return this.channel.line_friend;
    },
    readableTime() {
      const timeMessage = Util.formattedDate(this.channel.last_activity_at);
      const currentTime = moment();
      const dif = currentTime.diff(timeMessage, 'days');
      if (dif >= 1) {
        return moment(this.channel.last_activity_at, 'YYYY-MM-DD HH:mm:ss Z')
          .tz('Asia/Tokyo')
          .format('MM/DD');
      }

      return moment(this.channel.last_activity_at, 'YYYY-MM-DD HH:mm:ss Z')
        .tz('Asia/Tokyo')
        .format('HH:mm');
    },
    itemClass() {
      return this.active ? 'bg-light media mt-1 p-2' : 'media mt-1 p-2';
    },
    unreadCountLabel() {
      return this.channel.unread_count > 99 ? '99+' : this.channel.unread_count;
    },
    isUnread() {
      return this.channel.unread_count > 0;
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
    },

    truncate(name, length = 15) {
      return _.truncate(name, {
        length: length
      });
    }
  }
};
</script>