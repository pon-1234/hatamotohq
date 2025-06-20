<template>
  <div>
    <div class="row">
      <div class="col-12">
        <div class="card">
          <div class="card-header d-flex align-items-center">
            <a :href="`${rootUrl}/user/staffs/new`" class="btn btn-success fw-120 mr-2">
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
                  v-model="queryParams.name_or_company_name_or_email_cont"
                />
                <span class="mdi mdi-magnify search-icon"></span>
                <div class="input-group-append">
                  <div class="btn btn-primary" @click="loadStaffs">検索</div>
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
                    <th>氏名</th>
                    <th>メールアドレス</th>
                    <th>電話番号</th>
                    <th>状況</th>
                    <th class="fw-200">操作</th>
                  </tr>
                </thead>
                <tbody v-for="(staff, index) in staffs" :key="staff.id">
                  <tr>
                    <td>{{ staff.name }}</td>
                    <td>{{ staff.email }}</td>
                    <td>{{ staff.phone_number }}</td>
                    <td><staff-status :staff="staff"></staff-status></td>
                    <td>
                      <div class="btn-group">
                        <button
                          type="button"
                          class="btn btn-light btn-sm dropdown-toggle"
                          id="dropdownMenuStaff"
                          data-toggle="dropdown"
                          aria-haspopup="true"
                          aria-expanded="false"
                        >
                          操作 <span class="caret"></span>
                        </button>
                        <div class="dropdown-menu" aria-labelledby="dropdownMenuStaff">
                          <a
                            :href="`${rootUrl}/user/staffs/${staff.id}/edit`"
                            target="_blank"
                            role="button"
                            class="dropdown-item"
                            >スタッフを編集</a
                          >
                          <a
                            class="dropdown-item"
                            role="button"
                            data-toggle="modal"
                            data-target="#modalToggleStatusUser"
                            @click="curStaffIndex = index"
                          >
                            <span v-if="staff.status === 'active'">無効にする</span>
                            <span v-else>有効にする</span>
                          </a>
                          <a
                            role="button"
                            class="dropdown-item"
                            data-toggle="modal"
                            data-target="#modalDeleteStaff"
                            @click="curStaffIndex = index"
                            >スタッフを削除</a
                          >
                        </div>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div class="d-flex justify-content-center mt-4">
              <base-pagination
                v-if="totalRows > perPage"
                v-model="queryParams.page"
                :total-rows="totalRows"
                :per-page="perPage"
                @change="loadStaffs"
                aria-controls="my-table"
              ></base-pagination>
            </div>
            <div class="my-5 font-weight-bold text-center" v-if="!loading && totalRows === 0">
              登録したスタッフはありません。
            </div>
          </div>
          <loading-indicator :loading="loading"></loading-indicator>
        </div>
      </div>
    </div>
    <!-- START: Toggle status (active/blocked) -->
    <modal-confirm
      title="このスタッフの状況を変更してもよろしいですか？"
      id="modalToggleStatusUser"
      type="confirm"
      @confirm="submitToggleStatus"
    >
      <template v-slot:content>
        <div v-if="curStaff">
          <b>{{ curStaff.status === "active" ? "有効" : "無効" }}</b> <i class="mdi mdi-arrow-right-bold"></i>
          <b>{{ curStaff.status === "active" ? "無効" : "有効" }}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Toggle status (active/blocked) -->
    <!-- START: Delete user modal -->
    <modal-confirm
      title="こちらのスタッフを削除してよろしいですが?"
      id="modalDeleteStaff"
      type="delete"
      @confirm="submitDeleteStaff"
    >
      <template v-slot:content>
        <div v-if="curStaff">
          メールアドレス: <b>{{ curStaff.name | truncate(64) }}</b>
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
      rootUrl: import.meta.env.VITE_ROOT_PATH,
      currentPage: 1,
      contentKey: 0,
      loading: true,
      curStaffIndex: 0,
      isSearch: false,
      queryParams: null
    };
  },
  created() {
    this.queryParams = _.cloneDeep(this.getQueryParams);
  },
  async beforeMount() {
    await this.getStaffs();
    this.loading = false;
  },

  computed: {
    ...mapGetters('staff', ['getQueryParams']),
    ...mapState('staff', {
      staffs: state => state.staffs,
      totalRows: state => state.totalRows,
      perPage: state => state.perPage
    }),

    curStaff() {
      return this.staffs[this.curStaffIndex];
    }
  },
  methods: {
    ...mapMutations('staff', ['setCurPage', 'setQueryParams']),
    ...mapActions('staff', ['getStaffs', 'deleteStaff', 'updateStaff', 'searchStaffs']),

    forceRerender() {
      this.contentKey++;
    },

    async loadStaffs() {
      this.$nextTick(async() => {
        this.setQueryParams(this.queryParams);
        this.loading = true;
        this.getStaffs();
        this.forceRerender();
        this.loading = false;
      });
    },

    formattedDatetime(time) {
      return Util.formattedDatetime(time);
    },

    async submitDeleteStaff() {
      const response = await this.deleteStaff(this.curStaff.id);
      if (response) Util.showSuccessThenRedirect('スタッフの削除は完了しました。', `${this.rootUrl}/user/staffs`);
      else window.toastr.error('スタッフの削除は失敗しました。');
    },

    async submitToggleStatus() {
      const data = {
        id: this.curStaff.id,
        status: this.curStaff.status === 'blocked' ? 'active' : 'blocked'
      };
      const response = await this.updateStaff(data);
      if (response) {
        Util.showSuccessThenRedirect('ユーザー状況の変更は完了しました。', `${this.rootUrl}/user/staffs`);
      } else {
        window.toastr.error('ユーザー状況の変更は失敗しました。');
      }
    }
  }
};
</script>