<template>
  <div>
    <div class="row">
      <div class="col-12">
        <div class="card">
          <div class="card-header d-flex align-items-center">
            <a :href="`${rootUrl}/user/friends/new`" class="btn btn-success fw-120 mr-2">
              <i class="uil-plus"></i> 新規登録
            </a>
            <!-- START: Search form -->
              <div class="ml-auto d-flex">
                <select class="form-control fw-150 mr-1" v-model="queryParams.status_eq">
                  <option value="">すべて</option>
                  <option value="active">正常</option>
                  <option value="blocked">ブロック中</option>
                </select>
                <div class="input-group app-search">
                  <input type="text" class="form-control dropdown-toggle fw-250" placeholder="検索..." v-model="queryParams.line_name_or_display_name_cont">
                  <span class="mdi mdi-magnify search-icon"></span>
                  <div class="input-group-append">
                    <div class="btn btn-primary" @click="loadFriend">検索</div>
                  </div>
                </div>
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
      </div>
    </div>
  </div>
</template>
<script>
import { mapActions, mapGetters, mapMutations, mapState } from 'vuex';
import Util from '@/core/util';

export default {
  data() {
    return {
      rootUrl: process.env.MIX_ROOT_PATH,
      loading: true,
      queryParams: null
    };
  },
  created() {
    this.queryParams = _.cloneDeep(this.getQueryParams);
  },
  async beforeMount() {
    await this.getFriends();
    this.loading = false;
  },
  computed: {
    ...mapGetters('friend', [
      'getQueryParams'
    ]),
    ...mapState('friend', {
      friends: (state) => state.friends,
      totalRows: (state) => state.totalRows,
      perPage: (state) => state.perPage
    })
  },
  methods: {
    ...mapMutations('friend', [
      'setQueryParams'
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