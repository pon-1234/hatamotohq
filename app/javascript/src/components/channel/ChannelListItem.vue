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
<script setup>
import { computed } from 'vue'
import moment from 'moment'
import Util from '@/core/util'

const props = defineProps({
  channel: {
    type: Object,
    required: true
  },
  active: {
    type: Boolean,
    default: false
  }
})

const friend = computed(() => props.channel.line_friend)

const avatarImgObj = computed(() => ({
  src: friend.value.avatar_url,
  error: '/img/no-image-profile.png',
  loading: '/images/loading.gif'
}))

const readableTime = computed(() => {
  const timeMessage = Util.formattedDate(props.channel.last_activity_at)
  const currentTime = Util.formattedDate(moment())
  if (currentTime !== timeMessage) {
    return moment(props.channel.last_activity_at, 'YYYY-MM-DD HH:mm:ss Z')
      .tz('Asia/Tokyo')
      .format('MM/DD')
  }

  return moment(props.channel.last_activity_at, 'YYYY-MM-DD HH:mm:ss Z')
    .tz('Asia/Tokyo')
    .format('HH:mm')
})

const itemClass = computed(() => props.active ? 'bg-light media mt-1 p-2' : 'media mt-1 p-2')

const unreadCountLabel = computed(() => props.channel.unread_count > 99 ? '99+' : props.channel.unread_count)

const isUnread = computed(() => props.channel.unread_count > 0)

const getChannelClass = () => {
  let className = 'item '
  if (props.active) {
    className += 'active'
  }

  if (props.channel.locked) {
    className += ' blocked'
  }

  return className
}

const truncate = (name, length = 15) => {
  if (!name) return ''
  return name.length > length ? name.substring(0, length) + '...' : name
}
</script>