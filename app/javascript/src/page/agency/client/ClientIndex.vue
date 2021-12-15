<template>
  <div>
    <div class="row">
      <div class="col-12">
        <div class="card">
          <div class="card-header d-flex align-items-center">
            <a :href="`${rootUrl}/agency/clients/new`" class="btn btn-info fw-120 mr-2">
              <i class="uil-plus"></i> 新規登録
            </a>
            <!-- START: Search form -->

            <div class="ml-auto d-flex">
              <select class="form-control fw-150 mr-1" v-model="queryParams.status_eq">
                <option value="">すべて</option>
                <option value="active">有効</option>
                <option value="blocked">無効</option>
              </select>

              <div class="input-group app-search">
                <input
                  type="text"
                  class="form-control dropdown-toggle fw-250"
                  placeholder="検索..."
                  v-model="queryParams.name_cont"
                />
                <span class="mdi mdi-magnify search-icon"></span>
                <div class="input-group-append">
                  <div class="btn btn-info" @click="loadClients">検索</div>
                </div>
              </div>
            </div>
            <!-- End: Search form -->
          </div>

          <div class="card-body">
            <div class="table-responsive">
              <table class="table table-centered mb-0">
                <thead class="thead-light">
                  <tr>
                    <th>ID</th>
                    <th>クライアント名</th>
                    <th>公式アカウント名</th>
                    <th>管理者メール</th>
                    <th>状況</th>
                    <th class="fw-200">操作</th>
                  </tr>
                </thead>
                <tbody v-for="(client, index) in clients" :key="client.id">
                  <tr>
                    <td>
                      <span>{{ client.id }}</span>
                    </td>
                    <td>{{ client.name }}</td>
                    <td>{{ client.line_name }}</td>
                    <td>{{ client.admin_email }}</td>
                    <td><client-status :client="client"></client-status></td>
                    <td>
                      <div class="btn-group">
                        <button
                          type="button"
                          class="btn btn-light btn-sm dropdown-toggle"
                          id="dropdownMenuUser"
                          data-toggle="dropdown"
                          aria-haspopup="true"
                          aria-expanded="false"
                        >
                          操作 <span class="caret"></span>
                        </button>
                        <div class="dropdown-menu" aria-labelledby="dropdownMenuUser">
                          <a :href="`${rootUrl}/agency/clients/${client.id}/edit`" role="button" class="dropdown-item"
                            >クライアントを編集</a
                          >
                          <a
                            class="dropdown-item"
                            role="button"
                            data-toggle="modal"
                            data-target="#modalToggleStatusUser"
                            @click="curClientIndex = index"
                          >
                            <span v-if="client.status === 'active'">ブロックする</span>
                            <span v-else>ブロック解除する</span>
                          </a>
                          <!-- <a
                            role="button"
                            class="dropdown-item"
                            data-toggle="modal"
                            data-target="#modalDeleteUser"
                            @click="curClientIndex = index"
                            >クライアントを削除</a
                          > -->
                        </div>
                      </div>
                      <a :href="`${rootUrl}/agency/clients/${client.id}/sso`" class="btn btn-sm btn-info">ログイン</a>
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
                @change="loadClients"
                aria-controls="my-table"
              ></b-pagination>
              <div class="my-5 font-weight-bold text-center" v-if="!loading && totalRows === 0">
                データはありません。
              </div>
            </div>
          </div>
          <loading-indicator :loading="loading"></loading-indicator>
        </div>
      </div>
    </div>
    <!-- START: Toggle status (active/blocked) -->
    <modal-confirm
      title="このクライアントの状況を変更してもよろしいですか？"
      id="modalToggleStatusUser"
      type="confirm"
      @confirm="submitToggleStatus"
    >
      <template v-slot:content>
        <div v-if="curClient">
          <b>{{ curClient.status === "active" ? "有効" : "ブロックした" }}</b> <i class="mdi mdi-arrow-right-bold"></i>
          <b>{{ curClient.status === "active" ? "ブロックした" : "有効" }}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Toggle status (active/blocked) -->
    <!-- START: Delete client modal -->
    <modal-confirm
      title="こちらのクライアントを削除してよろしいですが?"
      id="modalDeleteUser"
      type="delete"
      @confirm="submitDeleteClient"
    >
      <template v-slot:content>
        <div v-if="curClient">
          メールアドレス: <b>{{ curClient.email }}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Delete client modal -->
  </div>
</template>
<script>
import { mapActions, mapGetters, mapMutations, mapState } from 'vuex';
import Util from '@/core/util';

export default {
  data() {
    return {
      rootUrl: process.env.MIX_ROOT_PATH,
      currentPage: 1,
      contentKey: 0,
      loading: true,
      curClientIndex: 0,
      isSearch: false,
      queryParams: null
    };
  },
  created() {
    this.queryParams = _.cloneDeep(this.getQueryParams);
  },
  async beforeMount() {
    await this.getClients();
    this.loading = false;
  },

  computed: {
    ...mapGetters('client', ['getQueryParams']),
    ...mapState('client', {
      clients: state => state.clients,
      totalRows: state => state.totalRows,
      perPage: state => state.perPage
    }),

    curClient() {
      return this.clients[this.curClientIndex];
    }
  },
  methods: {
    ...mapMutations('client', ['setCurPage', 'setQueryParams']),
    ...mapActions('client', ['getClients', 'deleteClient', 'updateClient', 'searchUsers']),

    forceRerender() {
      this.contentKey++;
    },

    async loadClients() {
      this.$nextTick(async() => {
        this.setQueryParams(this.queryParams);
        this.loading = true;
        this.getClients();
        this.forceRerender();
        this.loading = false;
      });
    },

    async submitDeleteClient() {
      const response = await this.deleteClient(this.curClient.id);
      if (response) {
        Util.showSuccessThenRedirect('クライアントの削除は完了しました。', `${this.rootUrl}/agency/clients`);
      } else window.toastr.error('クライアントの削除は失敗しました。');
    },

    async submitToggleStatus() {
      const data = {
        id: this.curClient.id,
        status: this.curClient.status === 'blocked' ? 'active' : 'blocked'
      };
      const response = await this.updateClient(data);
      if (response) {
        Util.showSuccessThenRedirect('クライアント状況の変更は完了しました。', `${this.rootUrl}/agency/clients`);
      } else {
        window.toastr.error('クライアント状況の変更は失敗しました。');
      }
    }
  }
};
</script>