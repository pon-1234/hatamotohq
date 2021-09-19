<template>
  <tr class="tag-item">
    <td style="min-width: 200px; vertical-align: middle;"><tag-item-editor :data="data" @deleteTag="deleteTag"  @editTag="editTag" @createTag="createTag"/></td>
    <td style="width: 5em; vertical-align: middle; text-align: left;">{{data.friends_count}}人&nbsp;<a class="detail-friend btn btn-default" data-toggle="modal" data-target="#modal-friends-tag" @click="showListFriends" v-if="data.line_friend_count > 0">表示</a></td>
    <td style="width: 10em; vertical-align: middle;">{{getCreatedAt(data.created_at)}}</td>
  </tr>
</template>
<script>
import moment from 'moment';

export default {
  props: ['data'],
  methods: {
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

    showListFriends() {
      this.$emit('detailFriends', this.data.line_friend);
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
