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
                <Form :action="getAction()" method="post" @submit="onFormSubmit" v-slot="{ meta, errors: formErrors }">
                  <form ref="actualNativeForm" @submit.prevent :action="getAction()" method="post">
                    <input type="hidden" name="authenticity_token" :value="csrfToken" />
                    <div class="form-group">
                      <label for="emailaddress">メールアドレス</label>
                      <Field
                        name="user[email]"
                        label="メールアドレス"
                        rules="required|custom_email"
                        v-slot="{ field, errors: fieldSpecificErrors, meta: fieldMeta }"
                      >
                        <input
                          v-bind="field"
                          type="email"
                          class="form-control"
                          placeholder="メールを入力してください"
                          :class="{ 'is-invalid': fieldMeta.touched && fieldSpecificErrors.length }"
                        />
                      </Field>
                      <span v-if="formErrors['user[email]']" class="text-danger">{{ formErrors['user[email]'] }}</span>
                    </div>

                    <div class="form-group">
                      <a :href="`${userRootUrl}/user/password/new`" class="text-muted float-right"
                        ><small>パスワードを忘れましたか?</small></a
                      >
                      <label for="password">パスワード</label>
                      <Field
                        name="user[password]"
                        label="パスワード"
                        rules="required"
                        v-slot="{ field, errors: fieldSpecificErrors, meta: fieldMeta }"
                      >
                        <input
                          v-bind="field"
                          type="password"
                          class="form-control"
                          placeholder="パスワードを入力してください"
                          :class="{ 'is-invalid': fieldMeta.touched && fieldSpecificErrors.length }"
                        />
                      </Field>
                      <span v-if="formErrors['user[password]']" class="text-danger">{{ formErrors['user[password]'] }}</span>
                    </div>
                    <div class="form-group mb-3">
                      <div class="custom-control custom-checkbox">
                        <Field
                          name="user[remember_me]"
                          type="checkbox"
                          class="custom-control-input"
                          id="checkbox-signin"
                          :value="true"
                          :unchecked-value="false"
                        />
                        <label class="custom-control-label" for="checkbox-signin">ログインを記憶する</label>
                      </div>
                    </div>

                    <div class="form-group mb-0 text-center">
                      <button type="submit" class="btn btn-success" :disabled="!meta.valid || meta.pending">ログイン</button>
                    </div>
                  </form>
                </Form>
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
import { Form, Field, ErrorMessage } from 'vee-validate';
import PasswordInput from '../../../components/form/inputs/PasswordInput.vue';

export default {
  components: {
    Form,
    Field,
    ErrorMessage,
    PasswordInput
  },
  data() {
    return {
      userRootUrl: import.meta.env.VITE_ROOT_PATH,
      csrfToken: Util.getCsrfToken()
    };
  },

  methods: {
    onFormSubmit() {
      // This method is called by VeeValidate's Form @submit event after successful validation
      // Now, we can submit the actual native form
      this.$refs.actualNativeForm.submit();
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
  .text-danger {
    font-size: 0.875em;
    margin-top: 0.25rem;
  }
  .is-invalid {
    border-color: #fa5c7c; // Default Bootstrap danger color
  }
</style>
