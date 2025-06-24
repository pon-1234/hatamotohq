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
                <!-- Display Server-side Error -->
                <div v-if="serverError" class="alert alert-danger">
                  {{ serverError }}
                </div>
                <form @submit.prevent="handleLogin">
                  <div class="form-group">
                    <label for="emailaddress">メールアドレス</label>
                    <input
                      type="email"
                      class="form-control"
                      v-model="email"
                      placeholder="メールを入力してください"
                      required
                    />
                  </div>

                  <div class="form-group">
                    <a :href="`${userRootUrl}/user/password/new`" class="text-muted float-right"
                      ><small>パスワードを忘れましたか?</small></a
                    >
                    <label for="password">パスワード</label>
                    <input
                      type="password"
                      class="form-control"
                      v-model="password"
                      placeholder="パスワードを入力してください"
                      required
                    />
                  </div>
                  <div class="form-group mb-3">
                    <div class="custom-control custom-checkbox">
                      <input
                        type="checkbox"
                        class="custom-control-input"
                        id="checkbox-signin"
                        v-model="rememberMe"
                      />
                      <label class="custom-control-label" for="checkbox-signin">ログインを記憶する</label>
                    </div>
                  </div>

                  <div class="form-group mb-0 text-center">
                    <button type="submit" class="btn btn-success">ログイン</button>
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
import axios from 'axios';

export default {
  data() {
    return {
      userRootUrl: import.meta.env.VITE_ROOT_PATH,
      serverError: null,
      csrfToken: null,
      email: '',
      password: '',
      rememberMe: false
    };
  },
  mounted() {
    // Get CSRF token
    this.csrfToken = Util.getCsrfToken();
    
    // Check for flash messages passed from the server
    const flashContainer = document.getElementById('flash-messages');
    if (flashContainer) {
      const alert = flashContainer.querySelector('.alert-danger');
      if (alert) {
        this.serverError = alert.innerText;
      }
    }
  },
  methods: {
    handleLogin() {
      const formData = {
        user: {
          email: this.email,
          password: this.password,
          remember_me: this.rememberMe ? '1' : '0'
        }
      };

      axios.post(`${this.userRootUrl}/user/sign_in`, formData, {
        headers: {
          'Accept': 'application/json',
          'X-CSRF-TOKEN': this.csrfToken
        }
      })
      .then(response => {
        if (response.data.success && response.data.redirect_to) {
          window.location.href = response.data.redirect_to;
        } else {
          // Handle cases where response is not as expected
          this.serverError = 'ログインに成功しましたが、リダイレクト先が不明です。';
        }
      })
      .catch(error => {
        if (error.response && error.response.data && error.response.data.error) {
          this.serverError = error.response.data.error;
        } else {
          this.serverError = 'ログイン中に不明なエラーが発生しました。';
        }
        console.error('Login failed:', error);
      });
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
  .text-danger {
    font-size: 0.875em;
    margin-top: 0.25rem;
  }
  .is-invalid {
    border-color: #fa5c7c; // Default Bootstrap danger color
  }
</style>