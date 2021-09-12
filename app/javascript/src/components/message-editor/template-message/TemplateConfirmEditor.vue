<template>
  <div class="row">
    <div class="col-12">
      <div class="form-group">
        <label for="question_title">質問文</label>
        <required-mark/>
        <input class="form-control"
          :name="'confirm-label'+ indexParent"
          placeholder="質問文を入力してください"
          maxlength="160"
          autocomplete="off"
          type="text"
          v-model="defaults.text"
          v-validate="'required'"
          data-vv-as="質問文"
        >
        <error-message :message="errors.first('confirm-label'+indexParent)"></error-message>
      </div>
    </div>
    <div class="col-xl-6" v-for="(item, index) in defaults.actions" :key="index">
      <div class="card card-outline card-success">
        <div class="card-header"><h3 class="card-title">選択肢{{index+1}}</h3></div>
        <div class="card-body">
          <div class="">
            <div class="col-md-12 p-0">
              <message-action-type
                :name="'confirm_'+index"
                :value="item"
                :supports="['', 'postback', 'uri', 'message', 'datetimepicker', 'survey']"
                @input="changeAction(index, ...arguments)"
              />
            </div>
          </div>
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
    margin: 0px!important;
  }
}
</style>
