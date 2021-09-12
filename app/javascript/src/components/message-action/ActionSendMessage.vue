<template>
  <div>
    <div v-if="showTitle" style="display: contents">
      <label class="w-100 mt20">
        ラベル
        <required-mark v-if="labelRequired"/>
      </label>
      <div class="w-100">
        <input :name="name+'_label'" placeholder="ラベルを入力してください" type="text" maxlength="12" v-model="value.label"
          class="w-100 form-control" @keyup="changeValue" v-validate="{required: labelRequired && showTitle}" data-vv-as="ラベル"/>
        <error-message :message="errors.first(name+'_label')"></error-message>
      </div>
    </div>
    <label class="w-100 mt-4">本文<required-mark/></label>
    <div>
      <textarea
        :name="name+'_value'"
        placeholder="本文を入力してください"
        type="text"
        maxlength="300"
        v-model="value.text"
        class="w-100 form-control"
        @keyup="changeValue"
        v-validate="'required'"
        data-vv-as="本文"/>
      <error-message :message="errors.first(name+'_value')"></error-message>
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
