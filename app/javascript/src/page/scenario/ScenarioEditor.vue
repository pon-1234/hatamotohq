<template>
  <div class="mw-1200">
    <div class="card">
      <div class="card-header d-flex align-items-center">
        <a :href="`${userRootUrl}/user/scenarios`" class="text-info">
          <i class="fa fa-arrow-left"></i> シナリオ一覧
        </a>
        <h5 class="m-auto font-weight-bold">新規登録</h5>
      </div>
      <div class="card-body">
        <div class="card">
          <div class="card-header left-border"><h3 class="card-title">基本設定</h3></div>
          <div class="card-body">
            <div class="form-border" style="border-top: 0">
              <div class="form-group">
                <label>シナリオ名<required-mark/></label>
                <input type="text" name="name" class="form-control" placeholder="シナリオ名を入力してください" v-model="scenarioData.title" v-validate="'required|max:255'" data-vv-as="シナリオ名">
                <error-message :message="errors.first('name')"></error-message>
              </div>
            </div>
            <div class="form-border">
              <div class="form-group">
                <label class="mb10">シナリオ説明</label>
                <textarea class="form-control" name="description" rows="3" placeholder="シナリオ説明を入力してください" v-model="scenarioData.description" v-validate="'max:2000'" data-vv-as="シナリオ説明"></textarea>
                <error-message :message="errors.first('description')"></error-message>
              </div>
            </div>
          </div>
        </div>
        <div class="card">
          <div class="card-header left-border"><h3 class="card-title">配信設定</h3></div>
          <div class="card-body">
            <div class="form-border">
              <div class="form-group">
                <label class="mb10">配信</label>
                <div class="flex start ai_center">
                  <div class="toggle-switch btn-scenario01">
                    <input id="scenario-onoff" class="toggle-input" type="checkbox" v-model="scenarioData.status" true-value="enable" false-value="disable" ref="status">
                    <label for="scenario-onoff" class="toggle-label">
                      <span></span>
                    </label>
                  </div>
                  <p class="scenario-status no-mgn">配信する</p>
                </div>
              </div>
            </div>
            <div class="divider"></div>
            <div class="mt-2">
              <div class="form-group">
                <label>配信先</label>
                <div class="radio-group mb10">
                  <label><input type="radio" name="send" value="all"  :checked="target === 'all'"  @click="changeDeliverTarget('all')">全員</label>
                  <label><input type="radio" name="send" value="sort" :checked="target === 'tags'" @click="changeDeliverTarget('tags')">条件で絞り込む</label>
                </div>
                <div v-if="target === 'tags'">
                  <label>タグ</label>
                  <div>
                    <input-tag :data="scenarioData.tags" @input="addListTag"/>
                  </div>
                </div>
              </div>
            </div>
            <div class="divider"></div>
            <div class="mt-2">
              <div class="form-group">
                <label>配信開始</label>
                <div class="radio-group">
                  <label>
                    <input type="radio" value="send" v-model="scenarioData.type" @change="changeScenarioType('send')">選択なし
                  </label>
                  <label>
                    <input type="radio"  value="auto" v-model="scenarioData.type" @change="changeScenarioType('auto')">友達追加時
                  </label>
                </div>
              </div>

              <div class="form-group">
                <label>配信タイミング</label>
                <div class="radio-group">
                  <!-- <label v-if="scenarioData.type !== 'no_selection'">
                    <input type="radio" value="now" v-model="scenarioData.mode">購読開始直後
                  </label> -->
                  <label>
                    <input type="radio" value="date" v-model="scenarioData.mode">経過時間で指定
                  </label>
                  <label>
                    <input type="radio" value="elapsed_time" v-model="scenarioData.mode">時刻で指定
                  </label>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="card">
          <div class="card-header left-border"><h3 class="card-title">配信終了アクション設定</h3></div>
          <div class="card-body">
            <message-action-type-default
              name="after_action"
              :value="scenarioData.after_action"
              :labelRequired="false"
              :showTitle="false"
              :showLaunchMesasge="false"
              @input="updateAction"
            />

          </div>
        </div>

        <div class="card-footer d-flex">
          <button type="submit" class="btn btn-success fw-120 mr-2" @click="saveScenario()" >保存</button>
          <button type="submit" class="btn btn-outline-success fw-120" @click="saveScenario('draft')">下書き保存</button>
        </div>
      </div>
      <loading-indicator :loading="loading"/>
    </div>
  </div>
</template>
<script>
import Util from '@/core/util';
import { mapActions } from 'vuex';

export default {
  props: ['scenario_id'],

  provide() {
    return { parentValidator: this.$validator };
  },

  data() {
    return {
      userRootUrl: process.env.MIX_ROOT_PATH,
      loading: true,
      target: 'all', // or 'tags'
      scenarioData: {
        title: '',
        description: '',
        tags: null,
        status: 'disable',
        mode: 'date',
        type: 'send', // or 'auto'
        after_action: this.ActionMessage.default
      }
    };
  },

  async beforeMount() {
    await this.getTags();
    await this.listTagAssigned();
    if (this.scenario_id) {
      this.getScenarioDetail();
    }
    this.loading = false;
  },

  methods: {
    ...mapActions('scenario', [
      'getScenario',
      'createScenario',
      'updateScenario'
    ]),
    ...mapActions('tag', [
      'getTags',
      'listTagAssigned'
    ]),

    async getScenarioDetail() {
      const query = {
        id: this.scenario_id
      };

      const response = await this.getScenario(query);
      this.scenarioData = response;
    },

    changeScenarioType(value) {
      console.log(value);
      if (value === 'no_selection') {
        this.scenarioData.mode = 'delay';
      } else {
        this.scenarioData.mode = 'delay';
      }
    },

    changeDeliverTarget(target) {
      if (target === 'all') {
        this.scenarioData.tags = null;
      }
      this.target = target;
    },

    async saveScenario(status) {
      if (status !== 'draft') {
        if (this.$refs.status.checked) {
          this.scenarioData.status = 'enable';
        } else {
          this.scenarioData.status = 'disable';
        }
        const result = await this.$validator.validateAll();
        if (!result) {
          $('input, textarea').each(
            function(index) {
              let input = $(this);
              if (input.attr('aria-invalid') && input.attr('aria-invalid') === 'true') {
                if (input.is(':hidden')) {
                  input = input.parent();
                }
                $('html,body').animate({ scrollTop: input.offset().top - 200 }, 'slow');
                return false;
              }
            }
          );
          return;
        }
      } else {
        this.scenarioData.status = status;
      }

      this.scenarioData.folderId = Util.getQueryParamsUrl('folder_id');

      this.scenarioData.type = this.type || 'send';
      if (!this.scenario_id) {
        const scenarioId = await this.createScenario(this.scenarioData);
        this.onReceiveCreateScenarioResponse(!!scenarioId);
      } else {
        const scenarioId = await this.updateScenario(this.scenarioData);
        this.onReceiveUpdateScenarioResponse(!!scenarioId);
      }
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
