<template>
  <div class="row">
    <div class="col-12">
      <div class="card">
        <div class="card-header d-flex align-items-center">
          <div class="btn btn-success fw-120" @click="openNew()"><i class="uil-plus"></i> 新規作成</div>
          <!-- START: Search form -->
          <div class="ml-auto d-flex">
            <select class="form-control fw-150 mr-1" v-model="queryParams.status_eq">
              <option value="">すべて</option>
              <option value="done">配信済</option>
              <option value="sending">配信中</option>
              <option value="pending">配信予約</option>
              <option value="error">エラー</option>
              <option value="draft">下書き</option>
            </select>
            <div class="input-group app-search">
              <input
                type="text"
                class="form-control dropdown-toggle fw-250"
                placeholder="検索..."
                id="top-search"
                v-model="queryParams.title_cont"
              />
              <span class="mdi mdi-magnify search-icon"></span>
              <div class="input-group-append">
                <div class="btn btn-primary" @click="search()">検索</div>
              </div>
            </div>
          </div>

          <!-- End: Search form -->
        </div>
        <div class="card-body mvh-50">
          <table class="table table-centered mb-0">
            <thead class="thead-light">
              <tr>
                <th>配信日時</th>
                <th>タイトル</th>
                <th>状況</th>
                <th>配信先</th>
                <th hidden>配信数</th>
                <th>操作</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(broadcast, index) in broadcasts" :key="index">
                <td>
                  <template v-if="broadcast.deliver_at">
                    {{ formattedDatetime(broadcast.deliver_at) }}
                  </template>
                  <template v-else>
                    <div>未配信</div>
                    <div>
                      <span class="text-sm">予約 {{ formattedDatetime(broadcast.schedule_at) }} </span>
                    </div>
                  </template>
                </td>
                <td class="mxw-300">{{ broadcast.title }}</td>
                <td class="fw-150"><broadcast-status :status="broadcast.status"></broadcast-status></td>
                <td class="fw-300"><broadcast-deliver-target :broadcast="broadcast"></broadcast-deliver-target></td>
                <td hidden></td>
                <td class="fw-150">
                  <div class="btn-group">
                    <button
                      type="button"
                      class="btn btn-light btn-sm dropdown-toggle"
                      data-toggle="dropdown"
                      aria-expanded="false"
                    >
                      操作 <span class="caret"></span>
                    </button>
                    <div class="dropdown-menu">
                      <a
                        role="button"
                        class="dropdown-item"
                        :href="`${rootPath}/user/broadcasts/${broadcast.id}/edit`"
                        target="_blank"
                        v-if="broadcast.editable"
                        >一斉配信を編集する</a
                      >
                      <a
                        role="button"
                        class="dropdown-item"
                        data-toggle="modal"
                        data-target="#modalcopyBroadcast"
                        @click="curBroadcastIndex = index"
                        >一斉配信をコピー</a
                      >
                      <a
                        role="button"
                        class="dropdown-item"
                        data-toggle="modal"
                        data-target="#modalDeleteBroadcast"
                        v-if="broadcast.destroyable"
                        @click="curBroadcastIndex = index"
                        >一斉配信を削除</a
                      >
                    </div>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
          <div class="d-flex justify-content-center mt-4 text-center">
            <b-pagination
              v-if="totalRows > perPage"
              v-model="queryParams.page"
              :total-rows="totalRows"
              :per-page="perPage"
              @change="loadPage()"
              aria-controls="my-table"
            ></b-pagination>
            <b v-if="!loading && totalRows === 0">一斉配信はありません。</b>
          </div>
        </div>

        <loading-indicator :loading="loading"></loading-indicator>
      </div>
    </div>

    <!-- START: Delete broadcast modal -->
    <modal-confirm
      title="この一斉配信を削除してもよろしいですか？"
      id="modalDeleteBroadcast"
      type="delete"
      @confirm="submitDeleteBroadcast"
    >
      <template v-slot:content>
        <div v-if="curBroadcast" class="text-truncate mxw-400">
          一斉配信名：<b>{{ curBroadcast.title }}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Delete broadcast modal -->

    <!-- START: Copy broadcast modal -->
    <modal-confirm
      title="この一斉配信をコピーしてもよろしいですか？"
      id="modalcopyBroadcast"
      type="confirm"
      @confirm="submitcopyBroadcast"
    >
      <template v-slot:content>
        <div v-if="curBroadcast" class="text-truncate mxw-400">
          一斉配信名：<b>{{ curBroadcast.title }}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Copy broadcast modal -->
  </div>
</template>

<script>
import { mapActions, mapGetters, mapMutations, mapState } from 'vuex';
import Util from '@/core/util';

export default {
  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH,
      loading: true,
      contentKey: 0,
      curBroadcastIndex: 0,
      queryParams: null
    };
  },

  created() {
    this.queryParams = _.cloneDeep(this.getQueryParams);
  },

  async beforeMount() {
    await this.getBroadcasts();
    this.loading = false;
  },

  computed: {
    ...mapGetters('user', ['getQueryParams']),
    ...mapState('broadcast', {
      broadcasts: state => state.broadcasts,
      totalRows: state => state.totalRows,
      perPage: state => state.perPage
    }),

    curBroadcast() {
      return this.broadcasts[this.curBroadcastIndex];
    }
  },

  methods: {
    ...mapMutations('broadcast', ['setCurPage', 'setQueryParams']),
    ...mapActions('broadcast', ['getBroadcasts', 'copyBroadcast', 'deleteBroadcast']),

    forceRerender() {
      this.contentKey++;
    },

    search() {
      this.queryParams.page = 0;
      this.loadPage();
    },

    async loadPage() {
      // bootstrap pagination return old value of current page,
      // using nextTick to solve the issue
      this.$nextTick(async() => {
        this.setQueryParams(this.queryParams);
        this.loading = true;
        this.getBroadcasts();
        this.forceRerender();
        this.loading = false;
      });
    },

    openNew() {
      window.location.href = `${process.env.MIX_ROOT_PATH}/user/broadcasts/new`;
    },

    openMessageIndex(broadcast) {
      window.open(`${process.env.MIX_ROOT_PATH}/user/broadcasts/${broadcast.id}/messages`);
    },

    formattedDatetime(time) {
      return Util.formattedDatetime(time);
    },

    async submitDeleteBroadcast() {
      const response = await this.deleteBroadcast(this.curBroadcast.id);
      if (response) {
        Util.showSuccessThenRedirect('一斉配信の削除は完了しました。', window.location.href);
      } else {
        window.toastr.error('一斉配信の削除は失敗しました。');
      }
    },

    async submitcopyBroadcast() {
      const response = await this.copyBroadcast(this.curBroadcast.id);
      if (response) {
        Util.showSuccessThenRedirect('一斉配信のコピーは完了しました。', window.location.href);
      } else {
        window.toastr.error('一斉配信のコピーは失敗しました。');
      }
    }
  }
};
</script>

<style lang="scss" scoped>
  .text-sm {
    font-size: 0.7rem !important;
  }
</style>