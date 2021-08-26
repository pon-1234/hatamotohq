<template>
  <div class="card">
    <div class="card-header">
      <h3 class="card-title">一斉配信新規登録</h3>
    </div>
    <div class="card-body" >
      <div class="card">
        <div class="card-header left-border">
          <h3 class="card-title">配信先</h3>
        </div>
        <div class="card-body">
          <div class="radio-group mt-2 mb-2">
            <label><input class="mr-1" type="radio" v-model="broadcastData.type" name="send" value="all"  @click="resetListTag">全員</label>
            <label><input class="mr-1" type="radio" v-model="broadcastData.type" name="send" value="condition" >条件で絞り込む</label>
          </div>
          <div v-show="broadcastData.type !== 'all'">
            <label>タグ</label>
            <div class="list-checkbox-tag" v-if="refresh_tag">
              <input-tag :data="broadcastData.tags" @input="addListTag"/>
            </div>
          </div>

          <div v-if="broadcastData.type !== 'all'">
            <div class="divider"></div>
            <div class="mt-2">
              <label>状態</label>
              <div class="radio-group mt-2 mb-2">
                <label>
                  <input
                    type="radio"
                    name="friendCondition"
                    value="all"
                    v-model="broadcastData.conditions.type"
                  />友だちリスト全員
                </label>
                <label>
                  <input type="radio" name="friendCondition" value="specific"  v-model="broadcastData.conditions.type" />条件で絞り込む
                </label>
              </div>
              <div v-if="broadcastData.conditions.type == 'specific'">
                <message-condition @input="changeCondition" v-bind:data="broadcastData.conditions"/>
              </div>
            </div>
          </div>
        </div>
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
              <input type="radio" name="datetime" :value="false" v-model="broadcastData.deliver_now"/>配信日時を指定
            </label>
          </div>
          <datetime
            v-if="!broadcastData.deliver_now"
            v-model="broadcastData.schedule_at"
            input-class="form-control"
            type="datetime"
            :phrases="{ok: '確定', cancel: '閉じる'}"
            placeholder="日付を選択してください"
            :min-datetime="currentDate"
            value-zone="Asia/Tokyo"
            zone="Asia/Tokyo"
          ></datetime>
        </div>
      </div>

      <div class="card">
        <div class="card-header left-border">
          <div class="card-title">配信メッセージ設定</div>
        </div>
        <div class="card-body">
          <div class="form-group">
            <label>タイトル<required-mark/></label>
            <input type="text" class="form-control" name="deliver-title" placeholder="タイトルを入力してください" v-model="broadcastData.title"  v-validate="'required'" data-vv-as="タイトル" id="menudiv" />
            <error-message :message="errors.first('deliver-title')"></error-message>
          </div>
          <div v-if="refresh_content">
            <div class="mb-2">
              <a class="btn btn-primary" data-toggle="modal" data-target="#modal-template">テンプレートから作成</a>
              <modal-select-message-template @setTemplate="selectTemplate" id="modal-template"/>
            </div>
            <div v-for="(item, index) in broadcastData.broadcast_messages"  :key="index">
              <message-content-distribution
                :isDisplayTemplate="true"
                v-bind:data="item"
                v-bind:index="index"
                v-bind:countMessages="broadcastData.broadcast_messages.length"
                @input="changeContent"
                @setTemplate="selectTemplate"
                @remove="removeContent"
                @moveTopMessage="moveTopMessage"
                @moveBottomMessage="moveBottomMessage"
              />
            </div>
            <div
              class="btn btn-outline-success"
              @click="addMoreMessageContentDistribution"
              v-if="broadcastData.broadcast_messages.length < 5"
            >
              <i class="fa fa-plus"></i> <span>メッセージ追加</span>
            </div>
          </div>
        </div>
      </div>


      <div>
        <div class="row-form-btn d-flex">
          <button
            type="submit"
            class="btn btn-success"
            @click="createMessage('pending')"
            :disabled="invalid"
          >送信</button>
          <button
            type="submit"
            class="btn btn-outline-success"
            @click="createMessage('draft')"
          >下書き保存</button>
        </div>
      </div>
      <message-preview />
    </div>

    <loading-indicator :loading="loading" />
  </div>
</template>
<script>
import { mapActions, mapState } from 'vuex';
import moment from 'moment-timezone';
import { Datetime } from 'vue-datetime';

export default {
  props: ['broadcast_id'],
  components: {
    Datetime
  },
  data() {
    return {
      loading: true,
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
        broadcast_messages: [],
        deliver_now: true,
        type: 'all'
      },
      refresh_content: true,
      refresh_tag: true,
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
      this.broadcastData.broadcast_messages.push({
        message_type_id: this.MessageTypeIds.Text,
        content: {
          type: this.MessageType.Text,
          text: ''
        }
      });
    }
  },

  async beforeMount() {
    await this.fetchItem();
    await this.getTags();
    await this.listTagAssigned();
    this.loading = false
  },

  computed: {
    ...mapState('message', {
      message: state => state.message
    })
  },

  watch: {
    broadcastData: {
      handler(val) {
        console.log('handler watch change message', val);
        this.setMessageDistributions(val);
      },
      deep: true
    }
  },
  methods: {
    ...mapActions('message', [
      'createBroadcast',
      'updateBroadcast',
      'getBroadcast',
      'setMessageDistributions'
    ]),
    ...mapActions('tag', [
      'getTags',
      'listTagAssigned'
    ]),
    ...mapActions('system', [
      'setIsSubmitChange'
    ]),

    async fetchItem() {
      if (this.broadcast_id) {
        this.refresh_tag = false;
        await this.getBroadcast({ id: this.broadcast_id });

        if (this.message.status === 'done') {
          window.location.href = process.env.MIX_ROOT_PATH + '/streams';
        }

        Object.assign(this.broadcastData, this.message);

        this.$nextTick(() => {
          this.refresh_tag = true;
        });

        if (this.broadcastData.deliver_now) {
          this.changeStartDateForNow();
        }
      }
    },

    changeContent({ index, content }) {
      this.broadcastData.broadcast_messages.splice(index, 1, content);
    },

    removeContent({ index }) {
      this.refresh_content = false;
      this.broadcastData.broadcast_messages.splice(index, 1);
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },

    moveTopMessage(index) {
      this.refresh_content = false;
      const option = this.broadcastData.broadcast_messages[index];
      this.broadcastData.broadcast_messages[index] = this.broadcastData.broadcast_messages.splice(index - 1, 1, option)[0];
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },
    moveBottomMessage(index) {
      this.refresh_content = false;
      const option = this.broadcastData.broadcast_messages[index];
      this.broadcastData.broadcast_messages[index] = this.broadcastData.broadcast_messages.splice(index + 1, 1, option)[0];
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },

    addMoreMessageContentDistribution() {
      this.broadcastData.broadcast_messages.push({
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
      const broadcastDataData = _.cloneDeep(this.broadcastData);
      broadcastDataData.tag_ids = broadcastDataData.tags.map(_ => _.id);
      delete broadcastDataData.tags;
      if (!this.broadcast_id) {
        const broadcastId = await this.createBroadcast(broadcastDataData);
        this.onReceiveCreateBroadcastResponse(!!broadcastId);
      } else {
        const broadcastId = await this.updateBroadcast(broadcastDataData);
        this.onReceiveUpdateBroadcastResponse(!!broadcastId);
      }
    },

    // Handle broadcast creation response
    onReceiveCreateBroadcastResponse(success) {
      if (success) {
        window.toastr.success('一斉配信の作成は完了しました。');
        setTimeout(() => {
          window.location.href = `${process.env.MIX_ROOT_PATH}/user/broadcasts`;
        }, 500);
      } else {
        window.toastr.error('一斉配信の作成は失敗しました。');
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

    selectTemplate(template) {
      Object.assign(this.broadcastData, {
        title: template.title,
        broadcast_messages: template.contents
      });
      this.refresh_content = false;

      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },

    addListTag(data) {
      this.broadcastData.tags = data;
    },

    resetListTag() {
      this.refresh_tag = false;
      this.broadcastData.tags = [];
      this.$nextTick(() => {
        this.refresh_tag = true;
      });
    }
  }
};
</script>

<style lang="scss" scoped>
.message-pagination-template {
  text-align: center;
}
</style>
