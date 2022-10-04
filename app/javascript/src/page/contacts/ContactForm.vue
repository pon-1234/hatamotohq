<template>
  <ValidationObserver ref="observer" v-slot="{ validate }">
    <form
      ref="form"
      @submit.prevent="validate().then(onSubmit)"
      :action="formAction"
      method="post"
      enctype="multipart/form-data"
    >
      <input type="hidden" name="authenticity_token" :value="csrfToken" />
      <input type="hidden" name="contact[friend_line_id]" :value="friendLineId" />
      <div class="card">
        <div class="card-header border-bottom border-success"><h4>お問い合わせフォーム</h4></div>
        <div class="card-body">
          <div class="form-group row">
            <label class="col-lg-4">電話番号<required-mark /></label>
            <div class="col-lg-8">
              <ValidationProvider name="電話番号" rules="required|length:11" v-slot="{ errors }">
                <input
                  class="form-control"
                  type="text"
                  placeholder="電話番号を入力してください"
                  name="contact[phone_number]"
                  v-model="contactFormData.phoneNumber"
                />
                <error-message :message="errors[0]"></error-message>
              </ValidationProvider>
            </div>
          </div>
        </div>
        <div class="card-footer border-top border-success text-center py-3">
          <button type="submit" class="btn btn-success fw-120">送信</button>
        </div>
        <loading-indicator :loading="loading"></loading-indicator>
      </div>
    </form>
  </ValidationObserver>
</template>

<script>
import Util from '@/core/util.js';

export default {
  props: {
    friendLineId: {
      type: String
    }
  },

  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH,
      csrfToken: Util.getCsrfToken(),
      loading: true,
      contactFormData: {
        phoneNumber: null
      }
    };
  },

  async beforeMount() {
    this.loading = false;
  },

  computed: {
    formAction() {
      return `${this.rootPath}/contacts`;
    }
  },

  methods: {
    async onSubmit(e) {
      this.$refs.form.submit();
    }
  }
};
</script>
