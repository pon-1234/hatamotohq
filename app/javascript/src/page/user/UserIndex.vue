<template>
  <div>
    <div class="row">
      <div class="col-12">
        <div class="card">
          <div class="card-header d-flex align-items-center">
            <a :href="`${rootUrl}/admin/users/new`" class="btn btn-info fw-120 mr-2">
              <i class="uil-plus"></i> 新規登録
            </a>
            <!-- START: Search form -->

              <div class="ml-auto d-flex">
                <select class="form-control fw-150 mr-1" v-model="searchData.status">
                  <option value="">すべて</option>
                  <option value="active">有効</option>
                  <option value="blocked">無効</option>
                </select>

                <div class="input-group app-search">
                  <input type="text" class="form-control dropdown-toggle fw-250" placeholder="検索..." v-model="searchData.name">
                  <span class="mdi mdi-magnify search-icon"></span>
                  <div class="input-group-append">
                    <div class="btn btn-info" @click="loadPage('searchData')">検索</div>
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
                    <th>氏名</th>
                    <th>メールアドレス</th>
                    <th>会社名</th>
                    <th>登録日時</th>
                    <th>状況</th>
                    <th>操作</th>
                  </tr>
                </thead>
                <tbody v-for="(user, index) in users" :key="user.id">
                  <tr>
                    <td><a :href="`${rootUrl}/admin/users/${user.id}`">{{ user.id }}</a></td>
                    <td>{{ user.name }}</td>
                    <td>{{ user.email }}</td>
                    <td>{{ user.company_name }}</td>
                    <td>{{ formattedDatetime(user.created_at) }}</td>
                    <td><user-status :user="user"></user-status></td>
                    <td>
                      <div class="btn-group">
                        <button type="button" class="btn btn-light btn-sm dropdown-toggle" id="dropdownMenuUser" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> 操作 <span class="caret"></span> </button>
                        <div class="dropdown-menu" aria-labelledby="dropdownMenuUser">
                          <a :href="`${rootUrl}/admin/users/${user.id}/edit`" role="button" class="dropdown-item">ユーザーを編集</a>
                          <a class="dropdown-item" role="button" data-toggle="modal" data-target="#modalToggleStatusUser" @click="curUserIndex = index">
                            <span v-if="user.status === 'active'">ブロックする</span>
                            <span v-else>ブロック解除する</span>
                          </a>
                          <a role="button" class="dropdown-item" data-toggle="modal" data-target="#modalDeleteUser" @click="curUserIndex = index">ユーザーを削除</a>
                        </div>
                      </div>
                      <a :href="`${rootUrl}/admin/users/${user.id}/sso`" class="btn btn-sm btn-info" target="_blank">ログイン</a>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div class="d-flex justify-content-end" v-if="totalRows && totalRows/10 > 1">
              <b-pagination
                v-model="currentPage"
                :total-rows="totalRows"
                :per-page="10"
                aria-controls="my-table"
                first-number
                last-number
                @change="loadPage('getData')"
              ></b-pagination>
            </div>
            <div class="text-center mt-4" v-if="users.length == 0">
              <b>データはありません。</b>
            </div>
          </div>
          <loading-indicator :loading="loading"></loading-indicator>
        </div>
      </div>
    </div>
    <!-- START: Toggle status (active/blocked) -->
    <modal-confirm title="このユーザーの状況を変更してもよろしいですか？" id='modalToggleStatusUser' type='confirm' @confirm="submitToggleStatus">
      <template v-slot:content>
        <div v-if="curUser">
          <b>{{ curUser.status === 'active' ? '有効' : 'ブロック中' }}</b> <i class="mdi mdi-arrow-right-bold"></i> <b>{{ curUser.status === 'active' ? 'ブロック中' : '有効' }}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Toggle status (active/blocked) -->
    <!-- START: Delete user modal -->
    <modal-confirm title="こちらのユーザーを削除してよろしいですが?" id='modalDeleteUser' type='delete' @confirm="submitDeleteUser">
      <template v-slot:content>
        <div v-if="curUser">
          メールアドレス: <b>{{curUser.email}}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Delete user modal -->
  </div>
</template>
<script>
import { mapActions, mapMutations, mapState } from 'vuex';
import Util from '@/core/util';

export default {
  data() {
    return {
      rootUrl: process.env.MIX_ROOT_PATH,
      currentPage: 1,
      contentKey: 0,
      loading: true,
      curUserIndex: 0,
      isSearch: false,
      searchData: {
        name: '',
        status: ''
      }
    };
  },
  async beforeMount() {
    await this.getUsers();
    this.loading = false;
  },
  computed: {
    ...mapState('user', {
      users: (state) => state.users,
      totalRows: (state) => state.totalRows,
      perPage: (state) => state.perPage,
      curPage: (state) => state.curPage,
      searchDataName: (state) => state.searchDataName,
      searchDataStatus: (state) => state.searchDataStatus
    }),

    curUser() {
      return this.users[this.curUserIndex];
    }
  },
  methods: {
    ...mapMutations('user', [
      'setCurPage',
      'setSearchData'
    ]),
    ...mapActions('user', [
      'getUsers',
      'deleteUser',
      'updateUser',
      'searchUsers'
    ]),

    forceRerender() {
      this.contentKey++;
    },

    async loadPage(status) {
      this.$nextTick(async() => {
        if (status === 'searchData') this.isSearch = true;
        this.loading = true;
        if (this.isSearch && status === 'searchData') {
          this.currentPage = 1;
          this.setSearchData(this.searchData);
        }
        this.setCurPage(this.currentPage);

        const data = {
          'q[name_or_company_name_or_email_cont]': this.searchDataName,
          'q[status_eq]': this.searchDataStatus,
          page: this.curPage
        };

        await this.searchUsers(data);
        this.forceRerender();
        this.loading = false;
      });
    },

    formattedDatetime(time) {
      return Util.formattedDatetime(time);
    },

    async submitDeleteUser() {
      const response = await this.deleteUser(this.curUser.id);
      if (response) Util.showSuccessThenRedirect('ユーザー削除は完了しました。', `${this.rootUrl}/admin/users`);
      else window.toastr.error('ユーザーの削除は失敗しました。');
    },

    async submitToggleStatus() {
      const data = {
        id: this.curUser.id,
        status: (this.curUser.status === 'blocked') ? 'active' : 'blocked'
      };
      const response = await this.updateUser(data);
      if (response) {
        window.toastr.success('ユーザー状況の変更は完了しました。');
        setTimeout(() => {
          this.loadPage(this.currentPage);
        }, 500);
      } else {
        window.toastr.error('ユーザー状況の変更は失敗しました。');
      }
    }
  }
};
</script>
<style lang="scss" scoped>

</style>