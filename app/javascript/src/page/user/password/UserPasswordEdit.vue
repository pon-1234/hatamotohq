<template>
  <div>
    <ValidationObserver ref="observer" v-slot="{ validate, invalid }">
      <form
        ref="form"
        @submit.prevent="validate().then(onSubmit)"
        :action="getAction()"
        method="post"
        enctype="multipart/form-data"
      >
        <input type="hidden" name="authenticity_token" :value="csrfToken" />
        <input type="hidden" name="_method" value="put" />
        <input type="hidden" name="user[reset_password_token]" :value="reset_password_token" />
        <div class="form-group mb-3">
          <label for="password">パスワード<required-mark /></label>
          <ValidationProvider name="パスワード" type="password" rules="required|min:8|max:128" vid="password" v-slot="{ errors }">
            <input
              type="text"
              class="form-control"
              name="user[password]"
              placeholder="入力してください"
              maxlength="129"
              v-model.trim="settingFormData.password"
            />
            <span class="error-explanation">{{ errors[0] }}</span>
          </ValidationProvider>
        </div>

        <div class="form-group mb-3">
          <label for="password_confirmation">パスワード（確認用）<required-mark /></label>
          <ValidationProvider name="パスワード（確認用）" type="password" rules="required|min:8|max:128|confirmed:password" v-slot="{ errors }">
            <input
              type="text"
              class="form-control"
              name="user[password_confirmation]"
              placeholder="入力してください"
              maxlength="129"
              v-model.trim="settingFormData.password_confirmation"
            />
            <span class="error-explanation">{{ errors[0] }}</span>
          </ValidationProvider>
        </div>
        <div class="form-group mb-0 text-center">
          <button
            type="submit"
            class="btn btn-success"
            :disabled="invalid"
          >
            再設定
          </button>
        </div>
      </form>

    </ValidationObserver>
  </div>
</template>

<script>
import Util from '@/core/util.js';
import { ValidationObserver, ValidationProvider } from 'vee-validate';

export default {
  props: ['reset_password_token'],
  components: { ValidationObserver, ValidationProvider },
  data() {
    return {
      userRootUrl: process.env.MIX_ROOT_PATH,
      csrfToken: Util.getCsrfToken(),
      settingFormData: {
        password: null,
        password_confirmation: null
      }
    };
  },

  methods: {
    async onSubmit(e) {
      this.$refs.form.submit();
    },
    getAction() {
      return `${this.userRootUrl}/user/password`;
    }
  }
};
</script>
