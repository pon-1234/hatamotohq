<template>
  <div class="card chat-panel" v-if="activeChannel">
    <div class="card-body">
      <div class="mt-3 text-center">
        <img :src="friend.avatar_url || '/img/no-image-profile.png'" alt="shreyu"
          class="img-thumbnail avatar-lg rounded-circle" />
        <h4>{{ friend.name }}</h4>
      </div>

      <div class="mt-3">
        <div class="d-flex align-items-center justify-content-center">
          <a :href="detailPath" class="btn btn-primary btn-xs mr-1 ml-auto">詳細</a>
          <friend-toggle-locked :id="friend.id" :locked="friend.locked" class="mr-auto"></friend-toggle-locked>
        </div>
        <hr class="" />

        <p class="mt-3 mb-1 font-12"><strong><i class='uil uil-notes'></i> メモ欄:</strong></p>
        <p class="text-prewrap max-3-lines">{{ friend.note || 'なし' }}</p>

        <p class="mt-3 mb-1 font-12"><strong><i class='uil uil-tag'></i> タグ:</strong></p>
        <p><friend-tag :tags="friend.tags"></friend-tag></p>

        <p class="mt-4 mb-1 font-12"><strong><i class='uil uil-clock'></i> 登録日時:</strong></p>
        <p>{{ friendAddedAt }}</p>
      </div>
    </div> <!-- end card-body -->
  </div> <!-- end card-->
</template>

<script>
import { mapState } from 'vuex';
import Util from '@/core/util';

export default {
  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH
    };
  },

  provide() {
    return { parentValidator: this.$validator };
  },

  computed: {
    ...mapState('channel', {
      activeChannel: state => state.activeChannel
    }),
    friend() {
      return this.activeChannel.line_friend;
    },
    friendAddedAt() {
      return Util.formattedDate(this.friend.created_at);
    },
    detailPath() {
      return `${this.rootPath}/user/friends/${this.friend.id}`;
    }
  }
};
</script>