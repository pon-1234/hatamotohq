<template>
  <div>
    <div class="card">
      <div class="card-header d-flex align-items-center">
        <a :href="`${rootUrl}/user/friends/new`" class="btn btn-success fw-120 mr-2">
          <i class="uil-plus"></i> 新規登録
        </a>
        <!-- START: Search form -->
          <div class="ml-auto d-flex">
            <div class="input-group app-search">
              <input type="text" class="form-control dropdown-toggle fw-250" placeholder="検索..." v-model="keyword">
              <span class="mdi mdi-magnify search-icon"></span>
              <div class="input-group-append">
                <div class="btn btn-primary" @click="loadFriend">検索</div>
              </div>
            </div>
            <div class="btn btn-primary text-nowrap ml-1" data-toggle="modal" data-target="#modalFriendSearch">詳細検索</div>
          </div>
        <!-- End: Search form -->
      </div>
      <div class="card-body">
        <table class="table table-centered mb-0">
          <thead class="thead-light">
            <tr>
              <th>名前</th>
              <th>登録日時</th>
              <th>タグ</th>
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
                <friend-tag :tags="friend.tags"></friend-tag>
              </td>
              <td>
                <friend-status :status="friend.status"></friend-status>
              </td>
              <td>
                <a :href="`${rootUrl}/user/friends/${friend.id}`" class="btn btn-sm btn-light">詳細</a>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="d-flex justify-content-center mt-4">
        <b-pagination
          v-if="totalRows > perPage"
          v-model="queryParams.page"
          :total-rows="totalRows"
          :per-page="perPage"
          @change="loadFriend"
          aria-controls="my-table"
        ></b-pagination>
        <b v-if="!loading && totalRows === 0">データはありません。</b>
      </div>
      <loading-indicator :loading="loading"></loading-indicator>
    </div>
    <modal-friend-search></modal-friend-search>
  </div>
</template>
<script>
import { mapActions, mapMutations, mapState } from 'vuex';
import Util from '@/core/util';

export default {
  data() {
    return {
      rootUrl: process.env.MIX_ROOT_PATH,
      loading: true
    };
  },
  async beforeMount() {
    await this.getFriends();
    this.loading = false;
  },
  computed: {
    ...mapState('friend', {
      queryParams: (state) => state.queryParams,
      friends: (state) => state.friends,
      totalRows: (state) => state.totalRows,
      perPage: (state) => state.perPage
    }),

    keyword: {
      get() {
        return this.queryParams.line_name_or_display_name_cont;
      },

      set(value) {
        this.setQueryParam({ line_name_or_display_name_cont: value });
      }
    },

    status_eq: {
      get() {
        return this.queryParams.status_eq;
      },

      set(value) {
        this.setQueryParam({ status_eq: value });
      }
    }
  },
  methods: {
    ...mapMutations('friend', [
      'setQueryParams',
      'setQueryParam'
    ]),
    ...mapActions('friend', [
      'getFriends'
    ]),

    formattedDatetime(time) {
      return Util.formattedDatetime(time);
    },

    loadFriend() {
      this.$nextTick(async() => {
        this.setQueryParams(this.queryParams);
        this.loading = true;
        this.getFriends();
        this.loading = false;
      });
    }
  }
};
</script>
<style lang="scss" scoped>
</style>