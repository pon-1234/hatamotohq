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
<script>
import moment from 'moment';
import { mapActions, mapMutations } from 'vuex';
export default {
  props: ['tag'],
  methods: {
    ...mapMutations('friend', ['setQueryParam']),
    ...mapActions('friend', ['getFriends']),

    getCreatedAt(item) {
      return moment(item).format('YYYY年MM月DD日');
    },

    deleteTag(query) {
      this.$emit('deleteTag', query);
    },

    editTag(query) {
      this.$emit('editTag', query);
    },

    createTag(query) {
      this.$emit('createTag', query);
    },

    async showFriends() {
      this.$emit('showFriends', this.tag);
    }
  }
};
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
