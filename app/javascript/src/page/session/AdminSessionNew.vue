<template>
  <div class="row justify-content-center mt-5">
    <div class="col-xl-4 col-md-6 col-sm-12">
      <div class="card card-info">
        <div class="card-header text-center">
          管理者ログイン
        </div>
        <form ref="form" @submit.prevent="onSubmit" :action="getAction()" method="post">
          <input type="hidden" name="authenticity_token" :value="csrfToken">
          <div class="card-body pt-5 pb-5">
            <div class="form-group row">
              <label class="col-4">メールアドレス</label>
              <div class="col-8">
                <input type="text" v-validate="'required|email'" data-vv-as="メール" class="form-control" name="admin[email]" placeholder="メールを入力してください" v-model="adminData.email">
                <error-message :message="errors.first('admin[email]')"></error-message>
              </div>
            </div>
            <div class="form-group row">
              <label class="col-4">パスワード</label>
              <div class="col-8">
                <input type="password" v-validate="'required'" data-vv-as="パースワード" class="form-control" name="admin[password]" placeholder="パスワードを入力してください" v-model="adminData.password">
                <error-message :message="errors.first('admin[password]')"></error-message>
              </div>
            </div>
          </div>
          <div class="card-footer text-center">
            <button class="btn btn-info pl-5 pr-5" type="submit" :disabled="invalid">ログイン</button>
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
      adminRootUrl: process.env.MIX_ROOT_PATH,
      csrfToken: Util.getCsrfToken(),
      adminData: {
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
      return `${this.adminRootUrl}/admin/sign_in`;
    }
  }
};
</script>

<style>

</style>