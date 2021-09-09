<template>
  <div>
    <div v-if="showTitle">
      <label class="w-100 mt10">
        ラベル
        <required-mark v-if="labelRequired"/>
      </label>
      <div class="w-100">
        <input type="text" :name="name+'_label'" placeholder="ラベルを入力してください" maxlength="12" v-model="label"
               class="w-100 form-control" v-validate="{required: labelRequired && showTitle}" @keyup="changeLabel"/>
        <span v-if="errors.first(name+'_label')" class="invalid-box-label">ラベルは必須です</span>
      </div>
    </div>

    <div class="form-group mt-2" v-if="showLaunchMesasge">
      <label>選択時のメッセージ</label>
      <input type="text" placeholder="選択時のメッセージを入力してください" v-model="displayText"
        class="w-100 form-control" @keyup="changeDisplayText($event)"/>
    </div>

    <div class="message-item" v-for="(message, index) in messages" :key="index">
      <div class="d-flex">
        <label style="flex: 1">アクション{{index + 1}}</label>
        <div tyle="float:right" class="d-inline-block" v-if="messages.length > 1">
          <a class="btn btn-default" @click="moveUpMessage(index)">
            <i class="fa fa-arrow-up"></i></a>
          <a class="btn btn-default" @click="moveDownMessage(index)">
            <i class="fa fa-arrow-down"></i></a>
          <a class="btn btn-default" @click="removeMessage(index)">
            <i class="fa fa-minus"></i></a>
        </div>
      </div>
      <action-postback :showTitle="false"
                       :value="message"
                       :name="name+'_postback_'+index"
                       :labelRequired="false"
                       @input="changeAction(index, $event)">
      </action-postback>
    </div>
    <div class="text-center mt-4" v-if="messages.length < 3">
      <button class="btn btn-outline-success" type="button" @click="addMessage()"><i
        class="fa fa-plus"></i> アクションの追加
      </button>
    </div>

    <div>
      <label class="w-100 mt20">
        タグ設定
      </label>
      <div class="tag-content row">
        <div class="col-md-6 d-flex-auto">
          <label class="d-inline-block" style="width: 110px;vertical-align: middle; font-weight: 500;">タグを追加</label>
          <action-post-back-type-tag
            v-if="refreshTag"
            :value="tagContent.content"
            :name="name + '_tag'"
            @input="updateTagContent">
          </action-post-back-type-tag>
        </div>

        <div class="col-md-6 d-flex-auto">
          <label class="d-inline-block" style="width: 110px;vertical-align: middle; font-weight: 500;">タグをはずす</label>
          <action-post-back-type-tag
            v-if="refreshTag"
            :value="tagDeleteContent.content"
            :name="name + '_tag_delete'"
            @input="deleteTagContent">
          </action-post-back-type-tag>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Util from '../../../core/util';

export default {
  props: {
    value: Object,
    labelRequired: Boolean,
    showTitle: Boolean,
    name: String,

    showLaunchMesasge: {
      default: true,
      type: Boolean
    }
  },

  data() {
    return {
      data: {},
      label: null,
      displayText: null,
      tagContent: { type: 'tag', content: { tag_ids: [] } },
      tagDeleteContent: { type: 'tag_delete', content: { tag_ids: [] } },
      messages: [Util.jsonToBase64({
        type: 'no-action'
      })],
      refreshTag: true
    };
  },
  inject: ['parentValidator'],

  created() {
    this.$validator = this.parentValidator;
    this.setup();
  },

  watch: {
    value: {
      deep: true,
      handler(val) {
        this.setup();
        console.log(val, 'watch', name);
        // this.refreshTag = false;
        // this.$nextTick(() => {
        //   this.refreshTag = true;
        // });
      }
    }
  },

  methods: {
    setup() {
      if (this.value) {
        const data = Util.base64ToJson(this.value.data);
        this.label = this.value.label || null;
        this.messages = data.messages;
        this.displayText = this.value.displayText || null;
        this.tagContent = data.tag || { type: 'tag', content: { tag_ids: [] } };
        this.tagDeleteContent = data.tag_delete || { type: 'tag_delete', content: { tag_ids: [] } };
      }
    },
    updateTagContent(content) {
      this.tagContent = {
        type: 'tag',
        content: content
      };

      this.updateData();
    },

    deleteTagContent(content) {
      this.tagDeleteContent = {
        type: 'tag_delete',
        content: content
      };

      this.updateData();
    },

    changeAction(index, message) {
      this.$set(this.messages, index, message);
      this.updateData();
    },

    addMessage() {
      this.messages.push(Util.jsonToBase64({
        type: 'no-action'
      }));

      this.updateData();
    },

    removeMessage(index) {
      this.messages.splice(index, 1);
      this.updateData();
    },

    moveUpMessage(index) {
      if (index > 0) {
        const to = index - 1;
        this.messages.splice(to, 0, this.messages.splice(index, 1)[0]);
        this.updateData();
      }
    },

    moveDownMessage(index) {
      if (index < this.messages.length) {
        const to = index + 1;
        this.messages.splice(to, 0, this.messages.splice(index, 1)[0]);
        this.updateData();
      }
    },

    changeLabel() {
      this.updateData();
    },

    changeDisplayText($event) {
      this.displayText = $event.target.value;
      this.updateData();
    },

    updateData() {
      this.$emit('input', {
        type: 'postback',
        label: this.label,
        displayText: this.displayText,
        data: Util.jsonToBase64({
          displayText: this.displayText,
          tag: this.tagContent,
          tag_delete: this.tagDeleteContent,
          messages: this.messages
        })
      });
    }
  }
};
</script>

<style type="text/scss" scoped>
  .d-flex-auto {
    flex-direction: column;
  }

  .tag-content{
    border: 1px solid #cecece;
    padding: 10px 20px;
    border-radius: 5px;
  }

  .tag {
    vertical-align: middle;
    flex: 1;
    width: calc(100% - 117px);
    display: inline-block;
  }

  @media (max-width: 1290px) {
    .d-flex-auto {
      flex-direction: row;
      margin-top: 10px;
    }

    .d-flex-auto > label {
      width: 100% !important;
    }
    .tag {
      width: 100%;
    }

  }

  .mt-4 {
    margin-top: 10px;
  }

  .btn-default {
    font-size: 10px;
  }

  .btn-add {
    width: 200px;
    border: 1px solid #ededed;
    background: white;
    color: #1b1b1b;
  }

  .btn-add:hover {
    background: white;
    color: #1b1b1b;
  }

  .message-item {
    border: 1px solid #cecece;
    padding: 10px 20px;
    border-radius: 5px;
    margin-top: 10px;
  }
</style>
