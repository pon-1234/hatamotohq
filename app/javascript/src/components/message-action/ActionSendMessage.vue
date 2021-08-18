<template>
  <div>
    <div v-if="showTitle" style="display: contents">
      <label class="w-100 mt20">
        ラベル
        <span class="label label-sm label-danger" v-if="labelRequired">必須</span>
      </label>
      <div class="w-100">
        <input :name="name+'_label'" placeholder="ラベルを入力してください" type="text" maxlength="12" v-model="value.label"
               class="w-100 form-control" @keyup="changeValue" v-validate="{required: labelRequired && showTitle}"/>
        <span v-if="errors.first(name+'_label')" class="is-validate-label">ラベルは必須です</span>
      </div>
    </div>
    <label class="w-100 mt20">
      テキスト
      <span class="label label-sm label-danger">必須</span>
    </label>
    <div class="w-100">
      <textarea :name="name+'_value'" placeholder="テキストを入力してください" type="text" maxlength="300" v-model="value.text" class="w-100 form-control"  @keyup="changeValue" v-validate="'required'"/>
      <span v-if="errors.first(name+'_value')" class="is-validate-label">テキストは必須です</span>
    </div>
  </div>
</template>
<script>
export default {
  props: {
    value: Object,
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
  created() {
    this.$validator = this.parentValidator;
  },
  methods: {
    changeValue() {
      this.$emit('input', this.value);
    }
  }

};
</script>

<style lang="scss" scoped>

</style>
