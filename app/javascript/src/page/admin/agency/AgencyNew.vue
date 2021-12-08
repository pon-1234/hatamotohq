<template>
  <div>
    <div class="card">
      <ValidationObserver ref="observer" v-slot="{ validate, invalid }">
        <div class="card-body">
          <div class="form-group row">
            <label class="col-xl-3">メールアドレス<required-mark /></label>
            <div class="col-xl-9">
              <ValidationProvider name="メールアドレス" rules="required|email|max:255" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="agency[email]"
                  placeholder="入力してください"
                  v-model.trim="agencyFormData.email"
                  maxlength="256"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">契約者名<required-mark /></label>
            <div class="col-xl-9">
              <ValidationProvider name="契約者名" rules="required|max:255" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="agency[name]"
                  placeholder="入力してください"
                  maxlength="256"
                  v-model.trim="agencyFormData.name"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">住所</label>
            <div class="col-xl-9">
              <ValidationProvider name="住所" rules="max:255" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="agency[address]"
                  placeholder="入力してください"
                  maxlength="256"
                  v-model.trim="agencyFormData.address"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">電話番号</label>
            <div class="col-xl-9">
              <ValidationProvider name="電話番号" rules="numeric|min:10|max:11" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="agency[phone_number]"
                  placeholder="入力してください"
                  maxlength="12"
                  v-model.trim="agencyFormData.phone_number"
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
                  name="agency[password]"
                  placeholder="入力してください"
                  maxlength="256"
                  v-model.trim="agencyFormData.password"
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
                  name="agency[password_confirmation]"
                  placeholder="入力してください"
                  maxlength="256"
                  v-model.trim="agencyFormData.password_confirmation"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
        </div>
        <div class="card-footer row-form-btn d-flex">
          <div class="btn btn-info fw-120" :disabled="invalid" @click="validate().then(onSubmit)">登録</div>
        </div>
      </ValidationObserver>
    </div>
  </div>
</template>
<script>
import { mapActions } from 'vuex';
import Util from '@/core/util';

export default {
  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH,
      submitted: false,
      agencyFormData: {
        email: null,
        password: null,
        password_confirmation: null,
        name: null,
        company_name: null,
        address: null,
        phone_number: null
      }
    };
  },
  methods: {
    ...mapActions('agency', ['createAgency']),

    onSubmit(e) {
      this.submitted = true;
      this.createAgency(this.agencyFormData)
        .then(_ => {
          Util.showSuccessThenRedirect('契約者の登録は完了しました。', `${this.rootPath}/admin/agencies`);
        })
        .catch(error => {
          window.toastr.error(error.responseJSON.message);
        });
    }
  }
};
</script>