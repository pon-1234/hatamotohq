<template>
  <div>
    <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between"><h3 class="hdg3">Flexメッセージテンプレート一覧</h3>
    </div>

    <div class="container" style="max-width: 1000px; margin: 0;">
      <div class="form-group row">
        <label class="col-sm-4 text-right m-auto">Flexメッセージ名</label>
        <div class="col-sm-8">
          <input class="form-control" name="flex-title" v-model.trim="name" placeholder="Flex メッセージ名を入力してください" type="text" v-validate="{required: isValidate}">
          <span v-if="errors.first('flex-title')" class="is-validate-label">Flexメッセージ名は必須です</span>
        </div>
      </div>

      <div class="form-group row">
        <label class="col-sm-4 text-right m-auto">フォルダ</label>
        <div class="col-sm-8">
          <select class="form-control" name="folder_id" v-model="folderId" type="text" v-validate="'required'">
            <option value="" disabled>- フォルダ -</option>
            <option v-for="(folder, key) in folderLists" :key="key" :value="folder.id">{{folder.name}}</option>
          </select>
        </div>
      </div>

      <div class="form-group row">
        <label class="col-sm-4 text-right m-auto"> テンプレート</label>
        <div class="col-sm-8 align-middle">
          <a data-toggle="modal" data-target="#flexMessageModalPickTemplate" class="btn-block btn-color">Flexメッセージのテンプレートを選ぶ</a>
        </div>
      </div>
    </div>

    <flexmessage-editor v-if="flexMessage !=null" style="margin-top: 30px" :data="flexMessage"
      @input="flexMessageEditable = $event"
      :altTextData="altText"
      :isValidate="isValidate"
      @altText="altText = $event"
    />

    <div class="row-form-btn d-flex justify-content-center">
      <button  class="btn btn-submit btn-block" @click="save">保存</button>
    </div>

    <flexmessage-modal-pick-template :flexMessageTemplates="flexMessageTemplates"
      :name="'flexMessageModalPickTemplate'"
      @input="flexMessageId = $event" />
  </div>
</template>

<script>
import { omitDeep } from '@/core/omitDeep';
import { mapActions } from 'vuex';

export default {
  provide() {
    return { parentValidator: this.$validator };
  },

  props: ['flexMessageTemplates', 'folder_id'],

  data() {
    return {
      name: '',
      altText: '',
      folderId: this.folder_id,
      flexMessageId: '',
      flexMessage: {},
      flexMessageEditable: {},
      folderLists: null,
      isValidate: false
    };
  },

  async beforeMount() {
    await this.getTags();
    await this.listTagAssigned();
  },

  mounted() {
    this.indexFolders();
  },

  watch: {
    flexMessageId(val) {
      for (const flexMessage of this.flexMessageTemplates) {
        if (flexMessage.id === val) {
          this.flexMessage = flexMessage;
          this.flexMessageEditable = {
            json_template: flexMessage.json_template,
            html_template: flexMessage.html_template,
            json_message: JSON.stringify(omitDeep(JSON.parse(flexMessage.json_template), 'editable', 'linkUri', 'id'))
          };
        }
      }
    }
  },

  methods: {
    ...mapActions('tag', [
      'getTags',
      'listTagAssigned'
    ]),

    indexFolders() {
      this.$store.dispatch('flexMessage/indexFolders').then((res) => {
        this.folderLists = res;
      });
    },

    async save() {
      this.isValidate = true;
      setTimeout(() => {
        this.waitToSubmit();
      }, 100);
    },

    async waitToSubmit() {
      let passed = await this.$validator.validateAll();
      if (passed) {
        if (this.flexMessageEditable.passedObject) {
          for (const key of Object.keys(this.flexMessageEditable.passedObject)) {
            if (!this.flexMessageEditable.passedObject[key]) {
              passed = false;
              // move to key
              const className = '.' + key;
              $('html,body').animate({ scrollTop: $(className).offset().top - 100 }, 'slow');
              $(className).addClass('active-flex-el');
              $(className + '-expand').parent().addClass('active');
              break;
            }
          }
        }
      } else {
        $('html,body').animate({ scrollTop: $('.right-content').offset().top - 100 }, 'slow');
      }

      if (!passed) {
        return;
      }
      this.flexMessageEditable.html_template = this.flexMessageEditable.html_template.replace(/<script.*>.*<\/script>/ims, ' '); // remove script
      this.$store.dispatch('flexMessage/createFlexMessage', {
        folderId: this.folderId,
        data: {
          name: this.name,
          altText: this.altText,
          json_message: this.flexMessageEditable.json_message,
          json_template: this.flexMessageEditable.json_template,
          html_template: this.flexMessageEditable.html_template
        }
      }).done((res) => {
        window.location.href = process.env.MIX_ROOT_PATH + '/template/flex-messages/folders/' + this.folderId;
      }).fail((err) => {
        window.toastr.error(err.responseJSON.message);
      });
    }
  }
};
</script>
<style scoped lang="scss">
  ::v-deep {
    .m-auto {
      margin: auto !important;
    }
    .btn-block {
      cursor: pointer;
    }
  }

  .btn-color {
    color: #428bca!important;
  }
</style>
