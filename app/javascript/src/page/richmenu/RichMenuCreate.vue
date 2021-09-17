<template>
  <div class="card mxw-1200">
    <div class="card-header d-flex align-items-center">
      <a :href="`${userRootUrl}/user/rich_menus`" class="text-info">
        <i class="fa fa-arrow-left"></i> リッチメニュー一覧
      </a>
      <h5 class="m-auto font-weight-bold">新規登録</h5>
    </div>
    <div class="card-body">
      <div class="card">
        <div class="card-header left-border">
          <h3 class="card-title">基本設定</h3>
        </div>
        <div class="card-body">
          <div class="form-group">
            <label>リッチメニュー名<required-mark/></label>
            <input v-model.trim="richMenuData.name" type="text" name="name" class="form-control" placeholder="リッチメニュー名を入力してください" v-validate="'required'" data-vv-as="リッチメニュー名">
            <error-message :message="errors.first('name')"></error-message>
          </div>

          <div class="form-group">
            <label>メニューバーのテキスト<required-mark/></label>
            <input v-model.trim="richMenuData.chat_bar_text" type="text" name="richmenu-title" class="form-control" placeholder="メニューバーのテキストを入力してください" v-validate="'required|max:14'" data-vv-as="メニューバーのテキスト">
            <error-message :message="errors.first('richmenu-title')"></error-message>
          </div>

          <div class="form-group">
            <label>表示期間<required-mark/></label>
            <div class="d-flex align-items-center">
              <datetime
                type="datetime"
                v-model="richMenuData.start_at"
                input-class="form-control"
                class="theme-success mw-200"
                value-zone="Asia/Tokyo"
                :phrases="{ok: '確定', cancel: '閉じる'}"
              ></datetime>
              <span class="mx-2">~</span>
              <datetime
                type="datetime"
                v-model="richMenuData.end_at"
                input-class="form-control"
                class="theme-success mw-200"
                value-zone="Asia/Tokyo"
                :min-datetime="richMenuData.start_at"
                :phrases="{ok: '確定', cancel: '閉じる'}"
              >
              </datetime>
              <input type="hidden" :value="richMenuData.start_at" name="start-date" v-validate="'required'" data-vv-as="開始時間">
              <input type="hidden" :value="richMenuData.end_at" name="end-date" v-validate="'required'" data-vv-as="終了時間">
              <button class="btn btn-secondary ml-2" @click="resetTime">リセット</button>
            </div>
            <span v-if="messageErrorDateTime"  class="invalid-box-label">{{messageErrorDateTime}}</span>
          </div>
        </div>
      </div>

      <!--Editor-->
      <rich-menu-type
        @input="richMenu"
        :background="backgroundUrl"
        :templateId="richMenuData.template_id"
        :templateValue="templateValue"
        :templateType="templateType"
        @onMediaChanged="onMediaChanged($event)">
      </rich-menu-type>

      <div class="card">
        <div class="card-header left-border">
          <h3 class="card-title">配信設定</h3>
        </div>
        <div class="card-body">
          <div class="form-group">
            <label>配信先</label>
            <div class="row-form01 row-form-send mb10">
              <label><input type="radio" name="send" value="all" :checked="!tags" @click="resetListTag">全員</label>
              <label><input type="radio" name="send" value="sort" :checked="tags && tags.length >= 0">タグで絞り込む</label>
            </div>
            <div class="box-form01 box-form-sort" :style="tags && tags.length >= 0? {display: 'block'}:{display: 'none'}">
              <label>タグ</label>
              <div class="list-checkbox-tag" v-if="refresh_tag">
                <input-tag :tags="tags" @input="addListTag"/>
              </div>
            </div>
          </div>
          <divider></divider>
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
      </div>

    </div>
    <div class="card-footer">
      <button @click="submitRichMenu" class="btn btn-success fw-120">保存</button>
    </div>

    <loading-indicator :loading="loading"></loading-indicator>

    <modal-rich-menu-template-selection :selectionId="richMenuData.template_id" @accept="templateChange"></modal-rich-menu-template-selection>
    <!-- <media-modal :data="{type: 'richmenu'}" @input="changeLineMediaAlias" /> -->
    <modal-alert :title="'表示期間が別のリッチメニューと重複しています。別の表示期間を設定してください'" />
  </div>
</template>

<script>
import Util from '@/core/util';
import moment from 'moment';
import { mapActions } from 'vuex';
import { Datetime } from 'vue-datetime';

export default {
  components: {
    Datetime
  },
  props: [],
  data() {
    return {
      loading: true,
      contentKey: 0,
      richMenuData: {
        folder_id: Util.getParamFromUrl('folder_id'),
        media_id: null,
        name: null,
        template_id: 201,
        chat_bar_text: null,
        areas: [],
        start_at: moment().format('YYYY-MM-DD'),
        end_at: moment().add(1, 'days').format('YYYY-MM-DD')

      },
      templateValue: 6,
      templateType: 'large',
      backgroundUrl: null,
      selected: false,
      tags: null,
      messageErrorDateTime: ''
    };
  },

  provide() {
    return { parentValidator: this.$validator };
  },

  async beforeMount() {
    await this.getTags();
    this.loading = false;
  },

  watch: {
    start_at(val) {
      if (val > this.richMenuData.end_at) {
        this.richMenuData.end_at = val;
      }
    }
  },

  methods: {
    ...mapActions('tag', [
      'getTags'
    ]),
    ...mapActions('richmenu', [
      'createRichMenu'
    ]),

    forceRerender() {
      this.contentKey++;
    },

    templateChange(data) {
      this.templateValue = data.value;
      this.richMenuData.template_id = data.id;
      this.templateType = data.type;
    },

    onMediaChanged(event) {
      this.richMenuData.media_id = event.id;
      this.backgroundUrl = event.preview_url;
    },

    disabledMaxDate() {
      if (this.richMenuData.end_at) { return { from: new Date(this.richMenuData.end_at) }; }
    },

    disabledMinDate() {
      return { to: new Date(this.richMenuData.start_at) };
    },

    richMenu(input) {
      this.richMenuData.areas = input;
    },

    async submitRichMenu() {
      let isError = !(await this.$validator.validateAll());
      // validate areas
      for (const area of this.richMenuData.areas) {
        if (Util.checkConditionActionElement(area.action)) {
          area.expand = true;
          isError = true;
        } else {
          area.expand = false;
        }
      }

      const datetimeStart = moment(this.richMenuData.start_at).format('YYYY-MM-DD HH:mm');
      const datetimeEnd = moment(this.richMenuData.end_at).format('YYYY-MM-DD HH:mm');

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

      const payload = _.cloneDeep(this.richMenuData);
      payload.size = {
        width: 2500,
        height: 1686
      };

      // const data = {
      //   folder_id: 1,
      //   media_id: this.richMenuData.media_id,
      //   name: this.richMenuData.name,
      //   chat_bar_text: this.richMenuData.chat_bar_text,
      //   start_time: datetimeStart,
      //   end_time: datetimeEnd,
      //   template_id: this.richMenuData.template_id,
      //   size: {
      //     width: 2500,
      //     height: 1686
      //   },
      //   selected: this.selected ? 1 : 0,
      //   areas: this.richMenuData.areas
      // };

      if (this.tags) {
        payload.tags = this.tags;
      }

      if (this.templateType === 'compact') {
        payload.size.height = 843;
      }

      const response = await this.createRichMenu(payload);
      console.log('---response---', response);
    },

    getPlaceholderDate() {
      return moment().format('YYYY-MM-DD');
    },

    resetTime() {
      this.richMenuData.start_at = moment().format('YYYY-MM-DD');
      this.richMenuData.end_at = moment().add(1, 'days').format('YYYY-MM-DD');
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
