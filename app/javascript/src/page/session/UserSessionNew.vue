<template>
  <div class="row justify-content-center mt-5">
    <div class="col-xl-4 col-md-6 col-sm-12">
      <div class="card">
        <div class="card-header">
          <h3 class="card-title header-title">ログイン</h3>
        </div>
        <form ref="form" @submit.prevent="onSubmit" :action="getAction()" method="post">
          <input type="hidden" name="authenticity_token" :value="csrfToken">
          <div class="card-body">
            <div class="form-group row">
              <label class="col-4">メールアドレス</label>
              <div class="col-8">
                <input type="text" v-validate="'required|email'" data-vv-as="メール" class="form-control" name="user[email]" placeholder="メールを入力してください" v-model="userData.email">
                <error-message :message="errors.first('user[email]')"></error-message>
              </div>
            </div>
            <div class="form-group row">
              <label class="col-4">パスワード</label>
              <div class="col-8">
                <input type="password" v-validate="'required'" data-vv-as="パースワード" class="form-control" name="user[password]" placeholder="パスワードを入力してください" v-model="userData.password">
                <error-message :message="errors.first('user[password]')"></error-message>
              </div>
            </div>
          </div>
          <div class="card-footer text-center">
            <button class="btn btn-success pl-5 pr-5" type="submit" :disabled="invalid">ログイン</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import Util from '@/core/util.js';

export default {
  data() {
    return {
      userRootUrl: process.env.MIX_ROOT_PATH,
      csrfToken: Util.getCsrfToken(),
      userData: {
        email: null,
        password: null
      }
    };
  },

  methods: {
    onSubmit() {
      this.$refs.form.submit();
    },
    getAction() {
      return `${this.userRootUrl}/user/sign_in`;
    }
  }
};
</script>

<style>

</style>