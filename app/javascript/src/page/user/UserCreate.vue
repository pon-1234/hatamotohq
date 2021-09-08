<template>
  <div class="mw-1200" >
    <div class="card">
      <div class="card-header d-flex align-items-center">
        <a :href="`${userRootUrl}/admin/users`" class="text-info">
          <i class="fa fa-arrow-left"></i> ユーザー一覧
        </a>
        <h5 class="m-auto font-weight-bold">新規ユーザー登録</h5>
      </div>
      <ValidationObserver ref="observer" v-slot="{ validate, invalid }">
        <div class="card-body">
          <div class="form-group row">
            <label class="col-12">メールアドレス<required-mark/></label>
            <div class="col-12">
              <ValidationProvider name="メールアドレス" rules="required" v-slot="{ errors }">
                <input type="text" class="form-control" name="user[email]" placeholder="入力してください" v-model="userFormData.email">
                <span class="error-explanation">{{ errors[0] }}</span>
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
            <label class="col-12">住所<required-mark/></label>
            <div class="col-12">
              <ValidationProvider name="住所" rules="required|max:255" v-slot="{ errors }">
                <input type="text" class="form-control" name="user[address]" placeholder="入力してください" v-model="userFormData.address">
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-12">電話番号<required-mark/></label>
            <div class="col-12">
              <ValidationProvider name="電話番号" rules="required|min:10|max:11" v-slot="{ errors }">
                <input type="number" class="form-control" name="user[phone_number]" placeholder="入力してください" v-model="userFormData.phone_number">
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-12">会社名</label>
            <div class="col-12">
              <ValidationProvider name="会社名" rules="max:255" v-slot="{ errors }">
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
          <button type="submit" class="btn btn-info fw-120" :disabled="invalid" @click="validate().then(onSubmit)">登録</button>
        </div>
      </ValidationObserver>
    </div>
  </div>
</template>
<script>
import { mapActions } from 'vuex';

export default {
  data() {
    return {
      userRootUrl: process.env.MIX_ROOT_PATH,
      submitted: false,
      userFormData: {
        email: null,
        password: null,
        password_confirmation: null,
        status: 'active',
        name: null,
        company_name: null,
        address: null,
        phone_number: null
      },
      enabled: true
    };
  },
  methods: {
    ...mapActions('user', ['createUser']),

    onSubmit(e) {
      this.submitted = true;
      this.createUser(this.userFormData).then((response) => {
        this.onReceiveCreateUserResponse(response.id, null);
      }).catch((error) => {
        this.onReceiveCreateUserResponse(null, error.responseJSON.message);
      });
    },
    onReceiveCreateUserResponse(id, errorMessage) {
      if (id) {
        window.toastr.success('ユーザー登録は完了しました。');
        setTimeout(() => {
          window.location.href = `${this.userRootUrl}/admin/users/${id}`;
        }, 750);
      } else {
        window.toastr.error(errorMessage);
      }
    },
    onActive() {
      this.enabled ? this.userFormData.status = 'active' : this.userFormData.status = 'blocked';
    }
  }
};
</script>
<style lang="scss" scoped>
</style>