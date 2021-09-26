<template>
  <div class="row">
    <div class="col-12">
      <div class="card">
        <div class="card-header">
          <button type="button" class="btn btn-success mr-2"><i class="fa fa-plus"></i> 新規作成</button>
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
                  <td><scenario-item-status :status="scenario.status"></scenario-item-status></td>
                  <td>
                    <div class="btn btn-light">メッセージ一覧（{{scenario.scenario_messages_count || 0}}）</div>
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
                    <!-- <%= link_to edit_user_scenario_path(scenario), class:"action-icon" do %>
                      <i class="mdi mdi-square-edit-outline"></i>
                    <% end %>
                    <%= link_to copy_confirm_user_scenario_path(scenario), class:"action-icon", remote: true do %>
                      <i class="mdi mdi-content-copy"></i>
                    <% end %>
                    <%= link_to delete_confirm_user_scenario_path(scenario), class:"action-icon", remote: true do %>
                      <i class="mdi mdi-delete"></i>
                    <% end %> -->
                  </td>
                </tr>
            </tbody>
          </table>
          <div class="d-flex justify-content-center mt-4">
            <b-pagination
              v-model="currentPage"
              :total-rows="totalRows"
              :per-page="perPage"
              @change="loadPage"
              aria-controls="my-table"
            ></b-pagination>
          </div>
        </div>
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

    openEdit(scenario) {
      window.open(`${process.env.MIX_ROOT_PATH}/user/scenarios/${scenario.id}/edit`);
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
        Util.showSuccessThenRedirect('シナリオのコピーは失敗しました。', window.location.href);
      }
      this.forceRerender();
    }
  }
};
</script>