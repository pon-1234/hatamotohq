<template>
  <div>
    <div class="card">
      <div class="card-header"><h4>基本情報</h4></div>
      <ValidationObserver ref="observer" v-slot="{ validate, invalid }">
        <div class="card-body">
          <div class="form-group row">
            <label class="col-xl-3">メールアドレス<required-mark /></label>
            <div class="col-xl-9">
              <ValidationProvider name="メールアドレス" rules="required|email|max:255" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="user[email]"
                  placeholder="入力してください"
                  v-model.trim="userFormData.email"
                  maxlength="256"
                  disabled
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">氏名<required-mark /></label>
            <div class="col-xl-9">
              <ValidationProvider name="氏名" rules="required|max:255" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="user[name]"
                  placeholder="入力してください"
                  maxlength="256"
                  v-model.trim="userFormData.name"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">住所<required-mark /></label>
            <div class="col-xl-9">
              <ValidationProvider name="住所" rules="required|max:255" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="user[address]"
                  placeholder="入力してください"
                  maxlength="256"
                  v-model.trim="userFormData.address"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">電話番号<required-mark /></label>
            <div class="col-xl-9">
              <ValidationProvider name="電話番号" rules="required|numeric|min:10|max:11" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="user[phone_number]"
                  placeholder="入力してください"
                  maxlength="12"
                  v-model.trim="userFormData.phone_number"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">会社名</label>
            <div class="col-xl-9">
              <ValidationProvider name="会社名" rules="max:255" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="user[company_name]"
                  placeholder="入力してください"
                  maxlength="256"
                  v-model.trim="userFormData.company_name"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">有効 / 無効</label>
            <div class="col-xl-9">
              <input
                type="checkbox"
                id="enabledCheck"
                checked
                data-switch="info"
                v-model="userFormData.status"
                name="user[status]"
                true-value="active"
                false-value="blocked"
              />
              <label for="enabledCheck" data-on-label="有" data-off-label="無"></label>
            </div>
          </div>
        </div>
        <div class="card-footer row-form-btn d-flex">
          <div class="btn btn-info fw-120" :disabled="invalid" @click="validate().then(onSubmit)">変更</div>
        </div>
      </ValidationObserver>
    </div>

    <div class="card">
      <div class="card-header"><h4>パースワード変更</h4></div>
      <ValidationObserver ref="observer" v-slot="{ validate, invalid }">
        <div class="card-body">
          <div class="form-group row">
            <label class="col-xl-3">パスワード<required-mark /></label>
            <div class="col-xl-9">
              <ValidationProvider name="パスワード" rules="required|min:8|max:128" v-slot="{ errors }" vid="password">
                <input
                  type="text"
                  class="form-control"
                  name="user[password]"
                  placeholder="入力してください"
                  maxlength="256"
                  v-model.trim="userFormData.password"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">パスワード（確認用）<required-mark /></label>
            <div class="col-xl-9">
              <ValidationProvider name="パスワード（確認用）" rules="required|confirmed:password" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="user[password_confirmation]"
                  placeholder="入力してください"
                  maxlength="256"
                  v-model.trim="userFormData.password_confirmation"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
        </div>
        <div class="card-footer row-form-btn d-flex">
          <div class="btn btn-info fw-120" :disabled="invalid" @click="validate().then(onUpdatePassword)">変更</div>
        </div>
      </ValidationObserver>
    </div>
  </div>
</template>
<script>
import { mapActions } from 'vuex';

export default {
  props: ['user'],
  data() {
    return {
      userRootUrl: import.meta.env.VITE_ROOT_PATH,
      submitted: false,
      userFormData: {
        id: null,
        email: null,
        password: null,
        password_confirmation: null,
        name: null,
        status: 'active',
        company_name: null,
        address: null,
        phone_number: null
      }
    };
  },
  created() {
    Object.assign(this.userFormData, this.user);
    this.userFormData.status === 'active' ? (this.enabled = true) : (this.enabled = false);
  },
  methods: {
    ...mapActions('user', ['updateUser']),

    onSubmit(e) {
      this.submitted = true;
      const formData = _.omit(this.userFormData, ['email']);
      this.updateUser(formData)
        .then(response => {
          window.toastr.success('ユーザー情報の変更は完了しました。');
          this.backToList();
        })
        .catch(_ => {
          window.toastr.error('エラーを発生しました。');
        });
    },
    onUpdatePassword() {
      this.submitted = true;
      const formData = _.pick(this.userFormData, ['id', 'password', 'password_confirmation']);
      this.updateUser(formData)
        .then(response => {
          window.toastr.success('パースワードの変更は完了しました。');
          this.backToList();
        })
        .catch(_ => {
          window.toastr.error('エラーを発生しました。');
        });
    },
    backToList() {
      setTimeout(() => {
        window.location.href = `${this.userRootUrl}/admin/users`;
      }, 750);
    }
  }
};
</script>