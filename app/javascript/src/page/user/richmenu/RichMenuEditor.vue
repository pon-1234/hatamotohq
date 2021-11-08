<template>
  <div class="mxw-1200">
    <div class="card">
      <div class="card-header left-border">
        <h3 class="card-title">基本設定</h3>
      </div>
      <div class="card-body">
        <div class="form-group d-flex align-items-center">
          <label class="fw-300">フォルダー</label>
          <div class="flex-grow-1">
            <select v-model="richMenuData.folder_id" class="form-control fw-300">
              <option v-for="(folder, index) in folders" :key="index" :value="folder.id">
                {{ folder.name }}
              </option>
            </select>
          </div>
        </div>
        <div class="form-group d-flex align-items-start">
          <div class="d-flex fw-300 align-items-center">
            <span class="font-weight-bold">リッチメニュー名<required-mark /></span>
            <tool-tip title="タイトルは管理画面のみで使用され、ユーザーには表示されません。"></tool-tip>
          </div>
          <div class="flex-grow-1">
            <input
              v-model.trim="richMenuData.name"
              type="text"
              name="name"
              class="form-control"
              placeholder="リッチメニュー（ホーム）"
              v-validate="'required|max:255'"
              data-vv-as="リッチメニュー名"
              maxlength="256"
            />
            <error-message :message="errors.first('name')"></error-message>
          </div>
        </div>

        <div class="form-group d-flex align-items-start mt-2">
          <div class="d-flex fw-300 align-items-center">
            <span class="font-weight-bold">トークルームメニュー<required-mark /></span>
            <tool-tip title="チャットルームの下部にあるメニューバーに表示するテキストです。"></tool-tip>
          </div>
          <div class="flex-grow-1">
            <input
              v-model.trim="richMenuData.chat_bar_text"
              type="text"
              name="richmenu-title"
              class="form-control"
              placeholder="トップメニュー"
              v-validate="'required|max:14'"
              maxlength="15"
              data-vv-as="トークルームメニュー"
            />
            <error-message :message="errors.first('richmenu-title')"></error-message>
          </div>
        </div>

        <div class="form-group d-flex align-items-start mt-2">
          <div class="d-flex fw-300 align-items-center">
            <span class="font-weight-bold">メニューの初期状態<required-mark /></span>
            <tool-tip title="チャットルームを開いたときに、リッチメニューを表示するかしないかを選択します。"></tool-tip>
          </div>
          <div class="radio-group flex-grow-1 flex-column">
            <div class="radio">
              <label>
                <input v-model="richMenuData.selected" name="selected" type="radio" v-bind:value="true" />
                表示する
              </label>
            </div>
            <div class="radio">
              <label>
                <input v-model="richMenuData.selected" name="selected" type="radio" v-bind:value="false" />
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
      @onMediaChanged="onMediaChanged($event)"
    >
    </rich-menu-content-editor>

    <div class="card">
      <div class="card-header left-border">
        <h3 class="card-title">配信先設定</h3>
      </div>
      <div class="card-body">
        <div class="radio-group">
          <label role="button"
            ><input class="mr-1" type="radio" v-model="richMenuData.target" name="target" value="all" />全員</label
          >
          <label role="button"
            ><input
              class="mr-1"
              type="radio"
              v-model="richMenuData.target"
              name="target"
              value="condition"
            />タグで絞り込む</label
          >
        </div>
        <div v-if="richMenuData.target === 'condition'">
          <label>タグ</label>
          <div class="list-checkbox-tag">
            <input-tag :tags="tags" @input="onTagsChanged" />
          </div>
        </div>
      </div>

      <loading-indicator :loading="loading"></loading-indicator>
    </div>

    <div>
      <button @click="submit" class="btn btn-success fw-120">保存</button>
    </div>

    <modal-rich-menu-template-selection
      :selectionId="richMenuData.template_id"
      @accept="onTemplateChanged"
    ></modal-rich-menu-template-selection>

    <modal-select-media :types="['richmenu']" :filterable="false" @select="onMediaChanged($event)"></modal-select-media>
  </div>
</template>

<script>
import Util from '@/core/util';
import { mapActions, mapState } from 'vuex';
import ViewHelper from '@/core/view_helper';

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
    if (this.rich_menu_id) {
      await this.fetchRichMenu();
    }
    await this.getRichMenus();
    this.loading = false;
  },

  computed: {
    ...mapState('richmenu', {
      folders: state => state.folders
    })
  },

  methods: {
    ...mapActions('richmenu', ['getRichMenu', 'createRichMenu', 'updateRichMenu', 'getRichMenus']),

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

    onTemplateChanged(data) {
      this.templateValue = data.value;
      this.richMenuData.template_id = data.id;
      this.templateType = data.type;
    },

    onMediaChanged(event) {
      this.richMenuData.media_id = event.id;
      this.backgroundUrl = event.preview_url;
    },

    richMenu(input) {
      this.richMenuData.areas = input;
    },

    async submit() {
      let isError = !(await this.$validator.validateAll());
      // validate areas
      for (const area of this.richMenuData.areas) {
        if (Util.validateAction(area.action)) {
          area.expand = true;
          isError = true;
        } else {
          area.expand = false;
        }
      }

      if (isError) {
        return ViewHelper.scrollToRequiredField(false);
      }

      const payload = _.cloneDeep(this.richMenuData);
      payload.size = {
        width: 2500,
        height: 1686
      };

      payload.conditions = this.buildConditions();
      if (payload.conditions.length === 0) {
        payload.target = 'all';
      }

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
          `${process.env.MIX_ROOT_PATH}/user/rich_menus?folder_id=${this.richMenuData.folder_id}`
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
      if (this.tags.length === 0) return [];
      return [
        {
          type: 'tag',
          data: { tags: this.tags.map(tag => _.pick(tag, ['id', 'name'])) }
        }
      ];
    },

    onTagsChanged(data) {
      this.tags = data;
    }
  }
};
</script>

<style scoped lang="scss">
  ::v-deep {
    .form-control[disabled],
    .form-control[readonly],
    fieldset[disabled] .form-control {
      background: white !important;
    }

    .date-time-picker {
      max-width: 300px !important;
      margin: unset !important;
    }

    #time-select-wrapper {
      max-width: 150px !important;
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
    border-color: red !important;
  }
</style>
