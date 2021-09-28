<template>
  <div class="input-group input-group-merge">
    <div class="input-group input-group-merge">
      <input :type="inputType" v-validate="'required'" data-vv-as="パースワード" class="form-control" :name="name" placeholder="パスワードを入力してください" v-model="password" @input="onInput">
      <div class="input-group-append" data-password="false" @click="toggle()">
          <div class="input-group-text" :class="inputType === 'text'? 'show-password' : ''">
              <span class="password-eye"></span>
          </div>
      </div>
    </div>
    <error-message :message="errors.first(name)"></error-message>
  </div>
</template>
<script>
export default {
  props: ['name'],
  data() {
    return {
      password: null,
      inputType: 'password'
    };
  },
  methods: {
    toggle() {
      this.inputType = this.inputType === 'password' ? 'text' : 'password';
    },
    onInput() {
      this.$emit('update:password', this.password);
    }
  }
};
</script>