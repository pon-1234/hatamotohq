<template>
  <div>
    <div class="form-common01">
      <!--<div class="btn-template mb20 fz14" v-if="type !== 'template'">-->
        <!--<a class="btn-block" data-toggle="modal"  data-target="#modal-scenario-template">テンプレートから作成</a>-->
      <!--</div>-->
      <div class="form-border" style="border-top: 0">
        <div class="form-group">
          <label>タイトル<span class="label label-sm label-danger">必須</span></label>
          <input type="text" name="タイトル" class="form-control" placeholder="タイトルを入力してください" v-model="scenario.title" v-validate="'required'">
          <span v-if="errors.first('タイトル')" class="is-validate-label">{{errors.first('タイトル')}}</span>
        </div>
      </div>
      <div class="form-border">
        <div class="form-group">
          <label class="mb10">内容<span class="label label-sm label-danger">必須</span></label>
          <textarea class="form-control" name="内容" rows="5" placeholder="内容を入力してください" v-model="scenario.content" v-validate="'required'" ></textarea>
          <span v-if="errors.first('内容')" class="is-validate-label">{{errors.first('内容')}}</span>
        </div>
      </div>
      <div class="form-border">
        <div class="form-group">
          <label class="mb10">配信</label>
          <div class="flex start ai_center">
            <div class="toggle-switch btn-scenario01">
              <input id="scenario-onoff" class="toggle-input" type="checkbox" v-model="scenario.status" true-value="enable" false-value="disable" ref="status">
              <label for="scenario-onoff" class="toggle-label">
                <span></span>
              </label>
            </div>
            <p class="scenario-status no-mgn">配信する</p>
          </div>
        </div>
      </div>

      <div class="form-border">
        <div class="form-group">
          <label>配信先</label>
          <div class="row-form01 row-form-send mb10">
            <label><input type="radio" name="send" value="all"  :checked="!scenario.tags"  @click="resetListTag">全員</label>
            <label><input type="radio" name="send" value="sort" :checked="scenario.tags && scenario.tags.length >= 0">条件で絞り込む</label>
          </div>
          <div class="box-form01 box-form-sort" :style="scenario.tags && scenario.tags.length >= 0? {display: 'block'}:{display: 'none'}">
            <label>タグ</label>
            <div class="list-checkbox-tag" v-if="refresh_tag">
              <input-tag :data="scenario.tags" @input="addListTag"/>
            </div>
          </div>
        </div>
      </div>

      <div class="form-border">
        <div class="form-group">
          <label>配信開始</label>
          <div class="row-form01 row-form-timing">
            <label>
              <input type="radio" value="no_selection" v-model="scenario.time_base_type" @change="changeTimeBase('no_selection')">選択なし
            </label>
            <label>
              <input type="radio"  value="friend_added" v-model="scenario.time_base_type" @change="changeTimeBase('friend_added')">友達追加時
            </label>
          </div>
        </div>

        <div class="form-group">
          <label>配信タイミング</label>
          <div class="row-form01 row-form-timing">
            <!-- <label v-if="scenario.time_base_type !== 'no_selection'">
              <input type="radio" value="now" v-model="scenario.delivery_timing_type">購読開始直後
            </label> -->
            <label>
              <input type="radio"  value="delay" v-model="scenario.delivery_timing_type">経過時間
            </label>
            <label>
              <input type="radio"  value="time_designation" v-model="scenario.delivery_timing_type"> 指定時刻
            </label>
          </div>
        </div>
      </div>

      <div class="form-border">
        <div class="form-group">
          <label>配信終了アクション設定</label>
          <message-action-type-default
                                        name="action"
                                       :value="scenario.action"
                                       :labelRequired="false"
                                       :showTitle="false"
                                       :showLaunchMesasge="false"
                                       @input="updateAction"
          />

        </div>
      </div>
      <div class="form-bottom">
        <div class="row-form-btn flex start">
          <button type="submit" class="btn btn-submit btn-block" @click="scenarioAdd()" >保存</button>
          <button
            type="submit"
            class="btn btn-draft btn-block"
            @click="scenarioAdd('draft')"
          >下書き保存</button>
        </div>
      </div>
    </div>

    <!-- モーダル -->
    <modal-select-scenario-template @changeSelectedTemplate="changeSelectedTemplate" id="modal-scenario-template"/>
  </div>
</template>
<script>
import Util from '@/core/util';
import { mapActions } from 'vuex';

export default {
  props: ['route', 'type'],
  provide() {
    return { parentValidator: this.$validator };
  },

  data() {
    return {
      refresh_tag: true,
      scenario: {
        title: '',
        content: '',
        tags: null,
        status: 'disable',
        delivery_timing_type: 'delay',
        type: this.type || 'normal',
        time_base_type: 'no_selection',
        action: this.ActionMessage.default
      }
    };
  },

  async beforeMount() {
    await this.getTags();
    await this.listTagAssigned();
  },

  methods: {
    ...mapActions('tag', [
      'getTags',
      'listTagAssigned'
    ]),

    changeSelectedTemplate(scenario) {
      this.refresh_tag = false;
      this.scenario = scenario;
      this.scenario.template_id = scenario.id;

      if (this.scenario.tags && this.scenario.tags.length === 0) {
        this.scenario.tags = null;
      }

      this.$nextTick(() => {
        this.refresh_tag = true;
      });
    },

    changeTimeBase(value) {
      console.log(value);
      if (value === 'no_selection') {
        this.scenario.delivery_timing_type = 'delay';
      } else {
        this.scenario.delivery_timing_type = 'delay';
      }
    },

    async scenarioAdd(status) {
      if (status !== 'draft') {
        if (this.$refs.status.checked) {
          this.scenario.status = 'enable';
        } else {
          this.scenario.status = 'disable';
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
        this.scenario.status = status;
      }

      this.scenario.folderId = Util.getQueryParamsUrl('folder_id');

      this.scenario.type = this.type || 'normal';
      this.$store
        .dispatch('scenario/scenarioAdd', this.scenario)
        .done(res => {
          window.location.href = this.route + '?is_created=true';
        }).fail(e => {
        });
    },

    addListTag(data) {
      this.$set(this.scenario, 'tags', data);
    },

    resetListTag() {
      this.refresh_tag = false;
      this.scenario.tags = null;
      this.$nextTick(() => {
        this.refresh_tag = true;
      });
    },
    updateAction(data) {
      console.log(data);
      this.scenario.action = data;
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
