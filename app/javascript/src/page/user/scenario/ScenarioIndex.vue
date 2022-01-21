<template>
  <div class="row">
    <div class="col-12">
      <div class="card">
        <div class="card-header d-flex align-items-center">
          <div class="btn btn-success mr-2" @click="openNew()"><i class="uil-plus"></i> 新規作成</div>
          <div class="ml-auto d-flex">
            <select class="form-control fw-150 mr-1" v-model="queryParams.status_eq" @change="search()">
              <option value="">すべて</option>
              <option value="enabled">稼働中</option>
              <option value="disabled">停止中</option>
              <option value="draft">下書き</option>
            </select>
          </div>
        </div>
        <div class="card-body mvh-50">
          <div class="table-responsive">
            <table class="table table-centered mb-0">
              <thead class="thead-light">
                <tr>
                  <th class="mw-120">配信方式</th>
                  <th>シナリオ名</th>
                  <th class="mw-120">状況</th>
                  <th class="mw-200">メッセージ</th>
                  <th>操作</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(scenario, index) in scenarios" :key="index">
                  <td>{{ scenario.mode === "elapsed_time" ? "経過時間" : "時刻" }}</td>
                  <td>
                    <p class="scenario_title">{{ scenario.title }}</p>
                  </td>
                  <td><scenario-status :status="scenario.status"></scenario-status></td>
                  <td>
                    <div class="btn btn-light" @click="openMessageIndex(scenario)">
                      メッセージ一覧（{{ scenario.scenario_messages_count || 0 }}）
                    </div>
                  </td>
                  <td>
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
                        <a role="button" class="dropdown-item" :href="`${rootPath}/user/scenarios/${scenario.id}/edit`"
                          >シナリオを編集する</a
                        >
                        <a
                          role="button"
                          class="dropdown-item"
                          data-toggle="modal"
                          data-target="#modalCopyScenario"
                          @click="curScenarioIndex = index"
                          >シナリオをコピー</a
                        >
                        <a
                          role="button"
                          class="dropdown-item"
                          data-toggle="modal"
                          data-target="#modalSendScenarioToTesters"
                          @click="curScenarioIndex = index"
                          >テスト配信</a>
                        <a
                          role="button"
                          class="dropdown-item"
                          data-toggle="modal"
                          data-target="#modalDeleteScenario"
                          @click="curScenarioIndex = index"
                          >シナリオを削除</a
                        >
                      </div>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <div class="d-flex justify-content-center mt-4 text-center">
            <b-pagination
              v-if="totalRows > perPage"
              v-model="queryParams.page"
              :total-rows="totalRows"
              :per-page="perPage"
              @change="loadPage"
              aria-controls="my-table"
            ></b-pagination>
          </div>
          <div class="text-center my-5 font-weight-bold" v-if="!loading && totalRows === 0">シナリオはありません。</div>
        </div>

        <loading-indicator :loading="loading"></loading-indicator>
      </div>
    </div>

    <!-- START: Delete scenario modal -->
    <modal-confirm
      title="このシナリオを削除してもよろしいですか？"
      id="modalDeleteScenario"
      type="delete"
      @confirm="submitDeleteScenario"
    >
      <template v-slot:content>
        <p v-if="curScenario">
          シナリオ名：<b>{{ curScenario.title }}</b
          ><br />
        </p>
        <div class="alert alert-warning">こちらのシナリオの配信予約したメッセージは停止されます。</div>
      </template>
    </modal-confirm>
    <!-- END: Delete scenario modal -->

    <!-- START: Copy scenario modal -->
    <modal-confirm
      title="このシナリオをコピーしてもよろしいですか？"
      id="modalCopyScenario"
      type="confirm"
      @confirm="submitCopyScenario"
    >
      <template v-slot:content>
        <div v-if="curScenario">
          シナリオ名：<b>{{ curScenario.title }}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Copy scenario modal -->
    <!-- START: send scenario to testers modal -->
    <modal-confirm
      title="テストアカウントを選んでください。"
      id="modalSendScenarioToTesters"
      type="confirm"
      @confirm="submitSendScenarioToTesters"
      :confirmButtonDisabled="selectedTesterIds.length === 0"
      confirmButtonLabel="テスト配信"
    >
      <template v-slot:content>
        <div v-if="curScenario">
          <div v-if="testers && testers.length" class="d-flex">
            <div class="flex-1 custom-control custom-checkbox mr-2" v-for="tester in testers" :key="`tester_${tester.id}`">
              <input
                type="checkbox"
                class="custom-control-input"
                :id="`tester_${tester.id}`"
                v-model="selectedTesterIds"
                :value="tester.id"
              />
              <label class="custom-control-label" :for="`tester_${tester.id}`">{{tester.display_name}}</label>
            </div>
          </div>
        </div>
      </template>
    </modal-confirm>
    <!-- END: send scenario to testers modal -->
  </div>
</template>

<script>
import { mapActions, mapMutations, mapState, mapGetters } from 'vuex';
import Util from '@/core/util';

export default {
  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH,
      loading: true,
      contentKey: 0,
      currentPage: 1,
      queryParams: null,
      curScenarioIndex: 0,
      selectedTesterIds: []
    };
  },

  props: ['testers'],

  created() {
    this.queryParams = _.cloneDeep(this.getQueryParams);
  },

  async beforeMount() {
    await this.getScenarios();
    this.loading = false;
  },

  computed: {
    ...mapGetters('scenario', ['getQueryParams']),
    ...mapState('scenario', {
      scenarios: state => state.scenarios,
      totalRows: state => state.totalRows,
      perPage: state => state.perPage
    }),

    curScenario() {
      return this.scenarios[this.curScenarioIndex];
    }
  },

  methods: {
    ...mapMutations('scenario', ['setQueryParams']),
    ...mapActions('scenario', ['getScenarios', 'copyScenario', 'deleteScenario', 'sendScenarioToTesters']),

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
        this.loading = true;
        this.setQueryParams(this.queryParams);
        await this.getScenarios();
        this.forceRerender();
        this.loading = false;
      });
    },

    openNew() {
      window.location.href = `${process.env.MIX_ROOT_PATH}/user/scenarios/new`;
    },

    openEdit(scenario) {
      window.open(`${process.env.MIX_ROOT_PATH}/user/scenarios/${scenario.id}/edit`);
    },

    openMessageIndex(scenario) {
      window.open(`${process.env.MIX_ROOT_PATH}/user/scenarios/${scenario.id}/messages`);
    },

    async submitDeleteScenario() {
      const response = await this.deleteScenario(this.curScenario.id);
      if (response) {
        Util.showSuccessThenRedirect('シナリオの削除は完了しました。', location.href);
      } else {
        window.toastr.error('シナリオの削除は失敗しました。');
      }
      this.forceRerender();
    },

    async submitCopyScenario() {
      const response = await this.copyScenario(this.curScenario.id);
      if (response) {
        Util.showSuccessThenRedirect('シナリオのコピーは完了しました。', location.href);
      } else {
        window.toastr.error('シナリオのコピーは失敗しました。');
      }
    },

    async submitSendScenarioToTesters() {
      const response = await this.sendScenarioToTesters({ scenario_id: this.curScenario.id, line_friend_ids: this.selectedTesterIds });
      if (response) {
        window.toastr.success('シナリオのテスト配信は完了しました。');
      } else {
        window.toastr.error('シナリオのテスト配信は失敗しました。');
      }
    }
  }
};
</script>
<style lang="scss" scoped>
  .scenario_title {
    width: 40vw;
    margin: 0;
    white-space: pre-wrap;
    -webkit-box-orient: vertical;
    display: -webkit-box;
  }
</style>
