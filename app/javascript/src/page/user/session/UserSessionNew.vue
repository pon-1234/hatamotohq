<template>
  <div>
    <div class="account-pages mt-5 mb-5">
      <div class="container">
        <div class="row justify-content-center">
          <div class="col-lg-5">
            <div class="card">
              <!-- START: Logo -->
              <div class="card-header pt-4 pb-4 text-center bg-success">
                <a href="#" class="text-white text-uppercase" style="font-size: 1.2rem">
                  <!-- <span><img src="assets/images/logo.png" alt="" height="18"></span> -->
                  <span>Hotel Insight CRM</span>
                </a>
              </div>
              <!-- END: Logo -->
              <!-- START: Form -->
              <div class="card-body p-4">
                <div class="text-center w-75 m-auto">
                  <h4 class="text-dark-50 text-center mt-0 font-weight-bold">ログイン</h4>
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
                      name="user[email]"
                      placeholder="メールを入力してください"
                      v-model="userData.email"
                    />
                    <error-message :message="errors.first('user[email]')"></error-message>
                  </div>

                  <div class="form-group">
                    <a :href="`${userRootUrl}/user/password/new`" class="text-muted float-right"
                      ><small>パスワードを忘れましたか?</small></a
                    >
                    <label for="password">パスワード</label>
                    <input-password name="user[password]" :password.sync="userData.password"></input-password>
                  </div>
                  <div class="form-group mb-3">
                    <div class="custom-control custom-checkbox">
                      <input
                        type="checkbox"
                        class="custom-control-input"
                        id="checkbox-signin"
                        name="user[remember_me]"
                        v-model="userData.remember_me"
                        true-value="true"
                        false-value="false"
                        checked
                      />
                      <label class="custom-control-label" for="checkbox-signin">ログインを記憶する</label>
                    </div>
                  </div>

                  <div class="form-group mb-0 text-center">
                    <button type="submit" class="btn btn-success" :disabled="invalid">ログイン</button>
                  </div>
                </form>
              </div>
              <!-- end card-body -->
            </div>
            <!-- end card -->
          </div>
          <!-- end col -->
        </div>
        <!-- end row -->
      </div>
      <!-- end container -->
    </div>
  </div>
</template>

<script>
import Util from '@/core/util.js';

export default {
  data() {
    return {
      userRootUrl: import.meta.env.VITE_ROOT_PATH,
      csrfToken: Util.getCsrfToken(),
      userData: {
        email: null,
        password: null,
        remember_me: false
      }
    };
  },

  computed: {
    invalid() {
      return this.errors.any();
    }
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

<style lang="scss" scoped>
  body.authentication-bg {
    background-image: url(/images/bg-pattern-light.svg);
    background-size: cover;
    background-position: center;
  }
</style>
