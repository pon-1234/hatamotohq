<template>
  <div class="col-12">
    <div class="row">
      <div class="col-sm-12">
        <table class="table table-striped mt-3">
          <thead>
            <tr>
              <th>シナリオ</th>
              <th colspan="2">時刻</th>
              <th colspan="2">本文</th>
              <th>クリック数</th>
              <th>訪問人数</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(scenarioMessage, index) in scenarios" :key="index">
              <td>
                <p class="mb-0">{{scenarioMessage.scenario_title}}</p>
              </td>
              <td colspan="2">{{scheduleTimeFor(scenarioMessage)}}</td>
              <td class="has_emoji w-250"><p class="scenario-message-content w-250 mt-0 mb-0">{{scenarioMessage.content.text}}</p></td>
              <td>
                <a
                  @click="currentScenarioIndex = index"
                  type="button"
                  data-toggle="modal"
                  data-target="#modalScenarioMessagePreview"
                  class="btn btn-xs btn-default btn-light"
                  >プレビュー</a
                >
              </td>
              <td><b>{{scenarioMessage.click_count}}</b>回 / <b>{{scenarioMessage.sending_count}}</b>送信</td>
              <td><b>{{scenarioMessage.visitor_count}}</b>人 / <b>{{scenarioMessage.receiver_count}}</b>人送信</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    <modal-scenario-message-preview :scenariosMessage="scenarios[currentScenarioIndex] || {}" />
  </div>
</template>
<script>
import { mapActions, mapState } from 'vuex';
import moment from 'moment';

export default {
  props: ['siteId'],
  data() {
    return {
      loading: true,
      currentScenarioIndex: null
    };
  },
  async beforeMount() {
    await this.getScenarios({ id: this.siteId });
    this.loading = false;
  },
  computed: {
    ...mapState('site', {
      scenarios: (state) => state.scenarios
    })
  },
  methods: {
    ...mapActions('site', ['getScenarios']),
    scheduleTimeFor(message) {
      if (message.status === 'disabled') return '';
      if (message.mode === 'elapsed_time') {
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
    }
  }
};
</script>
<style lang="scss" scoped>
  .scenario-message-content {
    display:-webkit-box;
    -webkit-line-clamp:1;
    -webkit-box-orient: vertical;
    overflow: hidden;
    text-overflow: ellipsis;
    word-break: break-all;
  }
  .table {
    tr {
      td {
        vertical-align: middle;
      }
    }
  }
</style>
