<template>
  <div class="row">
    <div class="col-12">
      <div class="card">
        <div class="card-header">
          <div class="btn btn-success mr-2" @click="openNew()"><i class="fa fa-plus"></i> 新規作成</div>
        </div>
        <div class="card-body">
          <table class="table table-centered mb-0">
            <thead class="thead-light">
              <tr>
                <th>配信方式</th>
                <th>シナリオ名</th>
                <th>状況</th>
                <th>メッセージ</th>
                <th>操作</th>
              </tr>
            </thead>
            <tbody>
                <tr v-for="(scenario, index) in scenarios" :key="index">
                  <td>{{ scenario.mode === 'elapsed_time' ? '経過時間' : '時刻' }}</td>
                  <td>{{ scenario.title }}</td>
                  <td><scenario-status :status="scenario.status"></scenario-status></td>
                  <td>
                    <div class="btn btn-light" @click="openMessageIndex(scenario)">メッセージ一覧（{{scenario.scenario_messages_count || 0}}）</div>
                  </td>
                  <td>
                    <div class="btn-group">
                      <button type="button" class="btn btn-light btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false"> 操作 <span class="caret"></span> </button>
                      <div class="dropdown-menu">
                        <a role="button" class="dropdown-item" @click="openEdit(scenario)">シナリオを編集する</a>
                        <a role="button" class="dropdown-item" data-toggle="modal" data-target="#modalCopyScenario" @click="curScenarioIndex = index">シナリオをコピー</a>
                        <a role="button" class="dropdown-item" data-toggle="modal" data-target="#modalDeleteScenario" @click="curScenarioIndex = index">シナリオを削除</a>
                      </div>
                    </div>
                  </td>
                </tr>
            </tbody>
          </table>
          <div class="d-flex justify-content-center mt-4 text-center">
            <b-pagination
              v-if="totalRows > perPage"
              v-model="currentPage"
              :total-rows="totalRows"
              :per-page="perPage"
              @change="loadPage"
              aria-controls="my-table"
            ></b-pagination>
            <b v-if="!loading && totalRows === 0">シナリオはありません。</b>
          </div>
        </div>

        <loading-indicator :loading="loading"></loading-indicator>
      </div>
    </div>

    <!-- START: Delete scenario modal -->
    <modal-confirm title="このシナリオを削除してもよろしいですか？" id='modalDeleteScenario' type='delete' @confirm="submitDeleteScenario">
      <template v-slot:content>
        <div v-if="curScenario">
          シナリオ名：<b>{{curScenario.title}}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Delete scenario modal -->

    <!-- START: Copy scenario modal -->
    <modal-confirm title="このシナリオをコピーしてもよろしいですか？" id='modalCopyScenario' type='confirm' @confirm="submitCopyScenario">
      <template v-slot:content>
        <div v-if="curScenario">
          シナリオ名：<b>{{curScenario.title}}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Copy scenario modal -->
  </div>
</template>

<script>
import { mapActions, mapMutations, mapState } from 'vuex';
import Util from '@/core/util';

export default {
  data() {
    return {
      loading: true,
      contentKey: 0,
      currentPage: 1,
      curScenarioIndex: 0
    };
  },
  async beforeMount() {
    await this.getScenarios();
    this.loading = false;
  },
  computed: {
    ...mapState('scenario', {
      scenarios: (state) => state.scenarios,
      totalRows: (state) => state.totalRows,
      perPage: (state) => state.perPage
    }),

    curScenario() {
      return this.scenarios[this.curScenarioIndex];
    }
  },
  methods: {
    ...mapMutations('scenario', [
      'setCurPage'
    ]),
    ...mapActions('scenario', [
      'getScenarios',
      'copyScenario',
      'deleteScenario'
    ]),

    forceRerender() {
      this.contentKey++;
    },

    async loadPage() {
      // bootstrap pagination return old value of current page,
      // using nextTick to solve the issue
      this.$nextTick(async() => {
        this.loading = true;
        this.setCurPage(this.currentPage);
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
      window.location.href = `${process.env.MIX_ROOT_PATH}/user/scenarios/${scenario.id}/messages`;
    },

    async submitDeleteScenario() {
      const response = await this.deleteScenario(this.curScenario.id);
      if (response) {
        window.toastr.success('シナリオの削除は完了しました。');
      } else {
        window.toastr.error('シナリオの削除は失敗しました。');
      }
      this.forceRerender();
    },

    async submitCopyScenario() {
      const response = await this.copyScenario(this.curScenario.id);
      if (response) {
        Util.showSuccessThenRedirect('シナリオのコピーは完了しました。', window.location.href);
      } else {
        window.toastr.error('シナリオのコピーは失敗しました。');
      }
    }
  }
};
</script>