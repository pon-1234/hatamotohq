<template>
  <div class="card chat-panel" v-if="activeChannel">
    <div class="card-header d-block d-xl-none">
      <a class="icon-fs" @click="hideUserDetail()"><i class="uil-multiply"></i></a>
    </div>
    <div class="card-body">
      <div class="mt-3 text-center">
        <img v-lazy="genAvatarImgObj(friend.avatar_url)" class="img-thumbnail avatar-lg rounded-circle" />
        <h4>
          {{ (friend.display_name || friend.line_name) | truncate(15)
          }}<span v-if="friend.tester" class="ml-1 pt-1 badge badge-warning badge-sm">テスター</span>
        </h4>
      </div>

      <div class="mt-3">
        <div class="d-flex align-items-center justify-content-center" v-if="isAdmin">
          <a :href="detailPath" class="btn btn-primary btn-sm mr-1 ml-auto fw-80">詳細</a>
          <template v-if="friend.locked">
            <div class="btn btn-sm btn-info mr-auto" data-toggle="modal" data-target="#modalConfirmToggleLocked">
              アンブロック
            </div>
          </template>
          <template v-else>
            <div class="btn btn-sm btn-danger mr-auto" data-toggle="modal" data-target="#modalConfirmToggleLocked">
              ブロック
            </div>
          </template>
        </div>
        <hr class="" />
        <div class="channel-info" :style="isStaffSelectOpened ? `padding-top: ${(staffCount > 0 ? staffCount-1 : 0)*50}px` : ''">
          <template v-if="isAdmin">
            <!-- START: 担当者 -->
            <p class="mt-3 mb-1 font-12">
              <strong><i class="uil uil-user"></i> 担当者:</strong>
            </p>
            <p><channel-assignment :key="contentKey" :channel="activeChannel" @open="openStaffSelect" @close="isStaffSelectOpened = false"></channel-assignment></p>
            <!-- END: 担当者 -->
          </template>

          <p class="mt-3 mb-1 font-12">
            <strong><i class="uil uil-notes"></i> メモ欄:</strong>
          </p>
          <p class="text-prewrap max-3-lines">{{ friend.note || "なし" }}</p>

          <p class="mt-3 mb-1 font-12">
            <strong><i class="uil uil-tag"></i> タグ:</strong>
          </p>
          <p><friend-tag :tags="friend.tags"></friend-tag></p>

          <p class="mt-4 mb-1 font-12">
            <strong><i class="uil uil-clock"></i> 登録日時:</strong>
          </p>
          <p>{{ friendAddedAt }}</p>
        </div>
      </div>
    </div>
    <!-- end card-body -->
  </div>
  <!-- end card-->
</template>

<script>
import { mapState, mapMutations } from 'vuex';
import Util from '@/core/util';

export default {
  props: {
    // TODO: using a state to store user profile, do not passing prop
    role: String
  },

  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH,
      contentKey: 0,
      isStaffSelectOpened: false,
      staffCount: 0
    };
  },

  provide() {
    return { parentValidator: this.$validator };
  },

  watch: {
    activeChannel: {
      handler(val) {
        this.forceRerender();
      }
    }
  },

  computed: {
    ...mapState('channel', {
      activeChannel: state => state.activeChannel,
      showUserDetail: state => state.showUserDetail
    }),
    friend() {
      return this.activeChannel.line_friend;
    },
    friendAddedAt() {
      return Util.formattedDate(this.friend.created_at);
    },
    detailPath() {
      return `${this.rootPath}/user/friends/${this.friend.id}`;
    },
    isAdmin() {
      return this.role === 'admin';
    }
  },
  methods: {
    ...mapMutations('channel', ['setShowUserDetail']),

    forceRerender() {
      this.contentKey++;
    },

    hideUserDetail() {
      if (this.showUserDetail) this.setShowUserDetail(false);
    },

    genAvatarImgObj(url) {
      const avatarImgObj = {
        src: url,
        error: '/img/no-image-profile.png',
        loading: '/images/loading.gif'
      };
      return avatarImgObj;
    },
    openStaffSelect(staffCount) {
      this.isStaffSelectOpened = true;
      this.staffCount = staffCount;
    }
  }
};
</script>
<style lang="scss" scoped>
  .icon-fs {
    font-size: 1.5rem;
    cursor: pointer;
  }

  @media (max-width: 767px) {
    .chat-panel {
      height: calc(100vh - 50px);
    }
  }

  @media (max-width: 767px) {
    .chat-panel {
      height: calc(100vh - 25px);
    }
  }

  @media (max-width: 1400px) and (min-width: 1000px) {
    .channel-info {
      height: 250px;
      overflow-y: scroll;
    }
  }
</style>