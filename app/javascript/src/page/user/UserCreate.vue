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
        <div class="card-body">
          <div class="form-group row">
            <label class="col-12">メールアドレス<required-mark/></label>
            <div class="col-12">
              <ValidationProvider name="メールアドレス" rules="required" v-slot="{ errors }">
                <input type="text" class="form-control" name="user[email]" placeholder="入力してください" v-model="userFormData.email">
                <span class="error-explanation" v-if="!isEmailUnique"> メールアドレスは既存しています。 </span>
                <span class="error-explanation" v-else>{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-12">氏名<required-mark/></label>
            <div class="col-12">
              <ValidationProvider name="氏名" rules="required|max:255" v-slot="{ errors }">
                <input type="text" class="form-control" name="user[name]" placeholder="入力してください" v-model="userFormData.name">
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-12">address<required-mark/></label>
            <div class="col-12">
              <ValidationProvider name="address" rules="required|max:255" v-slot="{ errors }">
                <input type="text" class="form-control" name="user[address]" placeholder="入力してください" v-model="userFormData.address">
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-12">phone_number<required-mark/></label>
            <div class="col-12">
              <ValidationProvider name="phone_number" rules="required|min:10|max:11" v-slot="{ errors }">
                <input type="number" class="form-control" name="user[phone_number]" placeholder="入力してください" v-model="userFormData.phone_number">
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-12">company_name</label>
            <div class="col-12">
              <ValidationProvider name="company_name" rules="max:255" v-slot="{ errors }">
                <input type="text" class="form-control" name="user[company_name]" placeholder="入力してください" v-model="userFormData.company_name">
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
                <input type="text" class="form-control" name="user[password_confirmation]" placeholder="入力してください" v-model="userFormData.password_confirmation">
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
          <button type="submit" class="btn btn-info mr-2" :disabled="invalid" @click="validate().then(onSubmit)">create</button>
        </div>
      </ValidationObserver>
    </div>
  </div>
</template>
<script>
import { mapActions } from 'vuex';
import { ValidationObserver, ValidationProvider } from 'vee-validate';

export default {
  components: { ValidationObserver, ValidationProvider },
  data() {
    return {
      userRootUrl: process.env.MIX_ROOT_PATH,
      submitted: false,
      userFormData: {
        email: null,
        password: null,
        password_confirmation: null,
        status: 'actived',
        name: null,
        company_name: null,
        address: null,
        phone_number: null
      },
      isEmailUnique: true,
      enabled: true
    };
  },
  methods: {
    ...mapActions('user', ['createUser']),

    async onSubmit(e) {
      this.submitted = true;
      const res = await this.createUser(this.userFormData);
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