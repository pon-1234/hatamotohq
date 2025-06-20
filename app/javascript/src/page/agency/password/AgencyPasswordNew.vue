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
        <div class="form-group mb-3">
          <label for="emailaddress">メールアドレス<required-mark /></label>
          <ValidationProvider name="メールアドレス" rules="required|email|max:255" v-slot="{ errors }">
            <input
              type="text"
              class="form-control"
              name="agency[email]"
              placeholder="入力してください"
              maxlength="256"
              v-model.trim="settingFormData.email"
              @keyup="server_errors = []"
            />
            <span class="error-explanation">{{ errors[0] || server_errors[0] }}</span>
          </ValidationProvider>
        </div>
        <div class="form-group mb-0 text-center">
          <button
            type="submit"
            class="btn btn-primary"
            :disabled="invalid"
          >
            メールを送信
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
  props: ['from_server_errors', 'previous_email'],
  components: { ValidationObserver, ValidationProvider },
  data() {
    return {
      userRootUrl: import.meta.env.VITE_ROOT_PATH,
      csrfToken: Util.getCsrfToken(),
      settingFormData: {
        email: this.previous_email
      },
      server_errors: this.from_server_errors
    };
  },

  methods: {
    async onSubmit(e) {
      this.$refs.form.submit();
    },
    getAction() {
      return `${this.userRootUrl}/agency/password`;
    }
  }
};
</script>
