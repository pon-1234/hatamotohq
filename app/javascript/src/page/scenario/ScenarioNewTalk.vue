<template>
  <div class="scenario-talk create-content">
    <div class="row-ttl01 flex ai_center  flex-wrap justify-content-between">
      <div class="d-flex flex-column">
        <h4 class="hdg3">新規ステップ配信トーク</h4>
        <h4 class="hdg3 hdg3-small" v-if="scenario" style="word-break: break-word;">ステップ名: {{scenario.title}}</h4>
        <div class="d-flex talk-priority align-items-center mt-2">
          <h4 class="hdg3 d-flex align-items-center" v-if="talk">配信No.:<input type="number" class="form-control" v-model="talk.priority" v-validate="'required'" min='1'>&nbsp;通目</h4>
        </div>
      </div>
    </div>
    <div class="form-common01">
      <div class="form-border">
        <div class="form-group">
          <label>タイトル<span class="label label-sm label-danger">必須</span></label>
          <input type="text" name="talk-title" class="form-control" placeholder="タイトルを入力してください" v-model="talk.name" v-validate="'required'">
          <span v-if="errors.first('talk-title')" class="is-validate-label">タイトルは必須です</span>
        </div>
      </div>
      <div class="form-border">
        <div class="form-group" v-if="refresh_content">
          <label>メッセージ本文</label>
            <message-content-distribution
             :isDisplayTemplate="true"
              v-for="(item, index) in talk.message_content_distributions"
              :key="index"
              v-bind:data="item"
              v-bind:index="index"
              @setTemplate="selectTemplate"
              @input="changeContent"
            />
        </div>
      </div>
      <div class="form-border">
        <div  class="form-group" v-if="scenario && (scenario.delivery_timing_type === 'delay' || scenario.delivery_timing_type === 'time_designation') ">
          <label  class="mb10" v-if="scenario && scenario.delivery_timing_type === 'delay'" >配信時期：経過時間</label>
          <label  class="mb10" v-if="scenario && scenario.delivery_timing_type === 'time_designation'">配信時期：時刻指定</label>
          <div v-if="scenario && scenario.delivery_timing_type === 'delay'" class="box-form-timing">
            登録から:
            <input type="text" v-model="delivery_timing_day" class="form-control  delivery-timing-input"  min="0" oninput="this.value=this.value.replace(/[^0-9]/g,'');"  v-validate="'required'">日&nbsp;
            <VueCtkDateTimePicker id="time-select" label="00:00" v-model="delivery_timing_hour" input-size="sm" :error="!delivery_timing_hour" no-label :only-time="true" format="HH:mm" formatted="HH:mm" />&nbsp;時間後
            <input type="hidden" :value="delivery_timing_hour" name="delivery-timing-min" v-validate="'required'">
          </div>
          <div v-if="scenario && scenario.delivery_timing_type === 'time_designation'" class="box-form-timing">
            登録から:
            <input type="text" v-model="talk.delivery_timing" class="form-control  delivery-timing-input"  min="0" oninput="this.value=this.value.replace(/[^0-9]/g,'');"  v-validate="'required'">日後
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
          <button type="submit" class="btn btn-submit btn-block" @click="talkAdd()" >保存</button>
        </div>
      </div>
    </div>
    <MessagePreview />
  </div>
</template>
<script>
import {
  MessageTypeIds,
  MessageType
} from '@/core/constant';
import { mapActions, mapState } from 'vuex';
import Util from '@/core/util';

export default {
  props: ['route', 'scenario_id', 'type'],
  provide() {
    return { parentValidator: this.$validator };
  },

  data() {
    return {
      talk: {
        name: '',
        status: true,
        priority: 1,
        message_content_distributions: [
          {
            message_type_id: MessageTypeIds.Text,
            content: {
              type: MessageType.Text,
              text: ''
            }
          }
        ],
        delivery_timing: 1,
        time_designation: '00:00'
      },
      current_page_template: 1,
      refresh_content: true,
      scenario: null,
      delivery_timing_hour: '00:00',
      delivery_timing_day: 0
    };
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

  async beforeMount() {
    this.getScenario();
    await this.getTags();
    await this.listTagAssigned();
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

    getScenario() {
      const query = {
        id: this.scenario_id
      };

      this.$store.dispatch('scenario/scenarioDetail', query).then((res) => {
        this.scenario = res;
        this.talk.priority = res.messages_count + 1;
      }).catch((err) => {
        console.log(err);
      });
    },

    changeContent({ index, content }) {
      this.talk.message_content_distributions[index] = content;
      this.updateContentMessageDistributions(this.talk.message_content_distributions);
      // this.validate(this.talk);
    },
    async talkAdd() {
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

      if (this.scenario.delivery_timing_type === 'delay') {
        const time = Util.getTimeWithFormat(this.delivery_timing_hour);
        this.talk.delivery_timing = this.delivery_timing_day + 'd' + time;
      } else if (this.scenario.delivery_timing_type === 'time_designation') {
        this.talk.delivery_timing += 'd';
      } else {
        this.talk.delivery_timing = 0;
      }

      const query = {
        id: this.scenario_id,
        name: this.talk.name,
        priority: this.talk.priority,
        delivery_timing: this.talk.delivery_timing,
        time_designation: this.talk.time_designation,
        status: Util.stringStatus(this.talk.status),
        ...this.talk.message_content_distributions[0]
      };

      this.$store
        .dispatch('scenario/talkAdd', query)
        .done(res => {
          if (this.type === 'template') {
            window.location.href = process.env.MIX_ROOT_PATH + '/template/scenarios/' + this.scenario_id + '?is_created=true';
          } else {
            window.location.href = process.env.MIX_ROOT_PATH + '/scenarios/' + this.scenario_id + '?is_created=true';
          }
        }).fail(e => {
          if (e.status === 422) {
            if (this.type === 'template') {
              window.location.href = process.env.MIX_ROOT_PATH + '/template/scenarios/' + this.scenario_id + '?is_created=false';
            } else {
              window.location.href = process.env.MIX_ROOT_PATH + '/scenarios/' + this.scenario_id + '?is_created=false';
            }
          } else {
            this.talk.delivery_timing = this.talk.delivery_timing.replace(/d/g, '').replace('h', '');
          }
        });
    },

    selectTemplate({ index, template }) {
      // eslint-disable-next-line no-undef
      this.refresh_content = false;

      this.talk.message_content_distributions.splice(0, 1, template);

      this.updateContentMessageDistributions(this.talk.message_content_distributions);

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

::v-deep {
  .date-time-picker {
    display: inline-block;
  }

  #time-select-wrapper {
    max-width: 150px!important;
  }
}

.priority-input {
  width: 50px!important;
}

.delivery-timing-input {
  font-size: 17px;
  padding: 4px 12px!important;
}
</style>
