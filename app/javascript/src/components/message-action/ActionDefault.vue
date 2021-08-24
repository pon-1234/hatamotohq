<template>
  <div>
    <label class="w-100 mt20">
      ラベル
      <required-mark/>
    </label>
    <div class="w-100">
      <input type="text" maxlength="20" placeholder="ラベルを入力してください" v-model="value.label" class="gw-100 form-control"  @keyup="changeValue" v-validate="'required'" name="action-default"/>
      <span v-if="errors.first('action-default')" class="is-validate-label">ラベルは必須です</span>
    </div>
  </div>
</template>
<script>
export default {
  props: ['value'],
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
