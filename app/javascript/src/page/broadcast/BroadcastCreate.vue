<template>
  <div class="form-common01 create-content" >
    <div class="card">
      <div class="card-header left-border">
        <h3 class="card-title">配信先</h3>
      </div>
      <div class="card-body">
        <div class="row-form01 row-form-send mb10">
            <label><input type="radio" v-model="message_data.type" name="send" value="all"  @click="resetListTag">全員</label>
            <label><input type="radio" v-model="message_data.type" name="send" value="condition" >条件で絞り込む</label>
        </div>
        <div v-show="message_data.type !== 'all'">
          <label>タグ</label>
          <div class="list-checkbox-tag" v-if="refresh_tag">
            <input-tag :data="message_data.tags" @input="addListTag"/>
          </div>
        </div>

        <div v-if="message_data.type !== 'all'">
          <div>
            <label>状態</label>
            <div class="row-form01 row-form-datetime">
              <label>
                <input
                  type="radio"
                  name="friendCondition"
                  value="all"
                  v-model="message_data.conditions.type"
                />友だちリスト全員
              </label>
              <label>
                <input type="radio" name="friendCondition" value="specific"  v-model="message_data.conditions.type" />条件で絞り込む
              </label>
            </div>
            <div v-if="message_data.conditions.type == 'specific'">
              <message-condition @input="changeCondition" v-bind:data="message_data.conditions"/>
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
        <div class="row-form01 row-form-datetime">
          <label>
            <input
              type="radio"
              name="datetime"
              :value="true"
              v-model="message_data.deliver_now"
              @click="changeStartDateForNow"
            />今すぐ配信
          </label>
          <label>
            <input type="radio" name="datetime" :value="false" v-model="message_data.deliver_now"/>配信日時を指定
          </label>
        </div>
        <div v-if="!message_data.deliver_now">
          <VueCtkDateTimePicker v-model="message_data.schedule_at" locale="ja" :min-date="currentDate" no-label format="YYYY-MM-DD HH:mm" button-now-translation="今" />
          <!--<datetime-->
                  <!--type="datetime"-->
                  <!--v-model="message_data.schedule_at"-->
                  <!--value-zone="Asia/Tokyo"-->
                  <!--:min-datetime="currentDate"-->
                  <!--input-class="form-control"-->
          <!--style="max-width: 280px">-->
          <!--</datetime>-->
        </div>
      </div>
    </div>

    <div class="card">
      <div class="card-header left-border">
        <div class="card-title">配信メッセージ設定</div>
      </div>
      <div class="card-body">
        <div class="form-group">
          <label>タイトル<required-mark/></label>
          <input type="text" class="form-control" name="deliver-title" placeholder="タイトルを入力してください" v-model="message_data.title"  v-validate="'required'" data-vv-as="タイトル" id="menudiv" />
          <error-message :message="errors.first('deliver-title')"></error-message>
        </div>
        <div v-if="refresh_content">
          <div class="mb-2">
            <a class="btn btn-secondary" data-toggle="modal" data-target="#modal-template">テンプレートから作成</a>
            <modal-select-message-template @setTemplate="selectTemplate" id="modal-template"/>
          </div>
          <div v-for="(item, index) in message_data.broadcast_messages"  :key="index">
            <message-content-distribution
              :isDisplayTemplate="true"
              v-bind:data="item"
              v-bind:index="index"
              v-bind:countMessages="message_data.broadcast_messages.length"
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
            v-if="message_data.broadcast_messages.length < 5"
          >
            <i class="fa fa-plus"></i> <span>追加</span>
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
    <!-- <message-preview /> -->
  </div>
</template>
<script>
import { mapActions, mapState } from 'vuex';
import moment from 'moment';

export default {
  props: ['broadcast_id'],
  data() {
    return {
      message_data: {
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
        schedule_at: moment().format('YYYY-MM-DD HH:mm'),
        created_at: moment().format('YYYY-MM-DD HH:mm'),
        status: this.MessageDeliveriesStatus.Pending,
        broadcast_messages: [],
        deliver_now: true,
        type: 'all'
      },
      refresh_content: true,
      refresh_tag: true,
      currentDate: moment().format('YYYY-MM-DD HH:mm')
    };
  },

  provide() {
    return { parentValidator: this.$validator };
  },

  created() {
    if (this.broadcast_id) {
      this.message_data.id = this.broadcast_id;
    } else {
      this.message_data.broadcast_messages.push({
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
  },

  computed: {
    ...mapState('message', {
      message: state => state.message
    })
  },

  watch: {
    message_data: {
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

        Object.assign(this.message_data, this.message);

        this.$nextTick(() => {
          this.refresh_tag = true;
        });

        if (this.message_data.deliver_now) {
          this.changeStartDateForNow();
        }
      }
    },

    changeContent({ index, content }) {
      this.message_data.broadcast_messages.splice(index, 1, content);
    },

    removeContent({ index }) {
      this.refresh_content = false;
      this.message_data.broadcast_messages.splice(index, 1);
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },

    moveTopMessage(index) {
      this.refresh_content = false;
      const option = this.message_data.broadcast_messages[index];
      this.message_data.broadcast_messages[index] = this.message_data.broadcast_messages.splice(index - 1, 1, option)[0];
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },
    moveBottomMessage(index) {
      this.refresh_content = false;
      const option = this.message_data.broadcast_messages[index];
      this.message_data.broadcast_messages[index] = this.message_data.broadcast_messages.splice(index + 1, 1, option)[0];
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },

    addMoreMessageContentDistribution() {
      this.message_data.broadcast_messages.push({
        message_type_id: this.MessageTypeIds.Text,
        content: {
          type: this.MessageType.Text,
          text: ''
        }
      });
    },

    changeStartDateForNow() {
      this.message_data.schedule_at = moment().format('YYYY-MM-DD HH:mm');
    },

    changeCondition(value) {
      this.message_data.conditions = value;
    },

    async createMessage(status) {
      this.message_data.status = status;
      if (this.message_data.deliver_now) {
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
      const broadcastFormData = _.cloneDeep(this.message_data);
      broadcastFormData.tag_ids = broadcastFormData.tags.map(_ => _.id);
      delete broadcastFormData.tags;
      if (!this.broadcast_id) {
        const broadcastId = await this.createBroadcast(broadcastFormData);
        if (broadcastId) this.onCreateSuccess();
        if (!broadcastId) this.onCreateFailure();
      } else {
        await this.updateBroadcast(broadcastFormData);
        window.toastr.success('一斉配信の作成は失敗しました。');
        setTimeout(() => {
          window.location.href = process.env.MIX_ROOT_PATH + '/user/broadcasts';
        }, 500);
      }
    },

    // Handle broadcast creation response
    onCreateSuccess() {
      window.toastr.success('一斉配信の作成は完了しました。');
      setTimeout(() => {
        window.location.href = process.env.MIX_ROOT_PATH + '/user/broadcasts';
      }, 500);
    },
    onCreateFailure() {
      window.toastr.error('一斉配信の作成は失敗しました。');
      setTimeout(() => {
        window.location.href = process.env.MIX_ROOT_PATH + '/user/broadcasts/new';
      }, 1000);
    },

    selectTemplate(template) {
      Object.assign(this.message_data, {
        title: template.title,
        broadcast_messages: template.contents
      });
      this.refresh_content = false;

      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },

    addListTag(data) {
      this.message_data.tags = data;
    },

    resetListTag() {
      this.refresh_tag = false;
      this.message_data.tags = [];
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
