<template>
  <div :key="componentKey">
    <div class="card">
      <div class="card-header left-border"><h3 class="card-title">基本設定</h3></div>
      <div class="card-body">
        <div class="form-group d-flex">
          <label class="fw-200">シナリオ名<required-mark /></label>
          <div class="flex-grow-1">
            <input
              type="text"
              name="name"
              class="form-control"
              placeholder="シナリオ名を入力してください"
              v-model="scenarioData.title"
              v-validate="'required|max:255'"
              data-vv-as="シナリオ名"
            />
            <error-message :message="errors.first('name')"></error-message>
          </div>
        </div>
        <div class="form-group d-flex">
          <label class="fw-200">シナリオ説明</label>
          <div class="flex-grow-1">
            <textarea
              class="form-control"
              name="description"
              rows="3"
              placeholder="シナリオ説明を入力してください"
              v-model="scenarioData.description"
              v-validate="'max:2000'"
              data-vv-as="シナリオ説明"
            ></textarea>
            <error-message :message="errors.first('description')"></error-message>
          </div>
        </div>
      </div>
    </div>
    <div class="card">
      <div class="card-header left-border"><h3 class="card-title">配信設定</h3></div>
      <div class="card-body">
        <div class="form-group d-flex">
          <label class="fw-200">配信 ON/OFF</label>
          <div class="flex-grow-1 d-flex">
            <input
              type="checkbox"
              id="scenario-onoff"
              checked
              data-switch="success"
              v-model="scenarioData.status"
              true-value="enabled"
              false-value="disabled"
              ref="status"
            />
            <label for="scenario-onoff" data-on-label="オン" data-off-label="オフ"></label>
          </div>
        </div>
        <div class="mt-2">
          <div class="w-100 form-group d-flex">
            <label class="fw-200">配信先</label>
            <div class="flex-grow-1">
              <div class="custom-control custom-radio custom-control-inline">
                <input
                  type="radio"
                  id="targetAll"
                  name="target"
                  value="all"
                  v-model="target"
                  class="custom-control-input"
                />
                <label class="custom-control-label" for="targetAll">全員</label>
              </div>
              <div class="custom-control custom-radio custom-control-inline">
                <input
                  type="radio"
                  id="targetTags"
                  name="target"
                  value="tags"
                  v-model="target"
                  class="custom-control-input"
                />
                <label class="custom-control-label" for="targetTags">タグで絞り込む</label>
              </div>
              <div class="w-100 mt-2" v-if="target === 'tags'">
                <div>
                  <input-tag :tags="scenarioData.tags" @input="addListTag" />
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="mt-2">
          <div class="form-group d-flex">
            <label class="fw-200">配信開始</label>
            <div class="flex-grow-1">
              <div class="custom-control custom-radio custom-control-inline">
                <input
                  type="radio"
                  id="typeManual"
                  value="manual"
                  v-model="scenarioData.type"
                  class="custom-control-input"
                />
                <label class="custom-control-label" for="typeManual">選択なし</label>
              </div>
              <div class="custom-control custom-radio custom-control-inline">
                <input
                  type="radio"
                  id="typeAuto"
                  value="auto"
                  v-model="scenarioData.type"
                  class="custom-control-input"
                />
                <label class="custom-control-label" for="typeAuto">友達追加時</label>
              </div>
            </div>
          </div>
        </div>

        <div class="mt-2">
          <div class="d-flex flex-start">
            <div class="fw-200">
              <label class="w-100">配信タイミング</label>
              <span class="text-sm text-muted font-12">作成した後、変更不可</span>
            </div>

            <div class="flex-grow-1">
              <div class="custom-control custom-radio custom-control-inline">
                <input
                  type="radio"
                  id="modeElapsedTime"
                  value="elapsed_time"
                  v-model="scenarioData.mode"
                  :disabled="scenario_id"
                  class="custom-control-input"
                />
                <label class="custom-control-label" for="modeElapsedTime">経過時間で指定</label>
              </div>
              <div class="custom-control custom-radio custom-control-inline">
                <input
                  type="radio"
                  id="modeAuto"
                  value="time"
                  v-model="scenarioData.mode"
                  :disabled="scenario_id"
                  class="custom-control-input"
                />
                <label class="custom-control-label" for="modeAuto">時刻で指定</label>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="card">
      <div class="card-header left-border"><h3 class="card-title">配信終了アクション設定</h3></div>
      <div class="card-body">
        <action-editor-custom
          name="after_action"
          :value="scenarioData.after_action"
          :labelRequired="false"
          :showTitle="false"
          :showLaunchMesasge="false"
          @input="updateAction"
        ></action-editor-custom>
      </div>
    </div>

    <div class="d-flex">
      <button type="submit" class="btn btn-success fw-120 mr-2" @click="saveScenario()">保存</button>
      <button type="submit" class="btn btn-outline-success fw-120" @click="saveScenario('draft')">下書き保存</button>
    </div>
    <loading-indicator :loading="loading" />
  </div>
</template>
<script>
import { mapActions } from 'vuex';
import ViewHelper from '@/core/view_helper';

export default {
  props: ['scenario_id'],

  provide() {
    return { parentValidator: this.$validator };
  },

  data() {
    return {
      userRootUrl: process.env.MIX_ROOT_PATH,
      loading: true,
      componentKey: 0,
      target: 'all', // or 'tags'
      scenarioData: {
        title: '',
        description: '',
        tags: null,
        status: 'disabled',
        mode: 'elapsed_time', // or 'time'
        type: 'manual', // or 'auto'
        after_action: this.ActionMessage.default
      }
    };
  },

  async beforeMount() {
    if (this.scenario_id) {
      await this.getScenarioDetail();
    }
    this.forceRerender();
    this.loading = false;
  },

  methods: {
    ...mapActions('scenario', ['getScenario', 'createScenario', 'updateScenario']),

    forceRerender() {
      this.componentKey += 1;
    },

    async getScenarioDetail() {
      const response = await this.getScenario(this.scenario_id);
      this.scenarioData = response;
      this.target = this.scenarioData.tags.length > 0 ? 'tags' : 'all';
    },

    changeDeliverTarget(target) {
      if (target === 'all') {
        this.scenarioData.tags = null;
      }
      this.target = target;
    },

    async saveScenario(status) {
      if (status !== 'draft') {
        this.scenarioData.status = this.$refs.status.checked ? 'enabled' : 'disabled';
        const result = await this.$validator.validateAll();
        if (!result) {
          return ViewHelper.scrollToRequiredField(true);
        }
      } else {
        this.scenarioData.status = status;
      }

      this.scenarioData.type = this.scenarioData.type || 'manual';
      if (!this.scenario_id) {
        const scenario = await this.createScenario(this.normalized());
        this.onReceiveCreateScenarioResponse(!!scenario);
      } else {
        const scenario = await this.updateScenario(this.normalized());
        this.onReceiveUpdateScenarioResponse(!!scenario);
      }
    },

    normalized() {
      const payload = _.omit(this.scenarioData, ['tags']);
      payload.tag_ids = this.target === 'tags' ? this.scenarioData.tags.map(_ => _.id) : [];
      return payload;
    },

    addListTag(data) {
      this.$set(this.scenarioData, 'tags', data);
    },

    updateAction(data) {
      console.log(data);
      this.scenarioData.after_action = data;
    },

    // Show alert and redirect after create/update
    onReceiveCreateScenarioResponse(success) {
      if (success) {
        window.toastr.success('シナリオの作成は完了しました。');
        setTimeout(() => {
          window.location.href = `${process.env.MIX_ROOT_PATH}/user/scenarios`;
        }, 500);
      } else {
        window.toastr.error('シナリオの作成は失敗しました。');
        setTimeout(() => {
          window.location.href = `${process.env.MIX_ROOT_PATH}/user/scenarios/new`;
        }, 500);
      }
    },
    onReceiveUpdateScenarioResponse(success) {
      if (success) {
        window.toastr.success('シナリオの更新は完了しました。');
        setTimeout(() => {
          window.location.href = `${process.env.MIX_ROOT_PATH}/user/scenarios`;
        }, 500);
      } else {
        window.toastr.error('シナリオの更新は失敗しました。');
        setTimeout(() => {
          window.location.href = `${process.env.MIX_ROOT_PATH}/user/scenarios`;
        }, 500);
      }
    }
  }
};
</script>
<style lang="scss" scoped>
  .form-group .box-form-timing {
    background: #f2f2f2;
    padding: 15px;
  }
</style>
