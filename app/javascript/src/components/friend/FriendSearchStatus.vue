<template>
  <div v-if="isSearching" class="d-flex align-items-center text-sm">
    <div class="mr-3">検索条件：</div>
    <div class="border rounded p-1 mr-2" v-if="!!queryParams.line_name_or_display_name_cont">
      <span>名前に<b>({{ queryParams.line_name_or_display_name_cont }})</b>をふくむ</span>
    </div>
    <div class="border rounded p-1 mr-2" v-if="queryParams.tags_id_in && queryParams.tags_id_in.length > 0">
      <span class="mr-1">タグ</span>
      <span class="badge badge-pill badge-warning pt-1" v-for="(tag_id, index) in queryParams.tags_id_in" :key="index">{{ getTagNameById(tag_id) }}</span>
    </div>
    <div class="border rounded p-1 mr-2" v-if="queryParams.created_at_gteq && queryParams.created_at_lteq">
      <span class="mr-1">登録日時</span>
      <b>{{ formattedDate(queryParams.created_at_gteq) }} ~ {{ formattedDate(queryParams.created_at_lteq) }}</b>
    </div>
    <div class="border rounded p-1 mr-2" v-if="queryParams.visible_eq === null">
      <span class="mr-1">自分が非表示した友達を表示</span>
    </div>
    <div class="border rounded p-1 mr-2" v-if="queryParams.locked_eq === null">
      <span class="mr-1">自分がブロックした友達を表示</span>
    </div>
    <div class="btn btn-xs btn-primary ml-1 text-nowrap" @click="clearSearch()">クリア</div>
  </div>
</template>

<script>
import { mapActions, mapMutations, mapState } from 'vuex';
import Util from '@/core/util';

export default {
  computed: {
    ...mapState('friend', {
      queryParams: (state) => state.queryParams
    }),
    ...mapState('tag', {
      tagFolders: (state) => state.folders
    }),

    isSearching() {
      return this.queryParams.line_name_or_display_name_cont ||
        !_.isEmpty(this.queryParams.tags_id_in) ||
        this.queryParams.created_at_gteq ||
        this.queryParams.visible_eq === null ||
        this.queryParams.locked_eq === null;
    }
  },
  methods: {
    ...mapMutations('friend', [
      'resetQueryParams'
    ]),
    ...mapActions('friend', [
      'getFriends'
    ]),

    getTagNameById(id) {
      const tags = _.flatten(this.tagFolders.map(_ => _.tags));
      const tag = tags.find(_ => _.id === id);
      if (tag) {
        return tag.name;
      }
    },

    async clearSearch() {
      this.resetQueryParams();
      await this.getFriends();
    },

    formattedDate(date) {
      return Util.formattedDate(date);
    }
  }
};
</script>

<style lang="scss" scoped>
  .text-sm {
    font-size: 0.7rem !important;
  }
</style>