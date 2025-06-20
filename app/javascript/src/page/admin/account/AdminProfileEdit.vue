<template>
  <div>
    <div class="card">
      <div class="card-header"><h4>基本情報</h4></div>
      <ValidationObserver ref="observer" v-slot="{ validate, invalid }">
        <div class="card-body">
          <div class="form-group row">
            <label class="col-xl-3">メールアドレス<required-mark /></label>
            <div class="col-xl-9">
              <input
                type="text"
                class="form-control"
                name="account[email]"
                placeholder="入力してください"
                v-model.trim="accountFormData.email"
                disabled
              />
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">氏名<required-mark /></label>
            <div class="col-xl-9">
              <ValidationProvider name="氏名" rules="required|max:255" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="account[name]"
                  placeholder="入力してください"
                  maxlength="256"
                  v-model.trim="accountFormData.name"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
        </div>
        <div class="card-footer row-form-btn d-flex">
          <button type="submit" class="btn btn-info fw-120" :disabled="invalid" @click="validate().then(onSubmit)">
            変更
          </button>
        </div>
      </ValidationObserver>
    </div>

    <div class="card">
      <div class="card-header"><h4>パースワード変更</h4></div>
      <ValidationObserver ref="observer" v-slot="{ validate, invalid }">
        <div class="card-body">
          <div class="form-group row">
            <label class="col-xl-3">現在のパスワード<required-mark /></label>
            <div class="col-xl-9">
              <ValidationProvider name="現在のパスワード" rules="required|min:8|max:128" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="account[current_password]"
                  placeholder="入力してください"
                  maxlength="129"
                  v-model.trim="accountFormData.current_password"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">パスワード<required-mark /></label>
            <div class="col-xl-9">
              <ValidationProvider
                name="パスワード"
                rules="required|min:8|max:128"
                type="password"
                v-slot="{ errors }"
                vid="password"
              >
                <input
                  type="text"
                  class="form-control"
                  name="account[password]"
                  placeholder="入力してください"
                  maxlength="129"
                  v-model.trim="accountFormData.password"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">パスワード（確認用）<required-mark /></label>
            <div class="col-xl-9">
              <ValidationProvider
                name="パスワード（確認用）"
                rules="required|min:8|max:128|confirmed:password"
                type="password"
                v-slot="{ errors }"
              >
                <input
                  type="text"
                  class="form-control"
                  name="account[password_confirmation]"
                  placeholder="入力してください"
                  maxlength="129"
                  v-model.trim="accountFormData.password_confirmation"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
        </div>
        <div class="card-footer row-form-btn d-flex">
          <button
            type="submit"
            class="btn btn-info fw-120"
            :disabled="invalid"
            @click="validate().then(onUpdatePassword)"
          >
            変更
          </button>
        </div>
      </ValidationObserver>
    </div>
  </div>
</template>
<script>
import { mapActions } from 'vuex';
import Util from '@/core/util';

export default {
  props: ['account'],
  data() {
    return {
      rootUrl: import.meta.env.VITE_ROOT_PATH,
      submitted: false,
      accountFormData: {
        id: null,
        email: null,
        current_password: null,
        password: null,
        password_confirmation: null,
        name: null
      }
    };
  },
  created() {
    Object.assign(this.accountFormData, this.account);
    this.accountFormData.status === 'active' ? (this.enabled = true) : (this.enabled = false);
  },

  computed: {
    accountListUrl() {
      return `${this.rootUrl}/admin/accounts`;
    }
  },

  methods: {
    ...mapActions('account', ['updateAdminProfile']),

    onSubmit(e) {
      this.submitted = true;
      const formData = _.omit(this.accountFormData, ['email']);
      const response = this.updateAdminProfile(formData);
      if (response) {
        Util.showSuccessThenRedirect('管理者の変更は完了しました。', this.accountListUrl);
      } else {
        window.toastr.error('管理者の変更は失敗しました。');
      }
    },

    onUpdatePassword() {
      this.submitted = true;
      const formData = _.pick(this.accountFormData, ['id', 'current_password', 'password', 'password_confirmation']);
      this.updateAdminProfile(formData)
        .then(response => {
          Util.showSuccessThenRedirect('パースワードの変更は完了しました。', this.accountListUrl);
        })
        .catch(error => {
          this.loading = false;
          window.toastr.error(error.responseJSON.message);
        });
    }
  }
};
</script>