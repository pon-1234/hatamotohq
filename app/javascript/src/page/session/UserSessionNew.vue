<template>
  <div>
  <div class="account-pages mt-5 mb-5" hidden>
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-lg-5">
          <div class="card">
            <!-- Logo -->
            <div class="card-header pt-4 pb-4 text-center bg-success">
              <a href="index.html">
                <b>LINE INSIGHT</b>
              </a>
            </div>

            <div class="card-body p-4">
              <div class="text-center w-75 m-auto">
                <h4 class="text-dark-50 text-center mt-0 font-weight-bold">
                  ログイン
                </h4>
                <p class="text-muted mb-4">
                  管理パネルにアクセスするには、メールアドレスとパスワードを入力してください。
                </p>
              </div>

              <form action="#">
                <div class="form-group">
                  <label for="emailaddress">メールアドレス</label>
                  <input
                    class="form-control"
                    type="email"
                    id="emailaddress"
                    required=""
                    placeholder="メールを入力してください"
                  />
                </div>

                <div class="form-group">
                  <a href="pages-recoverpw.html" class="text-muted float-right"
                    ><small>パスワードを忘れましたか?</small></a
                  >
                  <label for="password">パスワード</label>
                  <div class="input-group input-group-merge">
                    <input
                      type="password"
                      id="password"
                      class="form-control"
                      placeholder="パスワードを入力してください"
                    />
                    <div class="input-group-append" data-password="false">
                      <div class="input-group-text">
                        <span class="password-eye"></span>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="form-group mb-3">
                  <div class="custom-control custom-checkbox">
                    <input
                      type="checkbox"
                      class="custom-control-input"
                      id="checkbox-signin"
                      checked
                    />
                    <label class="custom-control-label" for="checkbox-signin"
                      >ログインを記憶する</label
                    >
                  </div>
                </div>

                <div class="form-group mb-0 text-center">
                  <button class="btn btn-success" type="submit">ログイン</button>
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
  <div class="row justify-content-center mt-5">
    <div class="col-xl-4 col-md-6 col-sm-12">
      <div class="card card-success">
        <div class="card-header text-center">
          ユーザーログイン
        </div>
        <form
          ref="form"
          @submit.prevent="onSubmit"
          :action="getAction()"
          method="post"
        >
          <input type="hidden" name="authenticity_token" :value="csrfToken" />
          <div class="card-body pt-5 pb-5">
            <div class="form-group row">
              <label class="col-4">メールアドレス</label>
              <div class="col-8">
                <input
                  type="text"
                  v-validate="'required|email'"
                  data-vv-as="メール"
                  class="form-control"
                  name="user[email]"
                  placeholder="メールを入力してください"
                  v-model="userData.email"
                />
                <error-message
                  :message="errors.first('user[email]')"
                ></error-message>
              </div>
            </div>
            <div class="form-group row">
              <label class="col-4">パスワード</label>
              <div class="col-8">
                <input
                  type="password"
                  v-validate="'required'"
                  data-vv-as="パースワード"
                  class="form-control"
                  name="user[password]"
                  placeholder="パスワードを入力してください"
                  v-model="userData.password"
                />
                <error-message
                  :message="errors.first('user[password]')"
                ></error-message>
              </div>
            </div>
          </div>
          <div class="card-footer text-center">
            <button
              class="btn btn-success pl-5 pr-5"
              type="submit"
              :disabled="invalid"
            >
              ログイン
            </button>
          </div>
        </form>
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

<style></style>
