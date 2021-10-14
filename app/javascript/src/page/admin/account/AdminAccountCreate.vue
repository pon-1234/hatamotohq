<template>
  <div>
    <div class="card">
      <ValidationObserver ref="observer" v-slot="{ validate, invalid }">
        <div class="card-body">
          <div class="form-group row">
            <label class="col-xl-3">メールアドレス<required-mark/></label>
            <div class="col-xl-9">
              <ValidationProvider name="メールアドレス" rules="required|email" v-slot="{ errors }">
                <input type="text" class="form-control" name="account[email]" placeholder="入力してください" v-model="accountFormData.email">
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">氏名<required-mark/></label>
            <div class="col-xl-9">
              <ValidationProvider name="氏名" rules="required|max:255" v-slot="{ errors }">
                <input type="text" class="form-control" name="account[name]" placeholder="入力してください" v-model="accountFormData.name">
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">パスワード<required-mark/></label>
            <div class="col-xl-9">
              <ValidationProvider name="パスワード" rules="required|min:8|max:128" type="password" v-slot="{ errors }" vid="password">
                <input type="text" class="form-control" name="account[password]" placeholder="入力してください" v-model="accountFormData.password">
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">パスワード（確認用）<required-mark/></label>
            <div class="col-xl-9">
              <ValidationProvider name="パスワード（確認用）" rules="required|min:8|max:128|confirmed:password" type="password" v-slot="{ errors }">
                <input type="text" class="form-control" name="account[password_confirmation]" placeholder="入力してください" v-model="accountFormData.password_confirmation">
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">有効化</label>
            <div class="col-xl-9">
              <input type="checkbox" id="enabledCheck" checked data-switch="info" v-model="accountFormData.status" name="account[status]" true-value="active" false-value="blocked"/>
              <label for="enabledCheck" data-on-label="有" data-off-label="無"></label>
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
      rootUrl: process.env.MIX_ROOT_PATH,
      submitted: false,
      accountFormData: {
        email: null,
        password: null,
        password_confirmation: null,
        status: 'active',
        name: null
      }
    };
  },
  methods: {
    ...mapActions('account', ['createAccount']),

    onSubmit(e) {
      this.submitted = true;
      this.createAccount(this.accountFormData).then((response) => {
        this.onReceiveCreateAccountResponse(response.id, null);
      }).catch((error) => {
        this.onReceiveCreateAccountResponse(null, error.responseJSON.message);
      });
    },
    onReceiveCreateAccountResponse(id, errorMessage) {
      if (id) {
        window.toastr.success('ユーザー登録は完了しました。');
        setTimeout(() => {
          window.location.href = `${this.rootUrl}/admin/accounts/${id}`;
        }, 750);
      } else {
        window.toastr.error(errorMessage);
      }
    }
  }
};
</script>
<style lang="scss" scoped>
</style>