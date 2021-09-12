<template>
  <div>
    <label class="mt-4">ラベル<required-mark/></label>
    <div>
      <input type="text" maxlength="20" placeholder="ラベルを入力してください" v-model="value.label" class="gw-100 form-control"  @keyup="changeValue" v-validate="'required'" data-vv-as="ラベル" name="action-default"/>
      <error-message :message="errors.first('action-default')"></error-message>
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
