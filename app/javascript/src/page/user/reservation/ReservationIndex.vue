<template>
  <div>
    <div class="card mvh-50">
      <div class="card-header d-flex justify-content-end">
        <div class="d-flex text-nowrap">
          <select class="form-control fw-150 mr-1" v-model="queryParams.status_eq">
            <option value="">状況：すべて</option>
            <option value="done">完了</option>
            <option value="wait">空室待ち</option>
            <option value="cancelled">キャンセル済</option>
          </select>
          <div class="input-group app-search">
            <input
              type="text"
              class="form-control dropdown-toggle fw-250"
              placeholder="検索..."
              v-model="keyword"
              maxlength="64"
            />
            <span class="mdi mdi-magnify search-icon"></span>
            <div class="input-group-append">
              <div class="btn btn-primary" @click="loadReservations">検索</div>
            </div>
          </div>
        </div>
        <!-- End: Search form -->
      </div>
      <div class="card-body">
        <div>
          <table class="table table-centered mt-2 pc">
            <thead class="thead-light">
              <tr>
                <th class="d-none d-lg-table-cell">予約日時</th>
                <th>お客様名</th>
                <th>ルーム名</th>
                <th>状況</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(reservation, index) in reservations" :key="index">
                <td class="fw-200">{{ reservation.created_at | formatted_date }}</td>
                <td class="table-user d-flex align-items-center">
                  <img v-lazy="genAvatarImgObj(reservation)" alt="table-user" class="mr-2 rounded-circle" />
                  <p class="m-0">{{ reservation.customer_name }}</p>
                </td>
                <td>{{ reservation.room_name }}</td>
                <td class="d-none d-lg-table-cell fw-200">
                  <reservation-status :status="reservation.status"></reservation-status>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="d-flex justify-content-center mt-4">
          <base-pagination
            v-if="totalRows > perPage"
            v-model="curPage"
            :total-rows="totalRows"
            :per-page="perPage"
            @change="loadFriend"
            aria-controls="my-table"
          ></base-pagination>
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
  props: {
    role: String
  },

  data() {
    return {
      rootUrl: process.env.MIX_ROOT_PATH,
      loading: true
    };
  },

  async beforeMount() {
    await this.getReservations();
    this.loading = false;
  },

  computed: {
    ...mapState('reservation', {
      queryParams: state => state.queryParams,
      reservations: state => state.reservations,
      totalRows: state => state.totalRows,
      perPage: state => state.perPage
    }),

    curPage: {
      get() {
        return this.queryParams.page;
      },
      set(value) {
        this.setQueryParam({ page: value });
      }
    },

    keyword: {
      get() {
        return this.queryParams.line_friend_line_name_or_line_friend_display_name_cont;
      },

      set(value) {
        this.setQueryParam({ line_friend_line_name_or_line_friend_display_name_cont: value });
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
    ...mapMutations('reservation', ['setQueryParams', 'setQueryParam']),
    ...mapActions('reservation', ['getReservations']),

    loadReservations() {
      this.$nextTick(async() => {
        this.setQueryParams(this.queryParams);
        this.loading = true;
        this.getReservations();
        this.loading = false;
      });
    },

    genAvatarImgObj(url) {
      const avatarImgObj = {
        src: url,
        error: '/img/no-image-profile.png',
        loading: '/images/loading.gif'
      };
      return avatarImgObj;
    }
  }
};
</script>
<style lang="scss" scoped>
  .text-ov {
    width: 100px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
</style>