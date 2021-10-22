<template>
  <div>
    <div class="card mvh-50">
      <div class="card-header d-flex align-items-center">
        <!-- START: Search form -->
        <div class="ml-auto d-flex text-nowrap">
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
              <div class="btn btn-primary" @click="loadFriend">検索</div>
            </div>
          </div>
          <div
            class="btn btn-primary text-nowrap ml-1"
            data-backdrop="static"
            data-toggle="modal"
            data-target="#modalFriendSearch"
          >
            詳細検索
          </div>
        </div>
        <!-- End: Search form -->
      </div>
      <div class="card-body">
        <friend-search-status></friend-search-status>
        <div class="table-responsive">
          <table class="table table-centered mt-2 pc">
            <thead class="thead-light">
              <tr>
                <th>名前</th>
                <th class="d-none d-lg-table-cell">登録日時</th>
                <th class="d-none d-lg-table-cell">タグ</th>
                <th>状況</th>
                <th class="d-none d-lg-table-cell">操作</th>
              </tr>
            </thead>
            <tbody v-for="(friend, index) in friends" :key="index">
              <tr @click="isMobile ? redirectToFriendDetail(friend) : ''">
                <td class="table-user d-flex align-items-center">
                  <img
                    v-lazy="filterImage(friend.line_picture_url)"
                    alt="table-user"
                    class="mr-2 rounded-circle"
                  />
                  <p class="m-0">{{ friend.line_name }}</p>
                </td>
                <td class="d-none d-lg-table-cell">{{ formattedDatetime(friend.created_at) }}</td>
                <td class="d-none d-lg-table-cell">
                  <friend-tag :tags="friend.tags"></friend-tag>
                </td>
                <td>
                  <friend-status
                    :status="friend.status"
                    :locked="friend.locked"
                    :visible="friend.visible"
                  ></friend-status>
                </td>
                <td class="d-none d-lg-table-cell">
                  <a :href="`${rootUrl}/user/friends/${friend.id}`" class="btn btn-sm btn-light">詳細</a>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="d-flex justify-content-center mt-4">
          <b-pagination
            v-if="totalRows > perPage"
            v-model="curPage"
            :total-rows="totalRows"
            :per-page="perPage"
            @change="loadFriend"
            aria-controls="my-table"
          ></b-pagination>
          <b v-if="!loading && totalRows === 0">データはありません。</b>
        </div>
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
      loading: true,
      window: {
        width: 0
      }
    };
  },
  created() {
    window.addEventListener('resize', this.handleResize);
    this.handleResize();
  },
  destroyed() {
    window.removeEventListener('resize', this.handleResize);
  },
  async beforeMount() {
    await this.getFriends();
    this.loading = false;
  },
  computed: {
    ...mapState('friend', {
      queryParams: state => state.queryParams,
      friends: state => state.friends,
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
    },

    isMobile: function() {
      return this.window.width < 760;
    }
  },
  methods: {
    ...mapMutations('friend', ['setQueryParams', 'setQueryParam']),
    ...mapActions('friend', ['getFriends']),

    formattedDatetime(time) {
      return Util.formattedDatetime(time);
    },

    resetSearch() {
      this.keyword = '';
      this.getFriends();
    },

    loadFriend() {
      this.$nextTick(async() => {
        this.setQueryParams(this.queryParams);
        this.loading = true;
        this.getFriends();
        this.loading = false;
      });
    },

    redirectToFriendDetail(friend) {
      window.location.href = `${this.rootUrl}/user/friends/${friend.id}`;
    },

    handleResize() {
      this.window.width = window.innerWidth;
    },

    filterImage(url) {
      const imgObj = {
        src: url,
        error: '/img/no-image-profile.png',
        loading: '/images/loading.gif'
      };
      return imgObj;
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