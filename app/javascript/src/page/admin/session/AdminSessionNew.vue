<template>
  <div>
    <div class="account-pages mt-5 mb-5">
      <div class="container">
        <div class="row justify-content-center mt-5">
          <div class="col-lg-5">
            <div class="card">
              <!-- START: Logo -->
              <div class="card-header pt-4 pb-4 text-center bg-info">
                <a href="#" class="text-white text-uppercase" style="font-size: 1.2rem">
                  <!-- <span><img src="assets/images/logo.png" alt="" height="18"></span> -->
                  <span>LINE CRM</span>
                </a>
              </div>
              <!-- END: Logo -->
              <!-- START: Form -->
              <div class="card-body p-4">
                <div class="text-center w-75 m-auto">
                  <h4 class="text-dark-50 text-center mt-0 font-weight-bold">管理者ログイン</h4>
                  <p class="text-muted mb-4">
                    管理パネルにアクセスするには、メールアドレスとパスワードを入力してください。
                  </p>
                </div>
                <form ref="form" @submit.prevent="onSubmit" :action="getAction()" method="post">
                  <input type="hidden" name="authenticity_token" :value="csrfToken" />
                  <div class="form-group">
                    <label for="emailaddress">メールアドレス</label>
                    <input
                      type="text"
                      v-validate="'required|email'"
                      data-vv-as="メール"
                      class="form-control"
                      name="admin[email]"
                      placeholder="メールを入力してください"
                      v-model="adminData.email"
                    />
                    <error-message :message="errors.first('admin[email]')"></error-message>
                  </div>
                  <div class="form-group">
                    <a :href="`${adminRootUrl}/admin/password/new`" class="text-muted float-right"><small>パスワードを忘れましたか?</small></a>
                    <label for="password">パスワード</label>
                    <!-- START: Input password component -->
                    <input-password name="admin[password]" :password.sync="adminData.password"></input-password>
                    <!-- END: Input password component -->
                  </div>
                  <div class="form-group mb-3">
                    <div class="custom-control custom-checkbox">
                      <input
                        type="checkbox"
                        name="admin[remember_me]"
                        class="custom-control-input"
                        id="checkbox-signin"
                        v-model="adminData.remember_me"
                        checked
                      />
                      <label class="custom-control-label" for="checkbox-signin">ログインを記憶する</label>
                    </div>
                  </div>
                  <div class="form-group mb-0 text-center">
                    <button class="btn btn-info" type="submit" :disabled="invalid">ログイン</button>
                  </div>
                </form>
              </div>
              <!-- End: Form -->
            </div>
          </div>
        </div>
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
        password: null,
        remember_me: false
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

<style lang="scss" scoped>
  body.authentication-bg {
    background-image: url(/images/bg-pattern-light.svg);
    background-size: cover;
    background-position: center;
  }
</style>