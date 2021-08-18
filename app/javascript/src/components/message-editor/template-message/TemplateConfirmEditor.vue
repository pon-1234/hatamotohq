<template>
  <div>
    <div class="border template-confirm row">
      <div class="col-md-12">
        <div class="form-group">
          <label for="question_title">質問文</label>
          <span class="label label-sm label-danger">必須</span>
          <input class="form-control"
            :name="'confirm-label'+ indexParent"
            placeholder="質問文を入力してください"
            maxlength="160"
            autocomplete="off"
            type="text"
            v-model="defaults.text"
            v-validate="'required'">
          <span v-if="errors.first('confirm-label'+indexParent)" class="is-validate-label">質問文は必須です</span>
        </div>
      </div>
      <div class="col-md-6" v-for="(item, index) in defaults.actions" :key="index">
        <div class="panel panel-default">
          <div class="panel-heading">選択肢{{index+1}}</div>
          <div class="panel-body">
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
