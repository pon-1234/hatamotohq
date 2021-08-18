<template>
  <div>
    <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
      <h3 class="hdg3">Flexメッセージ新規</h3>
    </div>

    <div v-if="flexMessage !=null">
      <div class="container">
        <div class="form-group row d-flex">
          <label class="col-sm-3 text-right m-auto">Flexメッセージ名</label>
          <div class="col-sm-9">
            <input class="form-control" name="flex-title" placeholder="Flex ッセージ名を入力してください" type="text" v-model.trim="flexMessage.name"  v-validate="'required'">
            <span v-if="errors.first('flex-title')" class="is-validate-label">Flexメッセージ名は必須です</span>
          </div>
        </div>
      </div>

      <flexmessage-editor style="margin-top: 30px"
        :data="flexMessage"
        @input="flexMessageEditable = $event"
        :altTextData="altText"
        @altText="altText = $event"
        />

      <div class="row-form-btn d-flex justify-content-center">
        <button type="submit" class="btn btn-submit btn-block" @click="save">保存</button>
      </div>
    </div>
    <div v-else>
      LOADING..
    </div>
  </div>
</template>

<script>
import { omitDeep } from '@/core/omitDeep';
import { mapActions } from 'vuex';

export default {
  props: ['flexmessage_id', 'folder_id'],
  provide() {
    return { parentValidator: this.$validator };
  },
  data() {
    return {
      flexMessage: null,
      altText: '',
      flexMessageEditable: {}
    };
  },

  async beforeMount() {
    await this.getTags();
    await this.listTagAssigned();
  },

  mounted() {
    this.detailFlexMessage();
  },

  methods: {
    ...mapActions('tag', [
      'getTags',
      'listTagAssigned'
    ]),

    detailFlexMessage() {
      this.$store.dispatch('flexMessage/detailFlexMessage', {
        folderId: this.folder_id,
        flexMessageId: this.flexmessage_id
      }).then((flexMessage) => {
        this.flexMessage = flexMessage;
        this.flexMessageEditable = {
          json_template: flexMessage.json_template,
          html_template: flexMessage.html_template,
          json_message: JSON.stringify(omitDeep(JSON.parse(flexMessage.json_template), 'editable', 'linkUri', 'id'))
        };
        this.altText = JSON.parse(flexMessage.json_message).altText;
      }).catch(() => {
        window.location.href = process.env.MIX_ROOT_PATH + '/template/flex-messages/folders';
      });
    },

    async save() {
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
      this.$store.dispatch('flexMessage/editFlexMessage', {
        folderId: this.folder_id,
        flexMessageId: this.flexmessage_id,
        data: {
          name: this.flexMessage.name,
          altText: this.altText,
          json_message: this.flexMessageEditable.json_message,
          json_template: this.flexMessageEditable.json_template,
          html_template: this.flexMessageEditable.html_template
        }
      }).done((res) => {
        window.location.href = process.env.MIX_ROOT_PATH + '/template/flex-messages/folders/' + this.folder_id;
      }).fail((err) => {
        this.$toastr.e(err.responseJSON.message);
      });
    }

  }
};
</script>
