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
      Url
      <span class="label label-sm label-danger">必須</span>
    </label>
    <div class="w-100">
      <input :name="name+'_value'" type="text" maxlength="1000" v-model="value.uri" placeholder="https://example.com"  class="w-100 form-control" @keyup="changeValue" v-validate="{url: {require_protocol: true }, required:true}" />
      <input type="hidden" v-model="value.uri" v-validate="{required:true, url: {require_protocol: true }}" :name="name+'_value'">
      <span v-if="!value.uri" class="is-validate-label">Urlは必須です</span>
      <span v-else-if="errors.first(name+'_value')" class="is-validate-label">Urlが正しいURLではありません</span>
    </div>
  </div>
</template>
<script>
import Util from '@/core/util';

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
  data() {
    return {
      data: this.value
    };
  },
  inject: ['parentValidator'],
  created() {
    this.$validator = this.parentValidator;
  },
  methods: {
    changeValue() {
      this.value.linkUri = this.value.uri;
      this.$emit('input', this.value);
    },

    getRegexUrl() {
      return Util.regexUrl();
    }
  }

};
</script>

<style lang="scss" scoped>

</style>
