<template>
  <div>
    <div class="row">
      <div class="col-12">
        <div class="card">
          <div class="card-header d-flex align-items-center">
            <a :href="`${rootUrl}/admin/accounts/new`" class="btn btn-info fw-120 mr-2">
              <i class="uil-plus"></i> 新規登録
            </a>
            <!-- START: Search form -->
            <div class="ml-auto d-flex">
              <div class="input-group app-search">
                <input
                  type="text"
                  class="form-control dropdown-toggle fw-250"
                  placeholder="検索..."
                  v-model="queryParams.name_or_email_cont"
                />
                <span class="mdi mdi-magnify search-icon"></span>
                <div class="input-group-append">
                  <div class="btn btn-info" @click="loadAccounts">検索</div>
                </div>
              </div>
            </div>
            <!-- End: Search form -->
          </div>
          <div class="card-body">
            <div class="table-responsive">
              <div class="table-responsive">
                <table class="table table-centered mb-0">
                  <thead class="thead-light">
                    <tr>
                      <th class="fw-80">ID</th>
                      <th class="mxw-400">氏名</th>
                      <th class="fw-150">権限ラベル</th>
                      <th class="fw-300">メールアドレス</th>
                      <th class="fw-200">登録日時</th>
                      <th class="fw-100">操作</th>
                    </tr>
                  </thead>
                  <tbody v-for="(account, index) in accounts" :key="account.id">
                    <tr>
                      <td>
                        <span>{{ account.id }}</span>
                      </td>
                      <td class="mxw-400">{{ account.name }}</td>
                      <td>{{ account.role === "superadmin" ? "ルート管理者" : "システム管理者" }}</td>
                      <td class="fw-300">{{ account.email }}</td>
                      <td>{{ formattedDatetime(account.created_at) }}</td>
                      <td>
                        <button
                          type="button"
                          class="btn btn-light btn-sm dropdown-toggle"
                          id="dropdownMenuAccount"
                          data-toggle="dropdown"
                          aria-haspopup="true"
                          aria-expanded="false"
                        >
                          操作 <span class="caret"></span>
                        </button>
                        <div class="dropdown-menu" aria-labelledby="dropdownMenuAccount">
                          <a :href="`${rootUrl}/admin/accounts/${account.id}/edit`" role="button" class="dropdown-item"
                            >管理者を編集</a
                          >
                          <a
                            role="button"
                            class="dropdown-item"
                            data-toggle="modal"
                            data-target="#modalDeleteAccount"
                            @click="curAccountIndex = index"
                            v-if="account.role === 'admin'"
                            >管理者を削除</a
                          >
                        </div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
            <div class="d-flex justify-content-center mt-4">
              <b-pagination
                v-if="totalRows > perPage"
                v-model="queryParams.page"
                :total-rows="totalRows"
                :per-page="perPage"
                @change="loadAccounts"
                aria-controls="my-table"
              ></b-pagination>
            </div>
            <div class="my-5 text-center font-weight-bold" v-if="!loading && totalRows === 0">データはありません。</div>
          </div>
          <loading-indicator :loading="loading"></loading-indicator>
        </div>
      </div>
    </div>

    <!-- START: Toggle status (active/blocked) -->
    <modal-confirm
      title="このユーザーの状況を変更してもよろしいですか？"
      id="modalToggleStatusAccount"
      type="confirm"
      @confirm="submitToggleStatus"
    >
      <template v-slot:content>
        <div v-if="curAccount">
          <b>{{ curAccount.status === "active" ? "有効" : "ブロックした" }}</b>
          <i class="mdi mdi-arrow-right-bold"></i> <b>{{ curAccount.status === "active" ? "ブロックした" : "有効" }}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Toggle status (active/blocked) -->
    <!-- START: Delete user modal -->
    <modal-confirm
      title="こちらのユーザーを削除してよろしいですが?"
      id="modalDeleteAccount"
      type="delete"
      @confirm="submitDeleteACcount"
    >
      <template v-slot:content>
        <div v-if="curAccount">
          メールアドレス: <b>{{ curAccount.name | truncate(64) }}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Delete user modal -->
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
      curAccountIndex: 0,
      queryParams: null
    };
  },

  created() {
    this.queryParams = _.cloneDeep(this.getQueryParams);
  },

  async beforeMount() {
    await this.getAccounts();
    this.loading = false;
  },

  computed: {
    ...mapGetters('account', ['getQueryParams']),
    ...mapState('account', {
      accounts: state => state.accounts,
      totalRows: state => state.totalRows,
      perPage: state => state.perPage
    }),

    curAccount() {
      return this.accounts[this.curAccountIndex];
    }
  },
  methods: {
    ...mapMutations('account', ['setCurPage', 'setQueryParams']),
    ...mapActions('account', ['getAccounts', 'deleteAccount', 'updateAccount']),

    forceRerender() {
      this.contentKey++;
    },

    loadAccounts() {
      this.$nextTick(async() => {
        this.setQueryParams(this.queryParams);
        this.loading = true;
        this.getAccounts();
        this.forceRerender();
        this.loading = false;
      });
    },

    formattedDatetime(time) {
      return Util.formattedDatetime(time);
    },

    async submitDeleteACcount() {
      const response = await this.deleteAccount(this.curAccount.id);
      if (response) Util.showSuccessThenRedirect('ユーザー削除は完了しました。', `${this.rootUrl}/admin/accounts`);
      else window.toastr.error('ユーザーの削除は失敗しました。');
    },

    async submitToggleStatus() {
      const data = {
        id: this.curAccount.id,
        status: this.curAccount.status === 'blocked' ? 'active' : 'blocked'
      };
      const response = await this.updateAccount(data);
      if (response) {
        Util.showSuccessThenRedirect('ユーザー状況の変更は完了しました。', `${this.rootUrl}/admin/accounts`);
      } else {
        window.toastr.error('ユーザー状況の変更は失敗しました。');
      }
    }
  }
};
</script>
<style lang="scss" scoped>
</style>