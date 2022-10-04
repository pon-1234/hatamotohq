<template>
  <div class="card card-success mxw-1200 mt-5 mx-auto">
    <div class="card-header">
      <h3 class="card-title">LINE公式アカウント連携設定</h3>
    </div>
    <ValidationObserver v-slot="{ validate, invalid }">
      <form ref="form" @submit.prevent="validate().then(onSubmit)" :action="getAction()" method="post">
        <input type="hidden" name="authenticity_token" :value="csrfToken" />
        <div class="card-body">
          <div class="form-group row">
            <label class="col-4">管理用の名前（自由に記載してください)<required-mark></required-mark></label>
            <div class="col-8">
              <ValidationProvider name="管理用の名前" rules="required|max:255" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  placeholder="入力してください"
                  name="bot[line_name]"
                  maxlength="256"
                  v-validate="'required|max:255'"
                  v-model.trim="botForm.line_name"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>

          <div class="form-group row mt-4">
            <label class="col-4">LINE公式アカウントID<required-mark></required-mark></label>
            <div class="col-8">
              <ValidationProvider name="LINE公式アカウントID" rules="required|max:255" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  placeholder="入力してください"
                  name="bot[line_user_id]"
                  maxlength="256"
                  v-validate="'required|max:255'"
                  v-model.trim="botForm.line_user_id"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>

          <div class="form-group row mt-4">
            <label class="col-4">LIFF ID</label>
            <div class="col-8">
              <ValidationProvider name="LIFF ID" rules="max:255" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  placeholder="入力してください"
                  name="bot[liff_id]"
                  maxlength="256"
                  v-validate="'max:255'"
                  v-model.trim="botForm.liff_id"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>

          <div class="form-group row mt-4">
            <label class="col-4">PMS APIキー</label>
            <div class="col-8">
              <ValidationProvider name=">PMS APIキー" rules="max:255" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  placeholder="入力してください"
                  name="bot[pms_api_key]"
                  maxlength="256"
                  v-validate="'max:255'"
                  v-model.trim="botForm.pms_api_key"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>

          <div class="form-group row mt-4">
            <label class="col-4">チャネルID<required-mark></required-mark></label>
            <div class="col-8">
              <ValidationProvider name="チャネルID" rules="required|max:255" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  placeholder="入力してください"
                  name="bot[channel_id]"
                  maxlength="256"
                  v-validate="'required|max:255'"
                  v-model.trim="botForm.channel_id"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>

          <div class="form-group row mt-4">
            <label class="col-4">チャネルシークレット<required-mark></required-mark></label>
            <div class="col-8">
              <ValidationProvider name="チャネルシークレット" rules="required|max:255" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  placeholder="入力してください"
                  name="bot[channel_secret]"
                  maxlength="256"
                  v-validate="'required|max:255'"
                  v-model.trim="botForm.channel_secret"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>

          <div class="form-group row mt-4">
            <label class="col-4">Webhook URL</label>
            <div class="col-8">
              <input-with-copy :text="webhookUrl"></input-with-copy>
            </div>
          </div>
        </div>
        <div class="card-footer text-center">
          <submit-button object="ボット" action="設定" :submitted="submitted" :disabled="invalid"></submit-button>
        </div>
      </form>
    </ValidationObserver>
  </div>
</template>

<script>
import Util from '@/core/util.js';

export default {
  props: ['webhook_url'],

  data() {
    return {
      userRootUrl: process.env.MIX_ROOT_PATH,
      csrfToken: Util.getCsrfToken(),
      botForm: {
        line_name: null,
        line_user_id: null,
        channel_id: null,
        channel_secret: null
      },
      submitted: false
    };
  },

  computed: {
    webhookUrl() {
      return `${this.userRootUrl}/webhooks/${this.webhook_url}`;
    }
  },

  methods: {
    async onSubmit(e) {
      this.submitted = true;
      this.$refs.form.submit();
    },
    getAction() {
      return `${this.userRootUrl}/user/bot/register`;
    }
  }
};
</script>