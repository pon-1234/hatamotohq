<template>
  <div class="scenario-talk create-content">
    <div class="row-ttl01 flex ai_center  flex-wrap justify-content-between">
      <div class="d-flex flex-column">
        <h4 class="hdg3">ステップ配信トーク編集</h4>
        <h4 class="hdg3 hdg3-small" v-if="scenario" style="word-break: break-word;">ステップ名: {{scenario.title}}</h4>
        <div class="d-flex talk-priority align-items-center">
          <h4 class="hdg3 d-flex align-items-center" v-if="talk">配信No.:<input type="number" class="form-control" v-model="talk.priority" v-validate="'required'" min='1'>&nbsp;通目</h4>
        </div>
      </div>
    </div>

    <div class="form-common01">
      <div class="form-border">
        <div class="form-group">
          <label>タイトル<required-mark/></label>
          <input type="text" name="talk-title" class="form-control" placeholder="タイトルを入力してください" v-model="talk.name" v-validate="'required'">
          <span v-if="errors.first('talk-title')" class="is-validate-label">タイトルは必須です</span>
        </div>
      </div>
      <div class="form-border">
        <div class="form-group">
          <label>メッセージ本文</label>
          <div  v-if="refresh_content">
            <message-editor
              :isDisplayTemplate="true"
              v-for="(item, index) in talk.broadcast_messages"
              :key="index"
              v-bind:data="item"
              v-bind:index="index"
              @setTemplate="selectTemplate"
              v-bind:countMessages="talk.broadcast_messages.length"
              @input="changeContent"
            />
          </div>
        </div>
      </div>
      <div class="form-border">
        <div  class="form-group" v-if="scenario && (scenario.mode === 'delay' || scenario.mode === 'time_designation') ">
          <label  class="mb10" v-if="scenario && scenario.mode === 'delay'" >配信時期：経過時間で指定</label>
          <label  class="mb10" v-if="scenario && scenario.mode === 'time_designation'">配信時期：時刻指定</label>
          <div v-if="scenario && scenario.mode === 'delay'" class="box-form-timing">
            登録から:
            <input type="text" v-model="delivery_timing_day" class="form-control delivery-timing-input"  min="0" oninput="this.value=this.value.replace(/[^0-9]/g,'');"  v-validate="'required'">日&nbsp;
            <VueCtkDateTimePicker id="time-select" label="00:00" v-model="delivery_timing_hour" input-size="sm" :error="!delivery_timing_hour" no-label :only-time="true" format="HH:mm" formatted="HH:mm" />&nbsp;時間後
            <input type="hidden" :value="delivery_timing_hour" name="delivery-timing-min" v-validate="'required'">
          </div>
          <div v-if="scenario && scenario.mode === 'time_designation'" class="box-form-timing">
            登録から:
            <input type="text" v-model="talk.delivery_timing" class="form-control delivery-timing-input"  min="0" oninput="this.value=this.value.replace(/[^0-9]/g,'');"  v-validate="'required'">日後
            <VueCtkDateTimePicker id="time-select" label="00:00" v-model="talk.time_designation" input-size="sm" no-label :only-time="true" format="HH:mm" formatted="HH:mm" minute-interval="5" />
          </div>
        </div>
      </div>
      <div class="form-border">
        <div class="form-group">
          <label class="mb10">配信</label>
          <div class="flex start ai_center">
            <div class="toggle-switch btn-scenario01">
              <input id="scenario-onoff" class="toggle-input" type="checkbox" v-model="talk.status">
              <label for="scenario-onoff" class="toggle-label">
                <span></span>
              </label>
            </div>
            <p class="scenario-status no-mgn">配信する</p>
          </div>
        </div>
      </div>
      <div class="form-bottom">
        <div class="row-form-btn flex start">
          <button type="submit" class="btn btn-submit btn-block" @click="talkEdit()" >保存</button>
          <div><a class="btn btn-delete btn-block" data-toggle="modal" data-target="#modal-delete">削除</a></div>
        </div>
      </div>
    </div>

    <!-- モーダル -->
    <div class="modal fade modal-delete modal-common01" id="modal-delete" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <p class="mb10 fz14">こちらのステップを削除します。よろしいですか？</p>
          </div>
          <div class="modal-footer flex center">
            <button type="button" class="btn btn-common01 btn-modal-delete" @click="talkDelete(talk_id)" >削除</button>
            <button type="button" class="btn btn-common01 btn-modal-cancel" data-dismiss="modal">キャンセル</button>
          </div>
        </div>
      </div>
    </div>
    <MessagePreview />
  </div>
</template>
<script>
import { mapActions, mapState } from 'vuex';
import Util from '@/core/util';

export default {
  props: ['route', 'scenario_id', 'talk_id'],
  provide() {
    return { parentValidator: this.$validator };
  },
  data() {
    return {
      talk: {
        id: '',
        name: '',
        status: true,
        priority: 1,
        broadcast_messages: [],
        scenario_title: '',
        delivery_timing: 0,
        time_designation: '00:00'
      },
      current_page_template: 1,
      refresh_content: true,
      scenario: null,
      delivery_timing_hour: '00:00',
      delivery_timing_day: 0
    };
  },
  async beforeMount() {
    await this.getScenario();
    await this.fetchItem();
    await this.getTags();
    await this.listTagAssigned();
  },

  computed: {
    ...mapState('messageTemplate', {
      message_templates: state => state.messages,
      total_templates: state => state.total,
      per_page_template: state =>
        state.per_page,
      param_template: state =>
        state.params
    })
  },

  methods: {
    ...mapActions('scenario', [
      'updateContentMessageDistributions'
    ]),
    ...mapActions('messageTemplate', [
      'fetchListMessageTemplate',
      'setParams'
    ]),
    ...mapActions('tag', [
      'getTags',
      'listTagAssigned'
    ]),
    ...mapActions('system', [
      'setIsSubmitChange'
    ]),

    async fetchItem() {
      await this.getTalk();
    },

    changeContent({ index, content }) {
      this.talk.broadcast_messages[index] = content;
      this.updateContentMessageDistributions(this.talk.broadcast_messages);
    },
    getTalk() {
      const query = {
        id: this.scenario_id,
        talk_id: this.talk_id
      };
      this.$store
        .dispatch('scenario/getTalk', query)
        .done(res => {
          this.talk.id = res.id;
          this.talk.name = res.name;
          this.talk.status = Util.isEnable(res.status);
          this.talk.priority = res.priority;
          this.talk.scenario_title = res.scenario_title;
          this.talk.time_designation = res.time_designation;
          this.talk.broadcast_messages.push({
            content: res.content,
            message_type_id: res.message_type.id
          });
          this.updateContentMessageDistributions(this.talk.broadcast_messages);

          const matchDay = /([0-9]+)d/m.exec(res.delivery_timing);
          if (matchDay && matchDay.length > 1) {
            this.delivery_timing_day = matchDay[1];
          } else {
            this.delivery_timing_day = 0;
          }

          const matchHour = /([0-9]+)h/m.exec(res.delivery_timing);
          let hour = '00';
          if (matchHour && matchHour.length > 1) {
            hour = matchHour[1];
          }

          const matchMin = /([0-9]+)i/m.exec(res.delivery_timing);
          let min = '00';
          if (matchMin && matchMin.length > 1) {
            min = matchMin[1];
          }

          this.delivery_timing_hour = hour + ':' + min;

          this.talk.delivery_timing = this.delivery_timing_day;
        }).fail(e => {});
    },
    async talkEdit() {
      const result = await this.$validator.validateAll();
      this.setIsSubmitChange();

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

      if (this.scenario.mode === 'delay') {
        const time = Util.getTimeWithFormat(this.delivery_timing_hour);
        this.talk.delivery_timing = this.delivery_timing_day + 'd' + time;
      } else if (this.scenario.mode === 'time_designation') {
        this.talk.delivery_timing += 'd';
      } else {
        this.talk.delivery_timing = 0;
      }

      const query = {
        talk_id: this.talk_id,
        id: this.scenario_id,
        name: this.talk.name,
        delivery_timing: this.talk.delivery_timing,
        time_designation: this.talk.time_designation,
        status: Util.stringStatus(this.talk.status),
        ...this.talk.broadcast_messages[0],
        priority: this.talk.priority
      };

      this.$store
        .dispatch('scenario/talkEdit', query)
        .done(res => {
          window.location.href = this.route + '?is_updated=true';
        }).fail(e => {
        });
    },
    talkDelete(id) {
      const query = {
        id: this.scenario_id,
        talk_id: id
      };
      this.$store
        .dispatch('scenario/talkDelete', query)
        .done(res => {
          window.location.href = this.route;
        }).fail(e => {});
    },

    selectTemplate({ index, template }) {
      // eslint-disable-next-line no-undef
      this.refresh_content = false;

      this.talk.broadcast_messages.splice(0, 1, template);

      this.updateContentMessageDistributions(this.talk.broadcast_messages);

      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },

    getListMessageTemplate() {
      this.fetchListMessageTemplate(this.param_template);
    },

    changeListTemplate(page) {
      this.setParams({ page: page });
      this.fetchListMessageTemplate(this.param_template);
    },

    getScenario() {
      const query = {
        id: this.scenario_id
      };

      this.$store.dispatch('scenario/getScenario', query).then((res) => {
        this.scenario = res;
      }).catch((err) => {
        console.log(err);
      });
    }
  }
};
</script>
<style lang="scss" scoped>
.talk-priority {
  .hdg3 {
    flex: none!important;
  }
  input {
    width: 60px;
  }
}

.priority-input {
  width: 50px!important;
}

.delivery-timing-input {
  font-size: 17px;
  padding: 4px 12px!important;
}

::v-deep {
  .date-time-picker {
    display: inline-block;
  }

  #time-select-wrapper {
    max-width: 150px!important;
  }
}
</style>
