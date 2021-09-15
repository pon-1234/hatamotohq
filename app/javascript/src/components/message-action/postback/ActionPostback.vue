<template>
  <div>
    <!-- <div v-if="showTitle">
      <label class="w-100 mt10">
        ラベル
        <required-mark v-if="labelRequired"/>

      </label>
      <div class="w-100">
        <input type="text"
          :name="name+'_label'"
          placeholder="ラベルを入力してください"
          :maxlength="type == 'image_carousel'?12:20"
          v-model="label" class="w-100 form-control"
          v-validate="{required: labelRequired && showTitle}"
          @keyup="changeLabel"
          />
        <span  v-if="errors.first(name+'_label')" class="invalid-box-label">ラベルは必須です</span>
      </div>
    </div> -->

    <label class="w-100 mt20">
      アクション
    </label>

    <div class="w-100">
      <select type="text" maxlength="12" v-model="currentPostBackType" class="w-100 form-control" @change="changeSelected">
        <option v-for="(val,key) of types" :key="key" :value="key">{{val}}</option>
      </select>
    </div>
    <div class="w-100">
      <action-postback-text
        v-if="currentPostBackType==='text'"
        :value="content"
        :name="name"
        @input="updateContent">
      </action-postback-text>

      <action-postback-template
        v-if="currentPostBackType==='template'"
        :value="content"
        @input="updateContent"
        :name="name">
      </action-postback-template>

      <action-postback-scenario
        v-if="currentPostBackType==='scenario'"
        :value="content"
        :name="name"
        @input="updateContent">
      </action-postback-scenario>

      <action-post-back-type-flex-message v-if="currentPostBackType==='flexMessage'"
        :value="content"
        :name="name"
        @input="updateContent" />

      <action-postback-email
        v-if="currentPostBackType === 'email'"
        :value="content"
        :name="name"
        @input="updateContent">
      </action-postback-email>

      <action-postback-tag
        v-if="currentPostBackType==='tag'"
        :value="content"
        :name="name"
        @input="updateContent">
      </action-postback-tag>

      <action-post-back-type-survey
        v-if="currentPostBackType==='survey'"
        :value="content"
        :name="name"
        @input="updateContent">
      </action-post-back-type-survey>
    </div>
  </div>
</template>
<script>

export default {
  props: {
    value: String,
    name: {
      type: String,
      default: 'action'
    },
    showTitle: {
      type: Boolean,
      default: true
    },
    labelRequired: {
      type: Boolean,
      default: true
    }
  },
  inject: ['parentValidator'],

  data() {
    return {
      types: this.PostbackTypes,
      currentPostBackType: null,
      content: null
      // label: ''
    };
  },

  watch: {
    value: {
      handler(val) {
        this.setupData();
      },
      deep: true
    }
  },

  created() {
    this.$validator = this.parentValidator;
    this.setupData();
  },

  methods: {
    updateContent(content) {
      this.content = content;
      this.emitData();
    },

    emitData() {
      this.$emit('input', {
        type: this.currentPostBackType,
        content: this.content
      });
    },

    changeSelected() {
      this.emitData();
    },

    setupData() {
      const data = this.value;
      this.content = data.content;
      this.currentPostBackType = data.type || 'no-action';
    }
  }
};
</script>

<style scoped>

</style>