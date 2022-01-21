<template>
  <div>
    <div class="row">
      <div class="col-12">
        <div class="card">
          <div class="card-header d-flex align-items-center">
            <a :href="`${rootUrl}/user/scenarios/${scenario.id}/messages/new`" class="btn btn-success mr-2"
              ><i class="uil-plus"></i> メッセージを追加</a
            >
            <scenario-select-template :scenario_id="scenario.id"></scenario-select-template>
            <a class="btn btn-info text-white ml-2" role="button" data-toggle="modal" data-target="#modalSendScenarioToTesters"
              >テスト配信</a>
          </div>
          <div class="card-body">
            <div class="table-responsive">
              <table class="table table-centered mb-0">
                <thead class="thead-light">
                  <tr>
                    <th>通目</th>
                    <th>時刻</th>
                    <th>メッセージ名</th>
                    <th>タイプ</th>
                    <th>メッセージプレビュー</th>
                    <th class="fw-120">状況</th>
                    <th class="fw-200">操作</th>
                  </tr>
                </thead>
                <tbody v-for="(message, index) in messages" :key="index">
                  <tr>
                    <td>
                      <span v-if="message.status == 'enabled'">{{ message.step }}通目</span>
                      <span v-else>未設定</span>
                    </td>
                    <td>
                      {{ scheduleTimeFor(message) }}
                    </td>
                    <td>
                      <span>{{ message.name ? message.name : "未設定" }}</span>
                    </td>
                    <td><message-type-label :data="message.content" /></td>
                    <td><message-content :data="message"></message-content></td>
                    <td>
                      <scenario-message-status :status="message.status"></scenario-message-status>
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
                          <a
                            :href="`${rootUrl}/user/scenarios/${scenario.id}/messages/${message.id}/edit`"
                            class="dropdown-item"
                            >メッセージを編集</a
                          >
                          <a
                            role="button"
                            class="dropdown-item"
                            data-toggle="modal"
                            data-target="#modalDeleteScenarioMessage"
                            @click="curMessageIndex = index"
                            >メッセージを削除</a
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
                  v-model="currentPage"
                  :total-rows="totalRows"
                  :per-page="perPage"
                  @change="loadPage"
                  aria-controls="my-table"
                ></b-pagination>
              </div>
              <div class="text-center my-5 font-weight-bold" v-if="!loading && totalRows === 0">
                シナリオメッセージはありません。
              </div>
            </div>
            <loading-indicator :loading="loading"></loading-indicator>
          </div>
        </div>
      </div>
    </div>
    <!-- START: Delete user modal -->
    <modal-confirm
      title="本当に削除してよろしですか?"
      id="modalDeleteScenarioMessage"
      type="delete"
      @confirm="submitDeleteMessage"
    >
      <template v-slot:content>
        <div v-if="curMessage">
          メッセージ名：: <b>{{ curMessage.name }}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Delete user modal -->

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
      </template>
    </modal-confirm>
    <!-- END: send scenario to testers modal -->
  </div>
</template>
<script>
import { mapActions, mapMutations, mapState } from 'vuex';
import Util from '@/core/util';
import moment from 'moment';

export default {
  props: ['scenario', 'testers'],
  data() {
    return {
      rootUrl: process.env.MIX_ROOT_PATH,
      loading: true,
      curMessageIndex: 0,
      currentPage: 1,
      selectedTesterIds: []
    };
  },
  created() {},
  async beforeMount() {
    await this.getMessages(this.scenario.id);
    this.loading = false;
  },
  computed: {
    ...mapState('scenarioMessage', {
      messages: state => state.messages,
      totalRows: state => state.totalRows,
      perPage: state => state.perPage
    }),

    curMessage() {
      return this.messages[this.curMessageIndex];
    }
  },
  methods: {
    ...mapMutations('scenarioMessage', ['setCurPage']),
    ...mapActions('scenarioMessage', ['getMessages', 'deleteMessage', 'sendScenarioToTesters']),

    scheduleTimeFor(message) {
      if (message.status === 'disabled') return '';
      if (this.scenario.mode === 'elapsed_time') {
        if (message.is_initial) {
          return '開始直後';
        } else {
          const sb = message.date > 0 ? `${message.date}日と` : '';
          const time = moment(message.time, 'HH:mm').format('HH時間mm分');
          return `${sb}${time}後`;
        }
      } else if (this.scenario.mode === 'time') {
        if (message.is_initial) {
          return '開始直後';
        } else {
          return message.date === 0 ? `開始当日 ${message.time}` : `${message.date}日後 ${message.time}`;
        }
      }
    },

    forceRerender() {
      this.contentKey++;
    },

    async loadPage() {
      // bootstrap pagination return old value of current page,
      // using nextTick to solve the issue
      this.$nextTick(async() => {
        this.loading = true;
        this.setCurPage(this.currentPage);
        await this.getMessages(this.scenario.id);
        this.forceRerender();
        this.loading = false;
      });
    },

    async submitDeleteMessage() {
      const params = {
        scenario_id: this.scenario.id,
        id: this.curMessage.id
      };
      const response = await this.deleteMessage(params);
      if (response) {
        Util.showSuccessThenRedirect(
          'シナリオメッセージの削除は成功しました。',
          `${this.rootUrl}/user/scenarios/${this.scenario.id}/messages`
        );
      } else window.toastr.error('シナリオメッセージの削除は失敗しました。');
      this.forceRerender();
    },

    async submitSendScenarioToTesters() {
      const response = await this.sendScenarioToTesters({ scenario_id: this.scenario.id, line_friend_ids: this.selectedTesterIds });
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
</style>
