<template>
  <div>
    <div>
      <label for="question_title">質問文</label>
      <required-mark />
      <input
        class="form-control"
        :name="'confirm-label' + indexParent"
        placeholder="質問文を入力してください"
        maxlength="160"
        autocomplete="off"
        type="text"
        v-model="defaults.text"
        v-validate="'required'"
        data-vv-as="質問文"
      />
      <error-message :message="errors.first('confirm-label' + indexParent)"></error-message>
    </div>

    <ul class="w-100 nav nav-tabs nav-bordered mt-2">
      <li class="nav-item" v-for="(item, index) in defaults.actions" :key="index">
        <a
          :href="`#messageAction${index}`"
          data-toggle="tab"
          @click="editingActionIndex = index"
          :aria-expanded="editingActionIndex === index"
          :class="editingActionIndex === index ? 'nav-link active' : 'nav-link'"
        >
          <i class="mdi mdi-home-variant d-md-none d-block"></i>
          <span class="d-none d-md-block">選択肢{{ index + 1 }}</span>
        </a>
      </li>
    </ul>

    <div class="w-100 tab-content">
      <div
        :class="editingActionIndex === index ? 'tab-pane show active' : 'tab-pane'"
        v-for="(item, index) in defaults.actions"
        :key="index"
        :id="`#messageAction${index}`"
      >
        <div>
          <message-action-editor
            :name="'confirm_' + index"
            :value="item"
            :supports="['', 'postback', 'uri', 'message', 'datetimepicker', 'survey']"
            @input="changeAction(index, ...arguments)"
          />
        </div>
      </div>
    </div>
  </div>
</template>
<script>

export default {
  props: ['data', 'indexParent'],
  inject: ['parentValidator'],
  data() {
    return {
      editingActionIndex: 0,
      defaults: {
        type: this.TemplateMessageType.Confirm,
        text: '',
        actions: [this.ActionMessage.default, this.ActionMessage.default]
      }
    };
  },
  watch: {
    defaults: {
      handler(val) {
        this.$emit('input', val);
      },
      deep: true
    }
  },
  created() {
    this.$validator = this.parentValidator;
    if (this.data) {
      Object.assign(this.defaults, this.data);
    }
  },
  methods: {
    changeSelectedAction(index, value) {
      this.defaults.actions.splice(index, 1, value);
    },

    changeAction(index, data) {
      this.defaults.actions.splice(index, 1, data);
    }
  }
};
</script>

<style lang="scss" scoped>
  ::v-deep {
    .template-confirm {
      padding: 0px;
      margin: 0px !important;
    }
  }
</style>
