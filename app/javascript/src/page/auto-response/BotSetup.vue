<template>
  <div class="row">
    <div class="col-md-12">
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">LINE公式アカウント連携設定</h3>
        </div>
        <ValidationObserver v-slot="{ invalid }">
        <form ref="form" @submit.prevent="onSubmit" :action="getAction()" method="post">
          <input type="hidden" name="authenticity_token" :value="csrfToken">
          <div class="card-body offset-xl-2 col-xl-8">
            <div class="form-group row">
              <label class="col-4">管理用の名前（自由に記載してください)</label>
              <div class="col-8">
                <ValidationProvider name="管理用の名前" rules="required" v-slot="{ errors }">
                  <input type="text" class="form-control" name="bot[line_name]" v-model="botForm.line_name">
                  <span class="error-explanation">{{ errors[0] }}</span>
                </ValidationProvider>
              </div>
            </div>

            <div class="form-group row">
              <label class="col-4">LINE公式アカウントID</label>
              <div class="col-8">
                <ValidationProvider name="LINE公式アカウントID" rules="required" v-slot="{ errors }">
                  <input type="text" class="form-control" name="bot[line_user_id]" v-model="botForm.line_user_id">
                  <span class="error-explanation">{{ errors[0] }}</span>
                </ValidationProvider>
              </div>
            </div>

            <div class="form-group row">
              <label class="col-4">チャネルID</label>
              <div class="col-8">
                <ValidationProvider name="チャネルID" rules="required" v-slot="{ errors }">
                  <input type="text" class="form-control" name="bot[line_channel_id]" v-model="botForm.line_channel_id">
                  <span class="error-explanation">{{ errors[0] }}</span>
                </ValidationProvider>
              </div>
            </div>

            <div class="form-group row">
              <label class="col-4">チャネルシークレット</label>
              <div class="col-8">
                <ValidationProvider name="チャネルシークレット" rules="required" v-slot="{ errors }">
                  <input type="text" class="form-control" name="bot[line_channel_secret]" v-model="botForm.line_channel_secret">
                  <span class="error-explanation">{{ errors[0] }}</span>
                </ValidationProvider>
              </div>
            </div>
          </div>
          <div class="card-footer text-center">
            <submit-button object="ボット" action="設定" :submitted="submitted" :disabled="invalid"></submit-button>
          </div>
        </form>
        </ValidationObserver>
      </div>
    </div>
  </div>
</template>

<script>
import Util from '@/core/util.js';
import { Datetime } from 'vue-datetime';

export default {
  props: ['bot'],

  components: {
    Datetime
  },

  data() {
    return {
      userRootUrl: process.env.MIX_ROOT_PATH,
      csrfToken: Util.getCsrfToken(),
      botForm: {
        line_name: null,
        line_user_id: null,
        line_channel_id: null,
        line_channel_secret: null
      },
      submitted: false
    };
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

<style>

</style>