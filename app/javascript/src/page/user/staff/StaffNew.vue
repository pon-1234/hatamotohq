<template>
  <div>
    <ValidationObserver ref="observer" v-slot="{ validate, invalid }">
      <div class="card">
        <div class="card-body">
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
                  v-model.trim="staffFormData.name"
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
                  v-model.trim="staffFormData.address"
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
                  v-model.trim="staffFormData.phone_number"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">メールアドレス<required-mark /></label>
            <div class="col-xl-9">
              <ValidationProvider name="メールアドレス" rules="required|email|max:255" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="user[email]"
                  placeholder="入力してください"
                  v-model.trim="staffFormData.email"
                  maxlength="256"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
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
                  v-model.trim="staffFormData.password"
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
                  v-model.trim="staffFormData.password_confirmation"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">有効化</label>
            <div class="col-xl-9">
              <input
                type="checkbox"
                id="enabledCheck"
                checked
                data-switch="success"
                v-model="staffFormData.status"
                name="user[status]"
                true-value="active"
                false-value="blocked"
              />
              <label for="enabledCheck" data-on-label="有" data-off-label="無"></label>
            </div>
          </div>
        </div>
        <div class="card-footer row-form-btn d-flex">
          <div class="btn btn-success fw-120" :disabled="invalid" @click="validate().then(onSubmit)">登録</div>
        </div>
        <loading-indicator :loading="loading"></loading-indicator>
      </div>
    </ValidationObserver>
  </div>
</template>
<script>
import { mapActions } from 'vuex';
import Util from '@/core/util';

export default {
  data() {
    return {
      userRootUrl: process.env.MIX_ROOT_PATH,
      loading: false,
      staffFormData: {
        email: null,
        password: null,
        password_confirmation: null,
        status: 'active',
        name: null,
        address: null,
        phone_number: null
      }
    };
  },
  methods: {
    ...mapActions('staff', ['createStaff']),

    onSubmit(e) {
      if (this.loading) return;
      this.loading = true;
      this.createStaff(this.staffFormData)
        .then(response => {
          Util.showSuccessThenRedirect('スタッフの登録は完了しました。', `${this.userRootUrl}/user/staffs`);
        })
        .catch(error => {
          this.loading = false;
          window.toastr.error(error.responseJSON.message);
        });
    }
  }
};
</script>