<template>
  <div
    class="modal fade modal-common01"
    id="modalTagFriends"
    tabindex="-1"
    role="dialog"
    aria-labelledby="myModalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document" v-if="tag">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="info-header-modalLabel">つけたタグ「{{ tag.name || "未設定" }}」の友達一覧</h5>
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        </div>
        <div class="modal-body mvh-40">
          <table class="table table-centered mt-2">
            <thead class="thead-light">
              <tr>
                <th>名前</th>
                <th>登録日時</th>
                <th>状況</th>
                <th class="fw-150">操作</th>
              </tr>
            </thead>
            <tbody v-for="(friend, index) in friends" :key="index">
              <tr>
                <td class="table-user">
                  <img v-lazy="avatarImgObj" alt="table-user" class="mr-2 rounded-circle" />
                  {{ friend.line_name }}
                </td>
                <td>{{ formattedDatetime(friend.created_at) }}</td>
                <td>
                  <friend-status
                    :status="friend.status"
                    :locked="friend.locked"
                    :visible="friend.visible"
                  ></friend-status>
                </td>
                <td>
                  <a :href="`${rootUrl}/user/friends/${friend.id}`" class="btn btn-sm btn-light">詳細</a>
                </td>
              </tr>
            </tbody>
          </table>
          <div class="d-flex justify-content-center mt-4 text-center">
            <b-pagination
              v-if="totalRows > perPage"
              v-model="curPage"
              :total-rows="totalRows"
              :per-page="perPage"
              @change="loadPage"
              aria-controls="my-table"
            ></b-pagination>
            <b v-if="!loading && totalRows === 0">友達はありません。</b>
          </div>
          <loading-indicator :loading="loading"></loading-indicator>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, computed, watch, onMounted, nextTick } from 'vue'
import { useStore } from 'vuex'
import Util from '@/core/util'

const props = defineProps({
  tag: {
    type: Object,
    required: true
  }
})

const store = useStore()

const rootUrl = process.env.MIX_ROOT_PATH
const loading = ref(false)
const avatarImgObj = ref({
  src: '',
  error: '/img/no-image-profile.png',
  loading: '/images/loading.gif'
})

const queryParams = computed(() => store.state.friend.queryParams)
const friends = computed(() => store.state.friend.friends)
const totalRows = computed(() => store.state.friend.totalRows)
const perPage = computed(() => store.state.friend.perPage)

const curPage = computed({
  get() {
    return queryParams.value.page
  },
  set(value) {
    setQueryParam({ page: value })
  }
})

const resetFriends = () => store.commit('friend/resetFriends')
const setQueryParam = (payload) => store.commit('friend/setQueryParam', payload)
const getFriends = () => store.dispatch('friend/getFriends')

onMounted(() => {
  avatarImgObj.value.src = ''
})

watch(() => props.tag, () => {
  // Handle tag changed
  resetFriends()
  // Show all friends, included locked, invisible, blocked friend
  setQueryParam({ tags_id_in: props.tag.id, visible_eq: null, locked_eq: null, status_eq: null })
  loadPage()
})

const loadPage = async () => {
  await nextTick()
  loading.value = true
  await getFriends()
  loading.value = false
}

const formattedDatetime = (time) => {
  return Util.formattedDatetime(time)
}
</script>
