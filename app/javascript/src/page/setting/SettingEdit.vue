<template>
  <div class="mw-1200" >
    <div class="card">
      <div class="card-header d-flex align-items-center">
        <a :href="`${userRootUrl}/user/setting`" class="text-info">
          <i class="fa fa-arrow-left"></i>アカウント詳細
        </a>
        <h5 class="m-auto font-weight-bold">設定変更</h5>
      </div>
      <ValidationObserver ref="observer" v-slot="{ invalid, validate }">
        <form ref="form" @submit.prevent="validate().then(onSubmit)" :action="getAction()" method="post" enctype="multipart/form-data">
          <input type="hidden" name="authenticity_token" :value="csrfToken">
          <input type="hidden" name="_method" value="patch" />
          <input type="hidden" name="setting[id]" :value="settingFormData.id">
          <div class="card-body">
            <div class="card">
              <div class="form-group row">
                <label class="col-12">LINE公式アカウントID<required-mark/></label>
                <div class="col-12">
                  <ValidationProvider name="LINE公式アカウントID" rules="required" v-slot="{ errors }">
                    <input type="text" class="form-control" name="setting[line_user_id]" placeholder="input" v-model="settingFormData.line_user_id">
                    <span class="error-explanation">{{ errors[0] }}</span>
                  </ValidationProvider>
                </div>
              </div>
              <div class="form-group row">
                <label class="col-12">LINEアカウント名<required-mark/></label>
                <div class="col-12">
                  <ValidationProvider name="LINEアカウント名" rules="required" v-slot="{ errors }">
                    <input type="text" class="form-control" name="setting[line_name]" placeholder="input" v-model="settingFormData.line_name">
                    <span class="error-explanation">{{ errors[0] }}</span>
                  </ValidationProvider>
                </div>
              </div>
              <div class="form-group row">
                <label class="col-12">表示名<required-mark/></label>
                <div class="col-12">
                  <ValidationProvider name="表示名" rules="required" v-slot="{ errors }">
                    <input type="text" class="form-control" name="setting[display_name]" placeholder="input" v-model="settingFormData.display_name">
                    <span class="error-explanation">{{ errors[0] }}</span>
                  </ValidationProvider>
                </div>
              </div>
              <div class="form-group row">
                <label class="col-12">チャネルID</label>
                <div class="col-12">
                  <input type="text" class="form-control" placeholder="input" v-model="settingFormData.line_channel_id" disabled>
                </div>
              </div>
              <div class="form-group row">
                <label class="col-12">チャネルシークレット</label>
                <div class="col-12">
                  <input type="text" class="form-control" placeholder="input" v-model="settingFormData.line_channel_secret" disabled>
                </div>
              </div>
              <div class="form-group row">
                <label class="col-12">Webhook URL</label>
                <div class="col-12">
                  <input type="text" class="form-control" placeholder="input" :value="WebhookUrl()" disabled>
                </div>
              </div>
              <div class="form-group row">
                <label class="col-12">チャネルシークレット</label>
                <div class="col-12">
                  <input type="text" class="form-control" placeholder="input" v-model="settingFormData.liff_id" disabled>
                </div>
              </div>
            </div>
          </div>
          <div class="card-footer row-form-btn d-flex">
            <submit-button object="設定" action="保存" :submitted="submitted" :disabled="invalid"></submit-button>
          </div>
        </form>
      </ValidationObserver>
      <loading-indicator :loading="loading" />
    </div>
  </div>
</template>

<script>
import Util from '@/core/util.js';
import { ValidationObserver, ValidationProvider } from 'vee-validate';

export default {
  props: ['line_account'],
  components: { ValidationObserver, ValidationProvider },
  data() {
    return {
      userRootUrl: process.env.MIX_ROOT_PATH,
      csrfToken: Util.getCsrfToken(),
      loading: false,
      submitted: false,
      settingFormData: {
        id: null,
        line_user_id: null,
        line_name: null,
        display_name: null,
        line_channel_id: null,
        line_channel_secret: null,
        liff_id: null
      }
    };
  },

  created() {
    Object.assign(this.settingFormData, this.line_account);
  },

  methods: {
    async onSubmit(e) {
      this.submitted = true;
      this.$refs.form.submit();
    },
    getAction() {
      return `${this.userRootUrl}/user/setting`;
    },
    WebhookUrl() {
      return `${this.userRootUrl}/webhooks/${this.line_account.webhook_url}`;
    }
  }
};
</script>

<style lang="scss" scoped>

</style>