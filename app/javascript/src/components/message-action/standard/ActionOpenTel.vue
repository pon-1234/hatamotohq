<template>
  <div>
    <div v-if="showTitle">
      <label class="w-100">
        ラベル
        <required-mark v-if="labelRequired" />
      </label>
      <div class="w-100">
        <input
          :name="name + '_label'"
          placeholder="ラベルを入力してください"
          type="text"
          maxlength="12"
          v-model="label"
          class="w-100 form-control"
          @keyup="onValueChanged"
          data-vv-as="ラベル"
          v-validate="{ required: labelRequired && showTitle }"
        />
        <error-message :message="errors.first(name + '_label')"></error-message>
      </div>
    </div>
    <label class="mt4">
      電話番号
      <required-mark />
    </label>
    <div>
      <input
        :name="name + '_value'"
        type="text"
        maxlength="15"
        v-model="uri"
        placeholder="09044445555"
        class="form-control"
        @blur="onValueChanged"
        data-vv-as="電話番号"
        v-validate="'required|numeric|min:10|max:11'"
      />
      <error-message :message="errors.first(name + '_value')"></error-message>
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

  data() {
    return {
      label: null,
      uri: null,
      linkUri: null
    };
  },

  created() {
    this.$validator = this.parentValidator;
    const data = _.cloneDeep(this.value);
    this.label = data.label;
    this.uri = data.linkUri.replace('tel://', '');
    this.linkUri = data.linkUri.replace('tel://', '');
  },

  methods: {
    onValueChanged() {
      const data = {
        id: this.value.id,
        label: this.label,
        linkUri: `tel://${this.uri}`,
        uri: `tel://${this.uri}`,
        type: this.value.type
      };
      this.$emit('input', data);
    }
  }
};
</script>
