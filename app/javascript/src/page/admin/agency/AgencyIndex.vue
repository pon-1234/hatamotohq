<template>
  <div>
    <div class="row">
      <div class="col-12">
        <div class="card">
          <div class="card-header d-flex align-items-center">
            <a :href="`${rootUrl}/admin/agencies/new`" class="btn btn-info fw-120 mr-2">
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
                  <div class="btn btn-info" @click="loadAgencies">検索</div>
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
                    <th>登録日時</th>
                    <th>操作</th>
                  </tr>
                </thead>
                <tbody v-for="(agency, index) in agencies" :key="agency.id">
                  <tr>
                    <td class="fw-100">
                      <span>{{ agency.id }}</span>
                    </td>
                    <td class="mxw-400">{{ agency.name }}</td>
                    <td class="mxw-300">{{ agency.email }}</td>
                    <td class="fw-200">{{ agency.created_at | formatted_time }}</td>
                    <td class="fw-200">
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
                          <a
                            :href="`${rootUrl}/admin/agencies/${agency.id}/edit`"
                            target="_blank"
                            role="button"
                            class="dropdown-item"
                            >契約者を編集</a
                          >
                          <a
                            role="button"
                            class="dropdown-item"
                            data-toggle="modal"
                            data-target="#modalDeleteAgency"
                            @click="curAgencyIndex = index"
                            >契約者を削除</a
                          >
                        </div>
                      </div>
                      <a :href="`${rootUrl}/admin/agencies/${agency.id}/sso`" class="btn btn-sm btn-info">ログイン</a>
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
                @change="loadAgencies"
                aria-controls="my-table"
              ></b-pagination>
            </div>
            <div class="my-5 text-center font-weight-bold" v-if="!loading && totalRows === 0">データはありません。</div>
          </div>
          <loading-indicator :loading="loading"></loading-indicator>
        </div>
      </div>
    </div>
    <!-- START: Delete agency modal -->
    <modal-confirm
      title="こちらの契約者を削除してよろしいですが?"
      id="modalDeleteAgency"
      type="delete"
      @confirm="submitDeleteAgency"
    >
      <template v-slot:content>
        <div v-if="curAgency">
          契約者名: <b>{{ curAgency.name | truncate(64) }}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Delete agency modal -->
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
      curAgencyIndex: 0,
      isSearch: false,
      queryParams: null
    };
  },
  created() {
    this.queryParams = _.cloneDeep(this.getQueryParams);
  },
  async beforeMount() {
    await this.getAgencies();
    this.loading = false;
  },

  computed: {
    ...mapGetters('agency', ['getQueryParams']),
    ...mapState('agency', {
      agencies: state => state.agencies,
      totalRows: state => state.totalRows,
      perPage: state => state.perPage
    }),

    curAgency() {
      return this.agencies[this.curAgencyIndex];
    }
  },
  methods: {
    ...mapMutations('agency', ['setCurPage', 'setQueryParams']),
    ...mapActions('agency', ['getAgencies', 'deleteAgency', 'updateUser', 'searchAgencies']),

    forceRerender() {
      this.contentKey++;
    },

    async loadAgencies() {
      this.$nextTick(async() => {
        this.setQueryParams(this.queryParams);
        this.loading = true;
        this.getAgencies();
        this.forceRerender();
        this.loading = false;
      });
    },

    formattedDatetime(time) {
      return Util.formattedDatetime(time);
    },

    async submitDeleteAgency() {
      const response = await this.deleteAgency(this.curAgency.id);
      if (response) Util.showSuccessThenRedirect('契約者の削除は完了しました。', `${this.rootUrl}/admin/agencies`);
      else window.toastr.error('契約者の削除は失敗しました。');
    }
  }
};
</script>