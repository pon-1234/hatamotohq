<template>
  <div
    class="modal fade"
    id="modalSendScenario"
    tabindex="-1"
    role="dialog"
    aria-labelledby="myModalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog modal-xl" role="document">
      <div class="modal-content mh-400">
        <div class="modal-header">
          <h5 class="modal-title">シナリオ配信を選択してください。</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">×</span>
          </button>
        </div>
        <div class="modal-body text-sm">
          <table class="table table-hover">
            <thead class="thead-light">
              <tr>
                <th>#</th>
                <th class="mw-120">配信方式</th>
                <th class="mw-200">シナリオ名</th>
                <th class="mw-120">メッセージ数</th>
                <th class="mw-150"></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(scenario, index) in scenarios" :key="index">
                <td>{{ index + 1 }}</td>
                <td>{{ scenario.mode === "date" ? "時刻" : "経過時間" }}</td>
                <td>
                  <p class="item-name mxw-400">{{ scenario.title }}</p>
                </td>
                <td>{{ scenario.scenario_messages_count || 0 }}</td>
                <td class="text-right">
                  <div role="button" class="btn btn-info btn-sm" @click="sendScenario(scenario)" data-dismiss="modal">
                    送信
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
          <div class="text-center mt-4" v-if="scenarios.length === 0">送信できるシナリオはありません。</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex';

export default {
  data() {
    return {
      scenarios: [],
      isPc: true
    };
  },

  async beforeMount() {
    this.scenarios = await this.getAvailableScenarios(this.activeChannel.id);
  },

  computed: {
    ...mapState('channel', { activeChannel: state => state.activeChannel })
  },

  methods: {
    ...mapActions('channel', ['getAvailableScenarios']),
    sendScenario(scenario) {
      this.$emit('selectScenario', scenario);
    }
  }
};
</script>