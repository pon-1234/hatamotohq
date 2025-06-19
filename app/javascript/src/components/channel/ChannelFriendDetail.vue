<template>
  <div class="card chat-panel" v-if="activeChannel">
    <div class="card-header d-block d-xl-none">
      <a class="icon-fs" @click="hideUserDetail()"><i class="uil-multiply"></i></a>
    </div>
    <div class="card-body">
      <div class="mt-3 text-center">
        <img v-lazy="genAvatarImgObj(friend.avatar_url)" class="img-thumbnail avatar-lg rounded-circle" />
        <h4>
          {{ truncate(friend.display_name || friend.line_name, 15) }}
          <span v-if="friend.tester" class="ml-1 pt-1 badge badge-warning badge-sm">テスター</span>
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
            <p>
              <channel-assignment 
                :key="contentKey" 
                :channel="activeChannel" 
                @open="openStaffSelect" 
                @close="isStaffSelectOpened = false"
              />
            </p>
            <!-- END: 担当者 -->
          </template>

          <p class="mt-3 mb-1 font-12">
            <strong><i class="uil uil-notes"></i> メモ欄:</strong>
          </p>
          <p class="text-prewrap max-3-lines">{{ friend.note || "なし" }}</p>

          <p class="mt-3 mb-1 font-12">
            <strong><i class="uil uil-tag"></i> タグ:</strong>
          </p>
          <p><friend-tag :tags="friend.tags" /></p>

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

<script setup>
import { ref, computed, watch } from 'vue'
import { useStore } from 'vuex'
import Util from '@/core/util'

const props = defineProps({
  role: String
})

const store = useStore()

const rootPath = process.env.MIX_ROOT_PATH
const contentKey = ref(0)
const isStaffSelectOpened = ref(false)
const staffCount = ref(0)

const activeChannel = computed(() => store.state.channel.activeChannel)
const showUserDetail = computed(() => store.state.channel.showUserDetail)
const friend = computed(() => activeChannel.value?.line_friend || {})
const friendAddedAt = computed(() => Util.formattedDate(friend.value.created_at))
const detailPath = computed(() => `${rootPath}/user/friends/${friend.value.id}`)
const isAdmin = computed(() => props.role === 'admin')

watch(activeChannel, () => {
  forceRerender()
})

const setShowUserDetail = (value) => {
  store.commit('channel/setShowUserDetail', value)
}

const forceRerender = () => {
  contentKey.value++
}

const hideUserDetail = () => {
  if (showUserDetail.value) setShowUserDetail(false)
}

const genAvatarImgObj = (url) => {
  return {
    src: url || '/img/no-image-profile.png',
    error: '/img/no-image-profile.png',
    loading: '/images/loading.gif'
  }
}

const openStaffSelect = (count) => {
  isStaffSelectOpened.value = true
  staffCount.value = count
}

const truncate = (str, length) => {
  if (!str) return ''
  return str.length > length ? str.substring(0, length) + '...' : str
}
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
    .channel-info {
      padding-top: unset !important;
    }
  }

  @media (max-width: 767px) {
    .chat-panel {
      height: calc(100vh - 25px);
    }
  }

  @media (min-width: 767.1px) and (max-width: 999.9px) {
    .channel-info {
      padding-top: unset !important;
    }
  }

  @media (max-width: 1400px) and (min-width: 1000px) {
    .channel-info {
      height: 250px;
      overflow-y: scroll;
    }
  }

  @media (min-width: 1400.1px) {
    .channel-info {
      padding-top: unset !important;
    }
  }

</style>