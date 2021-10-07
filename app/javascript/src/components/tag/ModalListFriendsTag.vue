<template>
  <div class="modal fade modal-common01" id="modal-friends-tag" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="info-header-modalLabel">Modal friends by {{ tag ? tag.name : '' }}</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
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
                  <img :src="friend.line_picture_url || '/img/no-image-profile.png'" alt="table-user" class="mr-2 rounded-circle" />
                  {{ friend.line_name }}
                </td>
                <td> {{ formattedDatetime(friend.created_at) }}</td>
                <td>
                  <friend-status :status="friend.status" :locked="friend.locked" :visible="friend.visible"></friend-status>
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
            <b v-if="!loading && totalRows === 0">シナリオはありません。</b>
          </div>
          <loading-indicator :loading="loading"></loading-indicator>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { mapState, mapActions, mapMutations } from 'vuex';
import Util from '@/core/util';
export default {
  data() {
    return {
      rootUrl: process.env.MIX_ROOT_PATH,
      loading: false
    };
  },
  computed: {
    ...mapState('friend', {
      queryParams: (state) => state.queryParams,
      friends: state => state.friends,
      totalRows: (state) => state.totalRows,
      perPage: (state) => state.perPage
    }),

    ...mapState('tag', {
      tag: (state) => state.tag
    }),

    curPage: {
      get() { return this.queryParams.page; },
      set(value) { this.setQueryParam({ page: value }); }
    }
  },
  methods: {
    ...mapMutations('friend', [
      'setQueryParam'
    ]),
    ...mapActions('friend', [
      'getFriends'
    ]),

    async loadPage() {
      this.$nextTick(async() => {
        this.loading = true;
        await this.getFriends();
        this.loading = false;
      });
    },

    formattedDatetime(time) {
      return Util.formattedDatetime(time);
    }
  }
};
</script>
<style lang="scss" scoped>
</style>
