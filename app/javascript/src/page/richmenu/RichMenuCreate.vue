<template>
  <section>
    <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
      <h3 class="hdg3">リッチメニュー新規作成</h3>
    </div>

    <div class="form-common01">
      <div class="form-border">
        <div class="form-group">
          <label>タイトル<required-mark/></label>
          <input v-model.trim="title" type="text" name="title" class="form-control" placeholder="タイトルを入力してください"   v-validate="'required'">
          <span v-if="errors.first('title')" class="is-validate-label">タイトルは必須です</span>
        </div>
      </div>

      <div class="form-border">
        <div class="form-group">
          <label>メニューバーのテキスト<required-mark/></label>
          <input v-model.trim="chatBarText" type="text" name="richmenu-title" class="form-control" placeholder="タイトルを入力してください"   v-validate="'required|max:14'">
          <span v-if="errors.firstByRule('richmenu-title', 'required')" class="is-validate-label">タイトルは必須です</span>
          <span v-else-if="errors.firstByRule('richmenu-title', 'max')" class="is-validate-label">14文字までしか入らないです</span>
        </div>
      </div>

      <div class="form-border">
        <div class="form-group">
          <label>表示期間<required-mark/></label>
          <div class="d-flex align-items-center mb20" >
            <datetime
              type="datetime"
              v-model="start_date"
              value-zone="Asia/Tokyo"
              :input-class="{'error-date date-input': !start_date, 'date-input': start_date}">
            </datetime>
            <input type="hidden" :value="start_date" name="start-date" v-validate="'required'">
            &nbsp;&nbsp;<span>~</span>&nbsp;&nbsp;
          </div>
          <div class="d-flex align-items-center mb20">
            <datetime
              type="datetime"
              v-model="end_date"
              value-zone="Asia/Tokyo"
              :min-datetime="start_date"
              :input-class="{'error-date date-input': !end_date, 'date-input': end_date}">
            </datetime>
            <input type="hidden" :value="end_date" name="end_date" v-validate="'required'">
              &nbsp;&nbsp;<button class="btn btn-secondary" @click="resetTime">リセット</button>
          </div>
          <span v-if="messageErrorDateTime"  class="is-validate-label">{{messageErrorDateTime}}</span>
        </div>
      </div>

      <!--Editor-->
      <div class="form-border">
        <rich-menu-type :background="backgroundUrl"
                        :templateId="templateId"
                        :templateValue="templateValue"
                        :typeTemplate="typeTemplate"
                        @input="richMenu"
                        @backgroundAliasChange="line_media_alias = $event"/>
      </div>

      <div class="form-border">
        <div class="form-group">
          <label>配信先</label>
          <div class="row-form01 row-form-send mb10">
            <label><input type="radio" name="send" value="all" :checked="!tags" @click="resetListTag">全員</label>
            <label><input type="radio" name="send" value="sort" :checked="tags && tags.length >= 0">タグで絞り込む</label>
          </div>
          <div class="box-form01 box-form-sort" :style="tags && tags.length >= 0? {display: 'block'}:{display: 'none'}">
            <label>タグ</label>
            <div class="list-checkbox-tag" v-if="refresh_tag">
              <input-tag :data="tags" @input="addListTag"/>
            </div>
          </div>
        </div>
      </div>
      <div class="form-border">
        <div class="form-group">
          <label class="mb10">設定</label>
          <div class="flex start ai_center">
            <div class="toggle-switch btn-keyword01">
              <input v-model="selected" id="keyword-onoff-setting01" class="toggle-input" type="checkbox">
              <label for="keyword-onoff-setting01" class="toggle-label">
                <span></span>
              </label>
            </div>
          </div>
        </div>
      </div>
      <div class="form-bottom">
        <div class="row-form-btn flex start">
          <button @click="submitRichMenu" class="btn btn-submit btn-block">保存</button>
        </div>
      </div>
    </div>

    <rich-menu-modal-template-choose :selectionId="templateId" @accept="templateChange" />
    <media-modal :data="{type: 'richmenu'}" @input="changeLineMediaAlias" />
    <modal-alert :title="'表示期間が別のリッチメニューと重複しています。別の表示期間を設定してください'" />
  </section>
</template>

<script>
import Util from '@/core/util';
import moment from 'moment';
import { mapActions } from 'vuex';

export default {
  props: [],
  data() {
    return {
      templateId: 201,
      templateValue: 6,
      line_media_alias: null,
      backgroundUrl: null,
      title: null,
      chatBarText: null,
      selected: false,
      areas: [],
      start_date: moment().format('YYYY-MM-DD'),
      end_date: moment().format('YYYY-MM-DD'),
      tags: null,
      refresh_tag: true,
      typeTemplate: 'large',
      messageErrorDateTime: ''
    };
  },

  provide() {
    return { parentValidator: this.$validator };
  },

  async beforeMount() {
    await this.getTags();
    await this.listTagAssigned();
  },

  watch: {
    line_media_alias(val) {
      this.backgroundUrl = process.env.MIX_MEDIA_FLEXA_URL + '/' + val;
    },
    start_date(val) {
      if (val > this.end_date) {
        this.end_date = val;
      }
    }
  },

  methods: {
    ...mapActions('tag', [
      'getTags',
      'listTagAssigned'
    ]),

    templateChange(data) {
      this.templateId = data.id;
      this.templateValue = data.value;
      this.typeTemplate = data.type;
    },

    changeLineMediaAlias(alias) {
      this.line_media_alias = alias;
    },

    disabledMaxDate() {
      if (this.end_date) { return { from: new Date(this.end_date) }; }
    },

    disabledMinDate() {
      return { to: new Date(this.start_date) };
    },

    richMenu(input) {
      this.areas = input;
    },

    async submitRichMenu() {
      let isError = !(await this.$validator.validateAll());
      // validate areas
      for (const area of this.areas) {
        if (Util.checkConditionActionElement(area.action)) {
          area.expand = true;
          isError = true;
        } else {
          area.expand = false;
        }
      }

      const datetimeStart = moment(this.start_date).format('YYYY-MM-DD HH:mm');
      const datetimeEnd = moment(this.end_date).format('YYYY-MM-DD HH:mm');

      if (moment(datetimeStart).isAfter(datetimeEnd)) {
        isError = true;
        this.messageErrorDateTime = '開始時間は終了時間の前に設定してください。';
      } else {
        this.messageErrorDateTime = '';
      }

      if (isError) {
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
      }

      const data = {
        start_date: datetimeStart,
        end_date: datetimeEnd,
        line_media_alias: this.line_media_alias,
        templateId: this.templateId,
        size: {
          width: 2500,
          height: 1686
        },
        title: this.title,
        chatBarText: this.chatBarText,
        selected: this.selected ? 1 : 0,
        areas: this.areas,
        folder_id: Util.getQueryParamsUrl('folder_id')
      };

      if (this.tags) {
        data.tags = this.tags;
      }

      if (this.typeTemplate === 'compact') {
        data.size.width = 2500;
        data.size.height = 843;
      }

      this.$store.dispatch('richmenu/createRichmenu', data).then((res) => {
        // thanh cong
        window.location.href = process.env.MIX_ROOT_PATH + '/richmenus';
      }).catch((err) => {
        if (err.status === 400 || err.status === 422) {
          // show dialog error
          $('#modal-alert').modal('show');
        } else if (err.status === 422) {
          window.toastr.error('');
        }
      });

      console.log('submit', JSON.stringify(data));
    },

    getPlaceholderDate() {
      return moment().format('YYYY-MM-DD');
    },

    resetTime() {
      this.start_date = null;
      this.end_date = null;
    },

    resetListTag() {
      this.refresh_tag = false;
      this.tags = null;
      this.$nextTick(() => {
        this.refresh_tag = true;
      });
    },

    addListTag(data) {
      this.tags = data;
    }
  }
};
</script>

<style scoped lang="scss">
  ::v-deep{

    .form-control[disabled], .form-control[readonly], fieldset[disabled] .form-control{
        background: white !important;
    }

    .date-time-picker {
      max-width: 300px!important;
      margin: unset!important;
    }

    #time-select-wrapper {
      max-width: 150px!important;
    }
  }

</style>
<style>
  .date-input {
    font-size: 12px;
    border: 1px solid #ccc;
    border-radius: 3px;
    padding: 7px 10px;
  }
  .time-input {
    font-size: 12px;
    border: 1px solid #ccc;
    border-radius: 3px;
    padding: 7px 10px;
    margin-left: 10px;
    width: 90%;
  }
  .error-date {
    border-color: red!important;
  }
</style>
