<template>
  <tr class="tag-item">
    <td style="min-width: 200px; vertical-align: middle;"><tag-item-editor :data="data" @deleteTag="deleteTag"  @editTag="editTag" @createTag="createTag"/></td>
    <td class="fw-150">{{data.friends_count}}人&nbsp;
      <a class="btn-light btn-sm" data-toggle="modal" data-target="#modal-friends-tag" @click="showListFriends" v-if="data.friends_count > 0">
        表示
      </a>
    </td>
    <td class="fw-200">{{getCreatedAt(data.created_at)}}</td>
  </tr>
</template>
<script>
import moment from 'moment';
import { mapActions, mapMutations } from 'vuex';
export default {
  props: ['data'],
  methods: {
    ...mapMutations('tag', [
      'setTag'
    ]),
    ...mapActions('tag', [
      'getFriendsByTag'
    ]),

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

    async showListFriends() {
      this.setTag(this.data);
      await this.getFriendsByTag();
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
