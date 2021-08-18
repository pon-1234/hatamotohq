<template>
  <div>
    <div v-if="showTitle" style="display: contents">
      <label class="w-100 mt20">
        ラベル
        <span class="label label-sm label-danger" v-if="labelRequired">必須</span>
      </label>
      <div class="w-100">
        <input :name="name+'_label'" placeholder="ラベルを入力してください" type="text" maxlength="12" v-model="data.label"
               class="w-100 form-control" @keyup="changeValue" v-validate="{required: labelRequired && showTitle}"/>
        <span v-if="errors.first(name+'_label')" class="is-validate-label">ラベルは必須です</span>
      </div>
    </div>
    <label class="w-100 mt20">
      TEL
      <span class="label label-sm label-danger">必須</span>
    </label>
    <div class="w-100">
      <input :name="name+'_value'" type="text" maxlength="1000" v-model="data.uri" placeholder="09044445555"  class="w-100 form-control" @blur="changeValueUrl" v-validate="{required: true, regex:  getRegexTel()}" />
      <input type="hidden" v-model="data.uri" v-validate="{required: true, regex:  getRegexTel()}" :name="name+'_value'">
      <span v-if="!data.uri" class="is-validate-label">
        Telは必須です
      </span>
      <span v-else-if="errors.first(name+'_value')" class="is-validate-label">
        入力内容に半角数字以外が入力されてます。-なしで半角数字で電話番号を入力してください。(例:「09044445555」)
      </span>
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

  inject: ['parentValidator'],

  data() {
    return {
      data: {}
    };
  },

  watch: {
    value: {
      handler(val) {
        this.data.uri = val.uri.replace('tel://', '');
        this.data.linkUri = val.linkUri.replace('tel://', '');
      },
      deep: true
    }
  },

  created() {
    this.$validator = this.parentValidator;
    // eslint-disable-next-line no-undef
    this.data = _.cloneDeep(this.value);
    this.data.uri = this.data.uri.replace('tel://', '');
    this.data.linkUri = this.data.linkUri.replace('tel://', '');
  },

  methods: {
    changeValueUrl() {
      this.data.linkUri = this.data.uri;

      this.changeValue();
    },

    changeValue() {
      // eslint-disable-next-line no-undef
      const data = _.cloneDeep(this.data);

      if (!this.data.uri.includes('tel://')) {
        data.linkUri = 'tel://' + data.linkUri;
        data.uri = 'tel://' + data.uri;
      } else {
        data.linkUri = 'tel://' + data.linkUri;
        data.uri = 'tel://' + data.uri;
      }

      this.$emit('input', data);
    },

    getRegexTel() {
      return Util.regexTel();
    }
  }

};
</script>

<style lang="scss" scoped>

</style>
