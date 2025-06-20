<template>
  <div class="mxw-1200" :key="contentKey">
    <div class="card">
      <div class="card-header left-border">
        <h3 class="card-title">基本設定</h3>
      </div>
      <div class="card-body">
        <div class="form-group d-flex align-items-center">
          <label class="fw-200">フォルダー</label>
          <div class="flex-grow-1">
            <select v-model="autoResponseData.folder_id" class="form-control fw-300">
              <option v-for="(folder, index) in folders" :key="index" :value="folder.id">
                {{ folder.name }}
              </option>
            </select>
          </div>
        </div>

        <div class="form-group d-flex">
          <label class="fw-200">自動応答名<required-mark /></label>
          <div class="flex-grow-1">
            <input
              type="text"
              name="name"
              class="form-control"
              v-model.trim="autoResponseData.name"
              placeholder="自動応答名を入力してください"
              v-validate="'required|max:64'"
              maxlength="65"
              data-vv-as="自動応答名"
            />
            <error-message :message="errors.first('name')"></error-message>
          </div>
        </div>

        <div class="form-group d-flex">
          <label class="fw-200">自動応答 ON/OFF</label>
          <div class="flex-grow-1 d-flex">
            <input
              type="checkbox"
              id="scenario-onoff"
              checked
              data-switch="success"
              v-model="autoResponseData.status"
              true-value="enabled"
              false-value="disabled"
              ref="status"
            />
            <label for="scenario-onoff" data-on-label="オン" data-off-label="オフ"></label>
          </div>
        </div>
      </div>
      <loading-indicator :loading="loading"></loading-indicator>
    </div>

    <div class="card">
      <div class="card-header left-border">
        <h3>反応するキーワードを設定する</h3>
      </div>
      <div class="card-body">
        <div class="form-group d-flex flex-column m-0">
          <label class="mb10">キーワード<required-mark /></label>
          <base-form-tags
            size="md"
            :limit="10"
            class="bot-tag"
            input-id="tags-limit"
            v-model="autoResponseData.keywords"
            :class="errors.first('bot-tag') ? 'invalid-box' : ''"
            placeholder="キーワードを入力してください"
            separator=" ,;"
            :tag-validator="tagValidator"
            invalid-tag-text="無効なタグ"
            duplicate-tag-text="タグはすでに存在します"
            limit-tags-text="キーワード数が上限に達しました"
            add-on-change
            :add-button-text="'追加'"
          >
          </base-form-tags>
          <input
            type="hidden"
            name="keywords"
            data-vv-as="キーワード"
            v-model="autoResponseData.keywords"
            v-validate="'required'"
          />
          <div class="mt-1">
            <small class="text-muted font-12"
              >キーワードはコンマ(半角)区切りで複数設定可能です。【例】キーワード01,キーワード02,キーワード03<br />
              タグの長さは1〜20文字です</small
            >
          </div>
          <span class="invalid-box-label" v-if="error"
            ><b>{{ error.keyword }}</b
            >のキーワードが<b>{{ error.name }}</b
            >で設定されているため設定できません。</span
          >
          <error-message class="w-100" :message="errors.first('keywords')"></error-message>
        </div>
      </div>
      <loading-indicator :loading="loading"></loading-indicator>
    </div>

    <div class="card">
      <div class="card-header left-border">
        <h3>反応する時間帯を設定する</h3>
      </div>
      <div class="card-body">
        <div>
          <div class="custom-control custom-radio custom-control-inline">
            <input
              type="radio"
              id="bizHourEnabledOn"
              name="bizHourEnabled"
              value="default"
              :checked="autoResponseData.biz_hours.enabled"
              @change="autoResponseData.biz_hours.enabled = true"
              class="custom-control-input"
            />
            <label class="custom-control-label" for="bizHourEnabledOn">指定する</label>
          </div>
          <div class="custom-control custom-radio custom-control-inline">
            <input
              type="radio"
              id="bizHourEnabledOff"
              name="bizHourEnabled"
              value="basic"
              :checked="!autoResponseData.biz_hours.enabled"
              @change="autoResponseData.biz_hours.enabled = false"
              class="custom-control-input"
            />
            <label class="custom-control-label" for="bizHourEnabledOff">指定しない</label>
          </div>
        </div>

        <divider></divider>

        <div class="d-flex flex-column">
          <label>曜日</label>
          <div>
            <div class="checkbox-inline">
              <label>
                <input
                  type="checkbox"
                  value="1"
                  class="week_checkbox"
                  autocomplete="off"
                  :disabled="!autoResponseData.biz_hours.enabled ? 'disabled' : false"
                  v-model="isCheckedAllWeekday"
                  @change="selectAllWeekdays"
                />
                <span class="ml-1">全選択</span>
              </label>
            </div>
            <div class="d-flex">
              <template v-for="(weekday, index) in weekdays">
                <div class="mr-2 checkbox-inline" :key="index">
                  <label>
                    <input
                      type="checkbox"
                      name="bizHourWeekday"
                      :value="weekday.value"
                      class="week_checkbox"
                      autocomplete="off"
                      :disabled="!autoResponseData.biz_hours.enabled ? 'disabled' : false"
                      v-model="autoResponseData.biz_hours.weekdays"
                    />
                    <span class="ml-1">{{ weekday.name }}</span>
                  </label>
                </div>
              </template>
            </div>
          </div>
        </div>

        <divider></divider>
        <div class="d-flex flex-column">
          <label>時間帯</label>

          <div class="d-flex mb-2">
            <div class="custom-control custom-radio custom-control-inline">
              <input
                type="radio"
                id="bizHourFullTimeOn"
                name="bizHourFullTime"
                value="default"
                :checked="autoResponseData.biz_hours.is_all_day"
                @change="selectAllDay(true)"
                :disabled="!autoResponseData.biz_hours.enabled ? 'disabled' : false"
                class="custom-control-input"
              />
              <label class="custom-control-label" for="bizHourFullTimeOn">全ての時間</label>
            </div>
            <div class="custom-control custom-radio custom-control-inline">
              <input
                type="radio"
                id="bizHourFullTimeOff"
                name="bizHourFullTime"
                value="basic"
                :checked="!autoResponseData.biz_hours.is_all_day"
                @change="selectAllDay(false)"
                :disabled="!autoResponseData.biz_hours.enabled ? 'disabled' : false"
                class="custom-control-input"
              />
              <label class="custom-control-label" for="bizHourFullTimeOff">時間帯を指定</label>
            </div>
          </div>
          <div class="d-flex">
            <datetime
              v-model="autoResponseData.biz_hours.time.start"
              name="bizHourFullTimeStart"
              input-class="form-control"
              type="time"
              :phrases="{ ok: '確定', cancel: '閉じる' }"
              placeholder="日付を選択してください"
              value-zone="Asia/Tokyo"
              v-validate="'required'"
              data-vv-as="開始日時"
              @input="onBizHoursStartTimeChanged()"
              :disabled="showInputDateTime ? 'disabled' : false"
            ></datetime>
            <div class="mx-2 my-auto">から</div>
            <datetime
              v-model="autoResponseData.biz_hours.time.end"
              name="bizHourFullTimeEnd"
              input-class="form-control"
              type="time"
              :phrases="{ ok: '確定', cancel: '閉じる' }"
              placeholder="日付を選択してください"
              value-zone="Asia/Tokyo"
              v-validate="'required'"
              :min-datetime="autoResponseData.biz_hours.time.start"
              data-vv-as="終了日時"
              @input="onBizHoursEndTimeChanged()"
              :disabled="showInputDateTime ? 'disabled' : false"
            ></datetime>
          </div>
        </div>
      </div>
    </div>

    <div class="card">
      <div class="card-header left-border">
        <h3>反応時のアクションを設定する</h3>
      </div>
      <div class="card-body">
        <div class="form-border">
          <div class="form-group">
            <label>メッセージ本文</label>
            <div>
              <div class="btn btn-primary" data-toggle="modal" data-target="#modal-template">テンプレートから作成</div>
            </div>
            <modal-select-template @selectTemplate="onSelectTemplate" id="modal-template" />
            <message-editor
              :allowCreateFromTemplate="true"
              v-for="(item, index) in autoResponseData.messages"
              :key="index"
              v-bind:data="item"
              v-bind:index="index"
              v-bind:messagesCount="autoResponseData.messages.length"
              @input="onMessageContentChanged"
              @selectTemplate="selectTemplate"
              @remove="removeContent"
              @moveUp="moveUp"
              @moveDown="moveDown"
            />
            <div>
              <div
                class="btn btn-primary"
                @click="addMoreMessageContentDistribution"
                v-if="autoResponseData.messages.length < MAX_AUTO_RESPONSE_MESSAGE"
              >
                <i class="uil-plus"></i><span> メッセージ追加</span>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="card-footer">
        <div class="btn btn-success fw-120" @click="submitCreate()">
          {{ !auto_response_id ? "登録" : "保存" }}
        </div>
      </div>
      <loading-indicator :loading="loading"></loading-indicator>
      <message-preview />
    </div>
  </div>
</template>
<script>
import { mapActions, mapState } from 'vuex';
import Util from '@/core/util';
import ViewHelper from '@/core/view_helper';
import Divider from '../../../components/common/Divider.vue';
import { Datetime } from 'vue-datetime';
import moment from 'moment';

export default {
  components: { Divider, Datetime },
  props: {
    auto_response_id: Number
  },
  data() {
    return {
      MAX_AUTO_RESPONSE_MESSAGE: 3,
      ROOT_PATH: import.meta.env.VITE_ROOT_PATH,
      loading: true,
      contentKey: 0,
      error: null,
      weekdays: this.Weekday,
      autoResponseData: {
        folder_id: null,
        name: '',
        status: 'enabled',
        keywords: [],
        messages: [],
        biz_hours: {
          enabled: false,
          weekdays: [],
          is_all_day: false,
          time: {
            start: '00:00',
            end: '23:59'
          }
        }
      }
    };
  },
  provide() {
    return { parentValidator: this.$validator };
  },

  async created() {
    this.autoResponseData.folder_id = Util.getParamFromUrl('folder_id');
    await this.getAutoResponses();
  },

  async beforeMount() {
    if (this.auto_response_id) {
      const autoResponse = await this.getAutoResponse(this.auto_response_id);
      Object.assign(this.autoResponseData, autoResponse);
    } else {
      this.setDefaultMessage();
    }
    this.loading = false;
  },

  watch: {
    autoResponseData: {
      handler(val) {
        this.setPreviewContent(this.autoResponseData);
      },
      deep: true
    }
  },

  computed: {
    ...mapState('autoResponse', {
      folders: state => state.folders
    }),

    isCheckedAllWeekday() {
      return this.autoResponseData.biz_hours.weekdays.length === 7;
    },

    showInputDateTime() {
      return !this.autoResponseData.biz_hours.enabled || this.autoResponseData.biz_hours.is_all_day;
    }
  },

  methods: {
    ...mapActions('autoResponse', [
      'getAutoResponse',
      'createAutoResponse',
      'updateAutoResponse',
      'setPreviewContent',
      'getAutoResponses'
    ]),

    ...mapActions('template', ['getTemplate']),

    forceRerender() {
      this.contentKey++;
    },

    tagValidator(tag) {
      // Restrict input %
      if (tag.includes('%')) {
        return false;
      } else {
        // Individual tag validator function
        return tag === tag.toLowerCase() && tag.length <= 20;
      }
    },

    onBizHoursStartTimeChanged() {
      this.autoResponseData.biz_hours.time.start = moment(this.autoResponseData.biz_hours.time.start)
        .format('HH:mm')
        .toString();
    },

    onBizHoursEndTimeChanged() {
      this.autoResponseData.biz_hours.time.end = moment(this.autoResponseData.biz_hours.time.end)
        .format('HH:mm')
        .toString();
    },

    async submitCreate() {
      if (this.loading) return;
      this.loading = true;
      const result = await this.$validator.validateAll();
      if (!result) {
        this.loading = false;
        return ViewHelper.scrollToRequiredField(false);
      }

      const data = {
        folder_id: Util.getParamFromUrl('folder_id'),
        ...this.autoResponseData
      };

      if (this.auto_response_id) {
        const response = await this.updateAutoResponse(data);
        if (response) {
          Util.showSuccessThenRedirect(
            '自動応答の変更は完了しました。',
            `${ROOT_PATH}/user/auto_responses?folder_id=${this.autoResponseData.folder_id}`
          );
        } else {
          window.toastr.error('自動応答の変更は失敗しました。');
          this.loading = false;
        }
      } else {
        const response = await this.createAutoResponse(data);
        if (response) {
          Util.showSuccessThenRedirect(
            '自動応答の作成は完了しました。',
            `${ROOT_PATH}/user/auto_responses?folder_id=${this.autoResponseData.folder_id}`
          );
        } else {
          window.toastr.error('自動応答の作成は失敗しました。');
          this.loading = false;
        }
      }
    },

    setDefaultMessage() {
      this.autoResponseData.messages.push({
        message_type_id: this.MessageTypeIds.Text,
        content: {
          type: this.MessageType.Text,
          text: ''
        }
      });
    },

    onMessageContentChanged({ index, content }) {
      this.autoResponseData.messages.splice(index, 1, content);
    },

    addMoreMessageContentDistribution() {
      this.autoResponseData.messages.push({
        message_type_id: this.MessageTypeIds.Text,
        content: {
          type: this.MessageType.Text,
          text: ''
        }
      });
    },

    async onSelectTemplate(template) {
      const templateData = await this.getTemplate(template.id);
      this.autoResponseData.messages = this.autoResponseData.messages.concat(templateData.messages);
      this.forceRerender();
    },

    selectAllWeekdays() {
      this.autoResponseData.biz_hours.weekdays = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    },

    removeContent(index) {
      this.autoResponseData.messages.splice(index, 1);
      this.forceRerender();
    },

    moveUp(index) {
      const option = this.autoResponseData.messages[index];
      this.autoResponseData.messages[index] = this.autoResponseData.messages.splice(index - 1, 1, option)[0];
      this.forceRerender();
    },
    moveDown(index) {
      const option = this.autoResponseData.messages[index];
      this.autoResponseData.messages[index] = this.autoResponseData.messages.splice(index + 1, 1, option)[0];
      this.forceRerender();
    },
    selectAllDay(isAllDay) {
      this.autoResponseData.biz_hours.is_all_day = isAllDay;
      if (isAllDay) this.autoResponseData.biz_hours.time = { start: '00:00', end: '23:59' };
    }
  }
};
</script>
<style lang="scss"  scoped>
  :deep(#tags-limit) {
    border: none;
    background-color: rgba(255, 255, 255, 0) !important;
  }
  
  :deep(.bot-tag.disabled) {
    background-color: #ccc !important;
  }
</style>
