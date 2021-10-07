<template>
  <div class="mxw-1200">
    <div class="card">
      <div class="card-header left-border">
        <h3 class="card-title">配信先</h3>
      </div>
      <div class="card-body">
        <div class="radio-group">
          <label
            ><input
              class="mr-1"
              type="radio"
              v-model="broadcastData.type"
              name="send"
              value="all"
              @click="resetListTag"
            />全員</label
          >
          <label
            ><input
              class="mr-1"
              type="radio"
              v-model="broadcastData.type"
              name="send"
              value="condition"
            />条件で絞り込む</label
          >
        </div>
        <div v-show="broadcastData.type !== 'all'">
          <label>タグ設定</label>
          <div class="list-checkbox-tag">
            <input-tag :tags="broadcastData.tags" @input="addListTag" />
          </div>
        </div>

        <div v-if="broadcastData.type !== 'all'">
          <div class="divider mt-2"></div>
          <div class="mt-2">
            <label>状態</label>
            <div class="radio-group">
              <label>
                <input
                  type="radio"
                  name="friendCondition"
                  value="all"
                  v-model="broadcastData.conditions.type"
                />友だちリスト全員
              </label>
              <label>
                <input
                  type="radio"
                  name="friendCondition"
                  value="specific"
                  v-model="broadcastData.conditions.type"
                />条件で絞り込む
              </label>
            </div>
            <div v-if="broadcastData.conditions.type == 'specific'">
              <message-condition
                @input="changeCondition"
                v-bind:data="broadcastData.conditions"
              />
            </div>
          </div>
        </div>
      </div>
      <loading-indicator :loading="loading" />
    </div>
    <div class="card">
      <div class="card-header left-border">
        <h3 class="card-title">配信日時</h3>
      </div>
      <div class="card-body">
        <div class="radio-group">
          <label>
            <input
              type="radio"
              name="datetime"
              :value="true"
              v-model="broadcastData.deliver_now"
              @click="changeStartDateForNow"
            />今すぐ配信
          </label>
          <label>
            <input
              type="radio"
              name="datetime"
              :value="false"
              v-model="broadcastData.deliver_now"
            />配信日時を指定
          </label>
        </div>
        <datetime
          v-if="!broadcastData.deliver_now"
          v-model="broadcastData.schedule_at"
          input-class="form-control"
          type="datetime"
          :phrases="{ ok: '確定', cancel: '閉じる' }"
          placeholder="日付を選択してください"
          :min-datetime="currentDate"
          value-zone="Asia/Tokyo"
          zone="Asia/Tokyo"
        ></datetime>
      </div>
      <loading-indicator :loading="loading" />
    </div>

    <!-- 本文設定 -->
    <div class="card" :key="contentKey">
      <div class="card-header left-border">
        <h3 class="card-title">本文</h3>
      </div>
      <div class="card-body">
        <div class="form-group">
          <label>タイトル<required-mark /></label>
          <input
            type="text"
            class="form-control"
            name="broadcast_title"
            placeholder="タイトルを入力してください"
            v-model="broadcastData.title"
            v-validate="'required|max:255'"
            maxlength="256"
            data-vv-as="タイトル"
          />
          <error-message
            :message="errors.first('broadcast_title')"
          ></error-message>
        </div>
        <div v-if="refresh_content">
          <div class="mb-2">
            <div
              class="btn btn-secondary"
              data-toggle="modal"
              data-target="#modalSelectTemplate"
            >
              テンプレートから作成
            </div>
            <modal-select-template
              @selectTemplate="onSelectTemplate"
              id="modalSelectTemplate"
            ></modal-select-template>
          </div>
          <div v-for="(item, index) in broadcastData.messages" :key="index">
            <message-editor
              :isDisplayTemplate="true"
              v-bind:data="item"
              v-bind:index="index"
              v-bind:messagesCount="broadcastData.messages.length"
              @input="changeContent"
              @remove="removeContent"
              @moveTopMessage="moveTopMessage"
              @moveBottomMessage="moveBottomMessage"
            />
          </div>
          <div
            class="btn btn-primary"
            @click="addMoreMessageContentDistribution"
            v-if="broadcastData.messages.length < 5"
          >
            <i class="uil-plus"></i> <span>メッセージ追加</span>
          </div>
        </div>
      </div>
      <loading-indicator :loading="loading" />
    </div>

    <div>
      <div class="row-form-btn d-flex">
        <button
          class="btn btn-success fw-120 mr-1"
          @click="createMessage('pending')"
          :disabled="invalid"
        >
          配信登録
        </button>
        <button
          type="submit"
          class="btn btn-outline-success fw-120"
          @click="createMessage('draft')"
        >
          下書き保存
        </button>
      </div>
    </div>
    <message-preview></message-preview>
  </div>
</template>
<script>
import { mapActions } from 'vuex';
import moment from 'moment-timezone';
import { Datetime } from 'vue-datetime';

export default {
  props: ['broadcast_id'],
  components: {
    Datetime
  },
  data() {
    return {
      userRootUrl: process.env.MIX_ROOT_PATH,
      loading: true,
      contentKey: 0,
      broadcastData: {
        conditions: {
          type: 'all',
          add_friend_date: {
            start_date: null,
            end_date: null
          },
          age: {
            min: 0,
            max: 100
          },
          gender: 'all',
          prefecture: [],
          month_birthday: [],
          message_status: false
        },
        tags: [],
        title: '',
        schedule_at: moment().tz('Asia/Tokyo').format(),
        created_at: moment().tz('Asia/Tokyo').format(),
        status: this.MessageDeliveriesStatus.Pending,
        messages: [],
        deliver_now: true,
        type: 'all'
      },
      refresh_content: true,
      currentDate: moment().tz('Asia/Tokyo').format()
    };
  },

  provide() {
    return { parentValidator: this.$validator };
  },

  created() {
    if (this.broadcast_id) {
      this.broadcastData.id = this.broadcast_id;
    } else {
      this.setDefaultMessageIfNeed();
    }
  },

  async beforeMount() {
    await this.fetchItem();
    this.loading = false;
  },

  watch: {
    broadcastData: {
      handler(val) {
        this.setPreviewContent(val);
      },
      deep: true
    }
  },
  methods: {
    ...mapActions('broadcast', [
      'createBroadcast',
      'updateBroadcast',
      'getBroadcast',
      'setPreviewContent'
    ]),
    ...mapActions('template', [
      'getTemplate'
    ]),
    ...mapActions('system', [
      'setIsSubmitChange'
    ]),

    forceRerender() {
      this.contentKey++;
    },

    async fetchItem() {
      if (this.broadcast_id) {
        const broadcast = await this.getBroadcast(this.broadcast_id);
        Object.assign(this.broadcastData, broadcast);
        if (this.broadcastData.status === 'done') {
          window.location.href = `${process.env.MIX_ROOT_PATH}/user/broadcasts`;
        }
        this.setDefaultMessageIfNeed();
        if (this.broadcastData.deliver_now) {
          this.changeStartDateForNow();
        }
      }
    },

    // set default message if the list message is empty
    setDefaultMessageIfNeed() {
      if (this.broadcastData.messages.length === 0) {
        this.broadcastData.messages.push({
          message_type_id: this.MessageTypeIds.Text,
          content: {
            type: this.MessageType.Text,
            text: ''
          }
        });
      }
    },

    changeContent({ index, content }) {
      this.broadcastData.messages.splice(index, 1, content);
    },

    removeContent({ index }) {
      this.refresh_content = false;
      this.broadcastData.messages.splice(index, 1);
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },

    moveTopMessage(index) {
      this.refresh_content = false;
      const option = this.broadcastData.messages[index];
      this.broadcastData.messages[index] = this.broadcastData.messages.splice(index - 1, 1, option)[0];
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },
    moveBottomMessage(index) {
      this.refresh_content = false;
      const option = this.broadcastData.messages[index];
      this.broadcastData.messages[index] = this.broadcastData.messages.splice(index + 1, 1, option)[0];
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },

    addMoreMessageContentDistribution() {
      this.broadcastData.messages.push({
        message_type_id: this.MessageTypeIds.Text,
        content: {
          type: this.MessageType.Text,
          text: ''
        }
      });
    },

    changeStartDateForNow() {
      this.broadcastData.schedule_at = moment().format('YYYY-MM-DD HH:mm');
    },

    changeCondition(value) {
      this.broadcastData.conditions = value;
    },

    async createMessage(status) {
      this.broadcastData.status = status;
      if (this.broadcastData.deliver_now) {
        this.changeStartDateForNow();
      }

      this.setIsSubmitChange();
      if (status !== 'draft') {
        const result = await this.$validator.validateAll();
        if (!result) {
          $('input, textarea').each(
            function(index) {
              var input = $(this);
              if (input.attr('aria-invalid') && input.attr('aria-invalid') === 'true') {
                $('html,body').animate({ scrollTop: input.offset().top - 200 }, 'slow');
                return false;
              }
            }
          );
          return;
        };
      }

      // Normalize data
      const payload = _.omit(this.broadcastData, ['tags']);
      payload.tag_ids = this.broadcastData.tags.map(_ => _.id);
      if (!this.broadcast_id) {
        const broadcastId = await this.createBroadcast(payload);
        this.onReceiveCreateBroadcastResponse(!!broadcastId);
      } else {
        const broadcastId = await this.updateBroadcast(payload);
        this.onReceiveUpdateBroadcastResponse(!!broadcastId);
      }
    },

    // Handle broadcast creation response
    onReceiveCreateBroadcastResponse(success) {
      if (success) {
        window.toastr.success('一斉配信の保存は完了しました。');
        setTimeout(() => {
          window.location.href = `${process.env.MIX_ROOT_PATH}/user/broadcasts`;
        }, 500);
      } else {
        window.toastr.error('一斉配信の保存は失敗しました。');
        setTimeout(() => {
          window.location.href = `${process.env.MIX_ROOT_PATH}/user/broadcasts/new`;
        }, 500);
      }
    },
    onReceiveUpdateBroadcastResponse(success) {
      if (success) {
        window.toastr.success('一斉配信の更新は完了しました。');
        setTimeout(() => {
          window.location.href = `${process.env.MIX_ROOT_PATH}/user/broadcasts`;
        }, 500);
      } else {
        window.toastr.error('一斉配信の更新は失敗しました。');
        setTimeout(() => {
          window.location.href = `${process.env.MIX_ROOT_PATH}/user/broadcasts`;
        }, 500);
      }
    },

    async onSelectTemplate(template) {
      const templateData = await this.getTemplate(template.id);
      this.broadcastData.messages = templateData.messages;
      this.forceRerender();
    },

    addListTag(data) {
      this.broadcastData.tags = data;
    },

    resetListTag() {
      this.broadcastData.tags = [];
    }
  }
};
</script>

<style lang="scss" scoped>
  .message-pagination-template {
    text-align: center;
  }
</style>
