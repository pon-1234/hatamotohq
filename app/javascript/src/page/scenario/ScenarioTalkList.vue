<template>
  <div>
    <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
      <div class="d-flex flex-column" style="flex: 1; margin-bottom: 10px;">
        <h4 class="hdg3">シナリオ配信メッセージ一覧</h4>
        <h4 class="hdg3 hdg3-small" v-if="scenario" style="word-break: break-all; max-width: 80%">ステップ名:{{scenario.title}}</h4>

        <div style="display: block">
          <button class="btn btn-common01 btn-modal-cancel fz14 "
                  style="margin: initial;width: auto;padding: 10px 30px;"
                  v-if="scenario && scenario.type === 'no_selection'"
                  data-toggle="modal" data-target="#confirmSelectTemplate">
            テンプレートから作成
          </button>
        </div>
        <modal-select-message-template @setTemplate="selectTemplate" id="modal-template"/>

      </div>
      <div class="row-ttl02 flex">
        <!-- <button type="submit" class="btn btn-default" style="padding: 8px 10px; margin-right: 10px" @click="save()">保存</button> -->
        <div class="btn-common02 fz14">
          <a :href="route"><span>新規作成</span></a>
        </div>
      </div>
    </div>

    <div class="tbl-admin01 tbl-linebot01 table-responsive tbl-scenario01 fz14 text-center" id="talk-table">
      <table class="table table-hover" style="overflow-x: scroll">
        <thead>
        <tr>
          <th class="w5">配信</th>
          <th class="w10" style="min-width: 100px">通目</th>
          <th class="w15"  style="min-width: 150px" v-if="scenario && (scenario.mode === 'delay' || scenario.mode === 'time_designation')">配信時間</th>
          <th class="w10">タイトル</th>
          <th class="w25" style="min-width: 200px; ">本文</th>
          <th class="w20" style="min-width: 100px">タイプ</th>
          <th class="w20"></th>
        </tr>
        </thead>
        <tbody id="sort-scenario" v-if="rerender">
          <tr v-for="(talk, index) in talks" :key="talk.id">
            <td >
              <div class="toggle-switch">
                <input id="scenario-talk-onoff01" class="toggle-input" type="checkbox" v-model="talk.isSelected" @change="changeStatusTalk(talk)">
                <label for="scenario-talk-onoff01" class="toggle-label" />
                <span></span>
              </div>
            </td>
            <td  name="num-data" >{{index+1}}</td>
            <td  v-if="scenario && (scenario.mode === 'delay' || scenario.mode === 'time_designation')">{{getDeliverTime(talk)}}</td>
            <td style="max-width: 200px; text-overflow: ellipsis; white-space: nowrap; word-break: break-word; overflow: hidden;">{{talk.name}}</td>
            <td style="min-width: 200px; text-overflow: ellipsis; white-space: nowrap; word-break: break-word; overflow: hidden;" >
              <div class="message-content">
                <message-content :data="talk.content" ></message-content>
              </div>
            </td>
            <td >
              <message-type-label :data="talk.content"/>
            </td>
            <td >
              <div class="row-btn row-btn-customize">
                <div class="btn-edit01" data-toggle="tooltip" title="編集">
                  <a v-bind:href="`${MIX_ROOT_PATH}/template/scenarios/${scenario_id}/talks/${talk.id}`" class="btn-more btn-more-linebot btn-block" v-if="type =='template'">
                    <i class="fas fa-edit"></i>
                  </a>
                  <a v-bind:href="`${MIX_ROOT_PATH}/scenarios/${scenario_id}/talks/${talk.id}`" class="btn-more btn-more-linebot btn-block" v-else>
                    <i class="fas fa-edit"></i>
                  </a>
                </div>
                <div class="btn-copy01" data-toggle="tooltip" title="複製">
                  <a href="#" class="btn-more btn-more-linebot btn-block" data-toggle="modal" data-target="#modal-confirm" @click="setCopyMessageId(talk, index)"><i class="fas fa-copy"></i></a>
                </div>
                <div class="btn-delete01" data-toggle="tooltip" title="削除">
                  <button class="btn-more btn-more-linebot btn-block" data-toggle="modal" data-target="#modal-delete" @click="showModal(talk)">
                    <i class="fas fa-trash-alt"></i>
                  </button>
                </div>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- モーダル -->
    <div v-if="talkDetail" class="modal fade modal-delete modal-common01" id="modal-delete" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <p class="mb10 fz14">以下のステップを削除します。よろしいですか？</p>
            <dl class=" flex group-modal01 no-mgn flex-wrap justify-content-between">
              <dt>タイトル</dt>
              <dd>{{talkDetail ? talkDetail.name : ""}}</dd>
              <dt>内容</dt>
              <dd v-if="talkDetail">
                <div class="message-content">
                  <message-content :data="talkDetail.content" ></message-content>
                </div>
              </dd>
              <dt>タイプ</dt>
              <dd><message-type-label :data="talkDetail.content"/></dd>
            </dl>
          </div>
          <div class="modal-footer flex center">
            <button type="button" class="btn btn-common01 btn-modal-delete" data-dismiss="modal" @click="talkDelete(talkDetail.id)">削除</button>
            <button type="button" class="btn btn-common01 btn-modal-cancel" data-dismiss="modal">キャンセル</button>
          </div>
        </div>
      </div>
    </div>
    <modal-confirm v-bind:title="'コピーしますか？'" type='confirm' @input="confirmCopy"/>
    <modal-confirm id="confirmSelectTemplate" v-bind:title="'テンプレートを選択すると、メッセージが変更されてもよろしいでしょうか？'" type='confirm' @input="confirmTemplateSelect"/>

  </div>
</template>
<script>
import Util from '@/core/util';
import { mapState } from 'vuex';

export default {
  props: ['route', 'scenario_id', 'type'],
  data() {
    return {
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH,
      scenario: null,
      copy_message_index: null,
      scenario_old_tags: [],
      talks: [],
      talkDetail: null,
      dragging: -1,
      rerender: true
    };
  },

  beforeMount() {
    this.getTalks();
  },

  computed: {
    ...mapState('system', {
      success: state => state.success
    })
  },
  watch: {
    success: {
      handler(val) {
        if (val.status) {
          window.toastr.success(val.message);
        } else {
          window.toastr.error(val.message);
        }
      },
      deep: true
    }
  },
  created() {
    if (performance.navigation.type !== performance.navigation.TYPE_RELOAD) {
      if (Util.getParamFromUrl('is_updated') === 'true') {
        window.toastr.success('シナリオ配信 メッセージの変更は完成しました');
      }

      if (Util.getParamFromUrl('is_created') === 'true') {
        window.toastr.success('シナリオ配信 メッセージを登録しました');
      } else if (Util.getParamFromUrl('is_created') === 'false') {
        window.toastr.error('シナリオの数が上限に達しています。登録できません。');
      }
    }
  },

  methods: {
    showModal(talk) {
      this.talkDetail = talk;
    },

    dragStart(which, ev) {
      this.dragging = which;
    },

    dragEnd(ev) {
      this.dragging = -1;
    },

    dragFinish(to, ev) {
      this.moveItem(this.dragging, to);
    },

    moveItem(from, to) {
      if (to === -1) {
        this.removeItemAt(from);
      } else {
        this.talks.splice(to, 0, this.talks.splice(from, 1)[0]);
      }
    },

    removeItem(item) {
      this.talks.splice(this.talks.indexOf(item), 1);
    },

    removeItemAt(index) {
      this.talks.splice(index, 1);
    },

    changePriority() {
      this.talks.forEach((element, index) => {
        element.priority = index + 1;
      });
    },

    changeStatusTalk(talk) {
      talk.status = Util.stringStatus(talk.isSelected);
      this.talksEdit();
    },

    save() {
      this.talksEdit();
    },

    getTalks(page = 1) {
      const query = {
        page: page,
        id: this.scenario_id
      };
      this.$store
        .dispatch('scenario/getTalks', query)
        .done(res => {
          this.talks = res.data.map(talk => {
            talk.isSelected = Util.isEnable(talk.status);
            return talk;
          });

          this.scenario = res.scenario;
        }).fail(e => {});
    },

    talksEdit() {
      this.changePriority();
      const query = {
        id: this.scenario_id,
        data: this.talks
      };
      this.$store
        .dispatch('scenario/talksEdit', query)
        .done(res => {
          this.talks = res.map(talk => {
            talk.isSelected = Util.isEnable(talk.status);
            return talk;
          });
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
          this.talks = this.talks.filter(function(item) {
            return item.id !== id;
          });
          this.talkDetail = null;
        }).fail(e => {});
    },

    setCopyMessageId(talk, index) {
      this.talkDetail = talk;
      this.copy_message_index = index;
    },

    confirmCopy() {
      this.$store
        .dispatch('scenario/copyMessageScenario', { id: this.scenario.id, talk_id: this.talkDetail.id })
        .done(res => {
          this.rerender = false;
          this.talks.splice(0, 0, res);
          this.$nextTick(() => {
            this.rerender = true;
          });
        }).fail(e => {
        });
    },

    getDeliverTime(message) {
      if (this.scenario.mode === 'delay') {
        return Util.timeConvertJp(message.delivery_timing) + '後 ';
      }

      const match = /([0-9]+)/m.exec(message.delivery_timing);
      const dateTime = message.time_designation.split(':');

      if (match && match.length > 1) {
        return match[1] + '日後の' + dateTime[0] + '時' + dateTime[1] + '分';
      }
    },

    confirmTemplateSelect() {
      $('#modal-template').modal('show');
    },

    selectTemplate(template) {
      this.$store
        .dispatch('scenario/createScenarioMessageFromTemplate', { id: this.scenario.id, template_id: template.id })
        .done(res => {
          this.getTalks();
        });
    }
  }
};
</script>
<style lang="scss" scoped>
  .message-content .preview-text-content {
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
  }

  #talk-table td.message-content .chat-item > image, img {
    width: 50px !important;
  }

  #talk-table .message-content .emojione {
    width: auto !important;
  }

  #talk-table .message-content .chat-item {
    padding: 0px;
  }

  .btn.btn-common03{
    display: block;
    color: #fff;
    background: rgb(0, 146, 203);
    border-radius: 5px;
    padding: 12px 10px;
    line-height: 1;
  }
</style>
