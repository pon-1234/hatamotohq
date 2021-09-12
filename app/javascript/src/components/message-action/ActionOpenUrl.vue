<template>
  <div>
    <div v-if="showTitle" style="display: contents">
      <label class="w-100 mt20">
        ラベル
        <required-mark v-if="labelRequired" />
      </label>
      <div class="w-100">
        <input
          :name="name + '_label'"
          placeholder="ラベルを入力してください"
          type="text"
          maxlength="12"
          v-model="value.label"
          class="w-100 form-control"
          @keyup="changeValue"
          v-validate="{ required: labelRequired && showTitle }"
          data-vv-as="ラベル"
        />
        <error-message :message="errors.first(name + '_label')"></error-message>
      </div>
    </div>
    <label class="mt-4">URL<required-mark /></label>
    <div>
      <input
        :name="name + '_value'"
        type="text"
        maxlength="1000"
        v-model="value.uri"
        placeholder="https://example.com"
        class="w-100 form-control"
        @keyup="changeValue"
        v-validate="{ url: { require_protocol: true }, required: true }"
        data-vv-as="URL"
      />
      <!-- <input
        type="hidden"
        v-model="value.uri"
        v-validate="{ required: true, url: { require_protocol: true } }"
        :name="name + '_value'"
      /> -->
      <error-message :message="errors.first(name + '_value')"></error-message>
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

<style lang="scss" scoped></style>
