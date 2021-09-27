<template>
  <div class="mxw-1200">
    <div class="card">
      <div class="card-header left-border">
        <h3 class="card-title">基本設定</h3>
      </div>
      <div class="card-body">
        <div class="form-group d-flex align-items-start">
          <div class="d-flex fw-300 align-items-center">
            <span class="font-weight-bold">リッチメニュー名<required-mark/></span>
            <div v-b-tooltip.hover title="タイトルは管理画面のみで使用され、ユーザーには表示されません。" class="ml-2">
              <i class="text-md far fa-question-circle"></i>
            </div>
          </div>
          <div class="flex-grow-1">
            <input v-model.trim="richMenuData.name" type="text" name="name" class="form-control" placeholder="リッチメニュー（ホーム）" v-validate="'required'" data-vv-as="リッチメニュー名">
            <error-message :message="errors.first('name')"></error-message>
          </div>
        </div>

        <div class="form-group d-flex align-items-start mt-2">
          <div class="d-flex fw-300 align-items-center">
            <span class="font-weight-bold">トークルームメニュー<required-mark/></span>
            <div v-b-tooltip.hover title="チャットルームの下部にあるメニューバーに表示するテキストです。" class="ml-2">
              <i class="text-md far fa-question-circle"></i>
            </div>
          </div>
          <div class="flex-grow-1">
            <input v-model.trim="richMenuData.chat_bar_text" type="text" name="richmenu-title" class="form-control" placeholder="トップメニュー" v-validate="'required|max:14'" data-vv-as="トークルームメニュー">
            <error-message :message="errors.first('richmenu-title')"></error-message>
          </div>
        </div>

        <div class="form-group d-flex align-items-start mt-2">
          <div class="d-flex fw-300 align-items-center">
            <span class="font-weight-bold">メニューの初期状態<required-mark/></span>
            <div v-b-tooltip.hover title="チャットルームを開いたときに、リッチメニューを表示するかしないかを選択します。" class="ml-2">
              <i class="text-md far fa-question-circle"></i>
            </div>
          </div>
          <div class="radio-group flex-grow-1 flex-column">
            <div class="radio">
              <label class="">
                <input
                  v-model="richMenuData.selected"
                  name="selected"
                  type="radio"
                  v-bind:value="true"
                />
                表示する
              </label>
            </div>
            <div class="radio">
              <label class="">
                <input
                  v-model="richMenuData.selected"
                  name="selected"
                  type="radio"
                  v-bind:value="false"
                />
                表示しない
              </label>
            </div>
          </div>
        </div>
      </div>

      <loading-indicator :loading="loading"></loading-indicator>
    </div>

    <!--Editor-->
    <rich-menu-content-editor
      @input="richMenu"
      :background="backgroundUrl"
      :templateId="richMenuData.template_id"
      :templateValue="templateValue"
      :templateType="templateType"
      @onMediaChanged="onMediaChanged($event)">
    </rich-menu-content-editor>

    <div class="card">
      <div class="card-header left-border">
        <h3 class="card-title">配信先設定</h3>
      </div>
      <div class="card-body">
        <div class="radio-group">
          <label role="button"><input class="mr-1" type="radio" v-model="richMenuData.target" name="target" value="all">全員</label>
          <label role="button"><input class="mr-1" type="radio" v-model="richMenuData.target" name="target" value="condition" >タグで絞り込む</label>
        </div>
        <div v-if="richMenuData.target === 'condition'">
          <label>タグ</label>
          <div class="list-checkbox-tag">
            <input-tag :tags="tags" @input="onTagsChanged"/>
          </div>
        </div>
      </div>

      <loading-indicator :loading="loading"></loading-indicator>
    </div>

    <div>
      <button @click="submitRichMenu" class="btn btn-success fw-120">保存</button>
    </div>

    <modal-rich-menu-template-selection :selectionId="richMenuData.template_id" @accept="templateChange"></modal-rich-menu-template-selection>
    <modal-select-media :types="['richmenu']" :filterable="false" @select="onMediaChanged($event)"></modal-select-media>
  </div>
</template>

<script>
import Util from '@/core/util';
import moment from 'moment';
import { mapActions } from 'vuex';

export default {
  props: {
    rich_menu_id: {
      type: Number,
      required: false
    }
  },
  data() {
    return {
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH,
      loading: true,
      contentKey: 0,
      richMenuData: {
        id: null,
        folder_id: Util.getParamFromUrl('folder_id'),
        media_id: null,
        name: null,
        template_id: 201,
        chat_bar_text: null,
        areas: [],
        selected: false,
        target: 'all', // or 'condition'
        conditions: null
      },
      templateValue: 6,
      templateType: 'large',
      backgroundUrl: null,

      tags: []
    };
  },

  provide() {
    return { parentValidator: this.$validator };
  },

  async beforeMount() {
    await this.getTags();
    if (this.rich_menu_id) {
      await this.fetchRichMenu();
    }
    this.loading = false;
  },

  methods: {
    ...mapActions('tag', [
      'getTags'
    ]),
    ...mapActions('richmenu', [
      'getRichMenu',
      'createRichMenu',
      'updateRichMenu'
    ]),

    forceRerender() {
      this.contentKey++;
    },

    async fetchRichMenu() {
      const richMenu = await this.getRichMenu(this.rich_menu_id);
      this.richMenuData = _.omit(richMenu, ['conditions']);
      this.parseConditions(richMenu.conditions);
      this.backgroundUrl = richMenu.image_url;
      this.forceRerender();
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

      payload.conditions = this.buildConditions();

      if (this.templateType === 'compact') {
        payload.size.height = 843;
      }

      let response = null;
      if (this.rich_menu_id) {
        response = await this.updateRichMenu(payload);
      } else {
        response = await this.createRichMenu(payload);
      }

      if (response) {
        Util.showSuccessThenRedirect(
          'リッチメニュの保存は完了しました。',
          `${process.env.MIX_ROOT_PATH}/user/rich_menus`
        );
      } else {
        window.toastr.error('リッチメニューの保存は失敗しました。');
      }
    },

    parseConditions(conditions) {
      if (!conditions) return;
      const tagCondition = conditions.find(_ => _.type === 'tag');
      if (tagCondition) {
        this.tags = tagCondition.data.tags;
      }
    },

    buildConditions() {
      if (this.tags.length === 0) return;
      return [
        {
          type: 'tag',
          data: { tags: this.tags.map(tag => _.pick(tag, ['id', 'name'])) }
        }
      ];
    },

    getPlaceholderDate() {
      return moment().format('YYYY-MM-DD');
    },

    resetTime() {
      this.richMenuData.start_at = moment().format('YYYY-MM-DD');
      this.richMenuData.end_at = moment().add(1, 'days').format('YYYY-MM-DD');
    },

    onTagsChanged(data) {
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
