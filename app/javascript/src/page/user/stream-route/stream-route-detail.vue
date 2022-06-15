<template>
  <div>
    <div class="card mvh-50">
      <div class="card-body">
        <div>
          <table class="table table-centered mt-2 pc">
            <thead class="thead-light">
              <tr>
                <th class="d-lg-table-cell">タグ</th>
                <th class="d-lg-table-cell">名前</th>
                <th class="d-lg-table-cell">友だち追加日時</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="friend in friendList" :key="friend.id">
                <td class="d-lg-table-cell">
                  <FriendTag :tags="friend.tags"></FriendTag>
                </td>
                <td class="d-lg-table-cell">{{friend.name}}</td>
                <td class="d-lg-table-cell">{{friend.created_at | formatted_time}}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="d-flex justify-content-center mt-4">
          <b-pagination
            v-if="parseInt(totalRows) > parseInt(perPage)"
            :total-rows="totalRows"
            :per-page="perPage"
            v-model="curPage"
            @change="loadDetail"
            aria-controls="my-table"
          ></b-pagination>
        </div>
        <div class="text-center my-5 font-weight-bold" v-if="!loading && totalRows === 0">データはありません。</div>
      </div>
      <loading-indicator :loading="loading"></loading-indicator>
    </div>
  </div>
</template>

<script>
import { mapActions, mapMutations, mapState } from 'vuex';

export default {
  props: ['stream_route_id'],
  data() {
    return {
      rootUrl: process.env.MIX_ROOT_PATH,
      loading: true
    };
  },

  async beforeMount() {
    this.setQueryParam({ streamRouteId: this.stream_route_id });
    await this.getStreamRouteDetail();
    this.loading = false;
  },

  computed: {
    ...mapState('streamRoute', {
      friendList: state => state.friendList,
      totalRows: state => state.totalRows,
      perPage: state => state.perPage,
      queryParams: state => state.queryParams
    }),

    curPage: {
      get() {
        return this.queryParams.page;
      },
      set(value) {
        this.setQueryParam({ page: value });
      }
    }
  },

  methods: {
    ...mapMutations('streamRoute', ['setQueryParams', 'setQueryParam']),
    ...mapActions('streamRoute', ['getStreamRouteDetail']),

    loadDetail() {
      this.$nextTick(async() => {
        this.setQueryParams(this.queryParams);
        this.loading = true;
        this.getStreamRouteDetail();
        this.loading = false;
      });
    }
  }
};
</script>
