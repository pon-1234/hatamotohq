<template>
  <div class="card chat-panel">
    <div class="card-body" v-if="activeChannel">
      <div class="dropdown float-right">
        <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown"
          aria-expanded="false">
          <i class="mdi mdi-dots-horizontal"></i>
        </a>
        <div class="dropdown-menu dropdown-menu-right">
          <!-- item-->
          <a :href="detailPath" class="dropdown-item">友達詳細</a>
          <!-- item-->
          <a href="javascript:void(0);" class="dropdown-item">ミュート</a>
        </div>
      </div>

      <div class="mt-3 text-center">
        <img :src="activeChannel.line_friend.avatar_url || '/img/no-image-profile.png'" alt="shreyu"
          class="img-thumbnail avatar-lg rounded-circle" />
        <h4>{{ activeChannel.line_friend.name }}</h4>
      </div>

      <div class="mt-3">
        <hr class="" />

        <p class="mt-4 mb-1"><strong><i class='uil uil-at'></i> メール:</strong></p>
        <p>未設定</p>

        <p class="mt-3 mb-1"><strong><i class='uil uil-phone'></i> 電話番号:</strong></p>
        <p>未設定</p>

        <p class="mt-3 mb-1"><strong><i class='uil uil-location'></i> 住所:</strong></p>
        <p>未設定</p>
      </div>
    </div> <!-- end card-body -->
  </div> <!-- end card-->
</template>

<script>
import { mapState } from 'vuex';
export default {
  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH
    };
  },
  computed: {
    ...mapState('channel', {
      activeChannel: state => state.activeChannel
    }),
    friend() {
      return this.activeChannel.line_friend;
    },
    detailPath() {
      return `${this.rootPath}/user/friends/${this.friend.id}`;
    }
  }
};
</script>