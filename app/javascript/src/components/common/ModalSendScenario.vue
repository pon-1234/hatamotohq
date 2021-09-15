<template>
  <div class="modal fade" :id="id" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">シナリオ配信を選択してください。</h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">×</span>
          </button>
        </div>
        <div class="modal-body text-sm">
          <table class="table table-hover">
            <thead>
              <tr>
                <th>#</th>
                <th>配信方式</th>
                <th>シナリオ名</th>
                <th>メッセージ数</th>
                <th>選択</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(scenario, index) in scenarios" :key="index">
                <td>{{ index + 1 }}</td>
                <td>{{ scenario.mode === 'date' ? '時刻' : '経過時間' }}</td>
                <td>{{ scenario.title }}</td>
                <td>{{ scenario.scenario_messages_count || 0 }}</td>
                <td>
                  <div role="button" class="btn btn-primary btn-sm" @click="sendScenario(scenario)" data-dismiss="modal">送信</div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex';

export default {
  props: ['id'],

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
      this.$emit('onSelectScenario', scenario);
    }
  }
};
</script>