<template>
  <tr class="tag-item">
    <td style="min-width: 200px; vertical-align: middle">
      <tag-item-editor :data="tag" @deleteTag="deleteTag" @editTag="editTag" @createTag="createTag" />
    </td>
    <td class="fw-150">
      <span class="mt-2">{{ tag.friends_count }}人</span>
      <div
        role="button"
        class="btn btn-light btn-sm d-inline-block"
        data-toggle="modal"
        data-target="#modalTagFriends"
        @click="showFriends"
        v-if="tag.friends_count > 0"
      >
        表示
      </div>
    </td>
    <td class="fw-200">{{ getCreatedAt(tag.created_at) }}</td>
  </tr>
</template>
<script setup>
import moment from 'moment'
import { useStore } from 'vuex'

const props = defineProps(['tag'])
const emit = defineEmits(['deleteTag', 'editTag', 'createTag', 'showFriends'])

const store = useStore()

const setQueryParam = (payload) => store.commit('friend/setQueryParam', payload)
const getFriends = () => store.dispatch('friend/getFriends')

const getCreatedAt = (item) => {
  return moment(item).format('YYYY年MM月DD日')
}

const deleteTag = (query) => {
  emit('deleteTag', query)
}

const editTag = (query) => {
  emit('editTag', query)
}

const createTag = (query) => {
  emit('createTag', query)
}

const showFriends = async () => {
  emit('showFriends', props.tag)
}
</script>
<style lang="scss" scoped>
  .tag-item {
    background: white;
  }

  .detail-friend {
    color: #333;
    background-color: #fff;
    border-color: #ccc;
    padding: 1px 5px;
    font-size: 12px;
    line-height: 1.5;
    border-radius: 3px;
  }
</style>
