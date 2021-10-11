<template>
  <div class="modal fade" :id="id" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">シナリオ配信を選択してください。</h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">×</span>
          </button>
        </div>
        <div class="modal-body text-sm">
          <table class="table table-hover">
            <thead class="thead-light">
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
                <td>{{ scenario.mode === "time" ? "時刻" : "経過時間" }}</td>
                <td>{{ scenario.title }}</td>
                <td>{{ scenario.scenario_messages_count || 0 }}</td>
                <td>
                  <div role="button" class="btn btn-info btn-sm" @click="selectScenario(scenario)" data-dismiss="modal">
                    選択
                  </div>
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
import { mapActions } from 'vuex';

export default {
  props: ['type', 'id'],

  data() {
    return {
      scenarios: [],
      isPc: true
    };
  },

  async beforeMount() {
    const response = await this.getManualScenarios();
    this.scenarios = response;
  },

  methods: {
    ...mapActions('scenario', ['getManualScenarios']),
    selectScenario(scenario) {
      this.$emit('selectScenario', scenario);
    }
  }
};
</script>