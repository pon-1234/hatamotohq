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
                <td>{{ scenario.mode === 'time' ? '時刻' : '経過時間' }}</td>
                <td>{{ scenario.title }}</td>
                <td>{{ scenario.scenario_messages_count || 0 }}</td>
                <td>
                  <div role="button" class="btn btn-primary btn-sm" @click="selectScenario(scenario)" data-dismiss="modal">選択</div>
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

<style lang="scss" scoped>

::v-deep{
  .table-tags-header {
    margin-bottom: 0px!important;
    max-width: none!important;
    margin-top: 0px!important;
    tr {
      height: 40px;
    }
  }
}
.modal-template {
  .item-sm {
    display: none;
  }

  @media (max-width: 991px) {
    .item-pc {
      display: none!important;
    }

    .item-sm {
      display: inline-block!important;
    }

    .fa-arrow-left {
      margin-right: 10px;
      cursor: pointer;
    }
  }

  .modal-dialog {
    max-width: 800px;

    .template-list-content {
      background-color: #f0f0f0;

      .folder-item {
        height: 45px;
        min-height: 45px;
        cursor: pointer;
        padding: 10px;
        display: flex;
        align-items: center;
        white-space: nowrap;
        overflow: hidden;
      }

      .folder-item:hover {
        background: #f0ad4e;
      }

      .list-content {
        height: 100%;
        max-height: 500px;
        overflow: hidden;
        display: flex;
        flex-direction: column;
        .list-scroll {
          height: 100%;
          overflow-x: hidden;
          overflow-y: auto;
          margin: 0 0;
          display: flex;
          flex-direction: column;
        }
      }
    }
  }
}
</style>
