<template>
  <div class="mw-1200" >
    <div class="card">
      <div class="card-header d-flex align-items-center">
        <a :href="`${userRootUrl}/admin/users`" class="text-info">
          <i class="fa fa-arrow-left"></i> Back to list
        </a>
        <h5 class="m-auto font-weight-bold">Create user</h5>
      </div>
      <ValidationObserver ref="observer" v-slot="{ validate, invalid }">
        <form ref="form" @submit.prevent="validate().then(onSubmit)" :action="getAction()" method="post" enctype="multipart/form-data">
          <input type="hidden" name="authenticity_token" :value="csrfToken">
          <div class="card-body">
            <div class="form-group row">
              <label class="col-12">メールアドレス<required-mark/></label>
              <div class="col-12">
                <ValidationProvider name="メールアドレス" rules="required" v-slot="{ errors }">
                  <input type="text" class="form-control" name="user[email]" placeholder="入力してください" v-model="userFormData.email" @change="getValidateUnique()">
                  <span class="error-explanation" v-if="!isEmailUnique"> メールアドレスは既存しています。 </span>
                  <span class="error-explanation" v-else>{{ errors[0] }}</span>
                </ValidationProvider>
              </div>
            </div>
            <div class="form-group row">
              <label class="col-12">氏名<required-mark/></label>
              <div class="col-12">
                <ValidationProvider name="氏名" rules="required" v-slot="{ errors }">
                  <input type="text" class="form-control" name="user[name]" placeholder="入力してください" v-model="userFormData.name">
                  <span class="error-explanation">{{ errors[0] }}</span>
                </ValidationProvider>
              </div>
            </div>
            <div class="form-group row">
              <label class="col-12">パスワード<required-mark/></label>
              <div class="col-12">
                <ValidationProvider name="パスワード" rules="required|min:8|max:128" type="password" v-slot="{ errors }" vid="password">
                  <input type="text" class="form-control" name="user[password]" placeholder="入力してください" v-model="userFormData.password">
                  <span class="error-explanation">{{ errors[0] }}</span>
                </ValidationProvider>
              </div>
            </div>
            <div class="form-group row">
              <label class="col-12">パスワード（確認用）<required-mark/></label>
              <div class="col-12">
                <ValidationProvider name="パスワード（確認用）" rules="required|min:8|max:128|confirmed:password" type="password" v-slot="{ errors }">
                  <input type="text" class="form-control" name="user[password_confirmation]" placeholder="入力してください" v-model="userFormData.passwordConfirmation">
                  <span class="error-explanation">{{ errors[0] }}</span>
                </ValidationProvider>
              </div>
            </div>
            <div class="form-group row">
              <label class="col-12">有効 / 無効</label>
              <div class="col-12">
                <div class="btn-toggle">
                  <label class="switch" for="enabledCheck">
                    <input type="checkbox" id="enabledCheck" v-model="enabled" name="user[status]" @change="onActive">
                    <span class="slider round"></span>
                  </label>
                  <input type="hidden" name="user[status]" v-model="userFormData.status">
                </div>
              </div>
            </div>
          </div>
          <div class="card-footer row-form-btn d-flex">
            <button type="submit" class="btn btn-info mr-2" :disabled="!isEmailUnique || invalid">create</button>
          </div>
        </form>
      </ValidationObserver>
    </div>
  </div>
</template>
<script>
import { mapActions } from 'vuex';
import Util from '@/core/util.js';
import { ValidationObserver, ValidationProvider } from 'vee-validate';

export default {
  components: { ValidationObserver, ValidationProvider },
  data() {
    return {
      userRootUrl: process.env.MIX_ROOT_PATH,
      csrfToken: Util.getCsrfToken(),
      submitted: false,
      userFormData: {
        email: null,
        password: null,
        passwordConfirmation: null,
        status: 'actived',
        name: null
      },
      isEmailUnique: true,
      enabled: true
    };
  },
  methods: {
    ...mapActions('user', ['validateUnique']),

    async onSubmit(e) {
      if (!this.isEmailUnique) {
        return;
      }
      this.submitted = true;
      this.$refs.form.submit();
    },
    getAction() {
      return `${this.userRootUrl}/admin/users`;
    },
    async getValidateUnique() {
      const data = { email: this.userFormData.email, user_id: this.userFormData.id };
      const res = await this.validateUnique(data);
      this.isEmailUnique = !!res && res.unique;
    },
    onActive() {
      this.enabled ? this.userFormData.status = 'actived' : this.userFormData.status = 'blocked';
    }
  }
};
</script>
<style lang="scss" scoped>
</style>