<template>
  <div v-if="isSearching" class="d-flex align-items-center text-sm flex-wrap">
    <div class="mr-3">検索条件：</div>
    <div class="border rounded p-1 mr-2 mb-1 pc" v-if="!!queryParams.line_name_or_display_name_cont">
      <span>名前に<b>({{ queryParams.line_name_or_display_name_cont }})</b>をふくむ</span>
    </div>
    <div class="border rounded p-1 mr-2 mb-1 pc" v-if="queryParams.tags_id_in && queryParams.tags_id_in.length > 0">
      <span class="mr-1">タグ</span>
      <span class="badge badge-pill badge-warning pt-1" v-for="(tag_id, index) in queryParams.tags_id_in" :key="index">{{ getTagNameById(tag_id) }}</span>
    </div>
    <div class="border rounded p-1 mr-2 mb-1 pc" v-if="queryParams.created_at_gteq && queryParams.created_at_lteq">
      <span class="mr-1">登録日時</span>
      <b>{{ formattedDate(queryParams.created_at_gteq) }} ~ {{ formattedDate(queryParams.created_at_lteq) }}</b>
    </div>
    <div class="border rounded p-1 mr-2 mb-1 pc" v-if="queryParams.visible_eq === null">
      <span class="mr-1">自分が非表示した友達を表示</span>
    </div>
    <div class="border rounded p-1 mr-2 mb-1 pc" v-if="queryParams.locked_eq === null">
      <span class="mr-1">自分がブロックした友達を表示</span>
    </div>
    <div class="border rounded p-1 mr-2 mb-1 pc" v-if="queryParams.tester_eq && queryParams.tester_eq == true">
      <span class="mr-1">テスターのみ</span>
    </div>
    <div class="btn btn-xs btn-primary ml-1 mb-1 text-nowrap" @click="clearSearch()">クリア</div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useStore } from 'vuex'
import Util from '@/core/util'

const store = useStore()

const queryParams = computed(() => store.state.friend.queryParams)
const tagFolders = computed(() => store.state.tag.folders)

const isSearching = computed(() => {
  return queryParams.value.line_name_or_display_name_cont ||
    (queryParams.value.tags_id_in && queryParams.value.tags_id_in.length > 0) ||
    queryParams.value.created_at_gteq ||
    queryParams.value.visible_eq === null ||
    queryParams.value.locked_eq === null
})

const getTagNameById = (id) => {
  const tags = tagFolders.value.flatMap(folder => folder.tags)
  const tag = tags.find(t => t.id === id)
  if (tag) {
    return tag.name
  }
}

const clearSearch = async () => {
  store.commit('friend/resetQueryParams')
  await store.dispatch('friend/getFriends')
  store.commit('friend/setClearQueryParams', true)
}

const formattedDate = (date) => {
  return Util.formattedDate(date)
}
</script>

<style lang="scss" scoped>
  .text-sm {
    font-size: 0.7rem !important;
  }
  .flex-wrap {
    flex-flow: wrap;
  }
  .pc {
    display: block;
  }
   @media (max-width: 1024px) {
    .pc {
      display: none;
    }
  }
</style>
