<template>
  <div>
    <ValidationObserver ref="observer" v-slot="{ validate, invalid }">
      <div class="card">
        <div class="card-header left-border">
          <h3 class="card-title">クライアント情報</h3>
        </div>
        <div class="card-body">
          <div class="form-group row">
            <label class="col-xl-3">クライアント名<required-mark /></label>
            <div class="col-xl-9">
              <ValidationProvider name="クライアント名" rules="required|max:255" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="client[name]"
                  placeholder="入力してください"
                  maxlength="256"
                  v-model.trim="clientFormData.name"
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
                  name="client[address]"
                  placeholder="入力してください"
                  maxlength="256"
                  v-model.trim="clientFormData.address"
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
                  name="client[phone_number]"
                  placeholder="入力してください"
                  maxlength="12"
                  v-model.trim="clientFormData.phone_number"
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
                data-switch="info"
                v-model="clientFormData.status"
                name="client[status]"
                true-value="active"
                false-value="blocked"
              />
              <label for="enabledCheck" data-on-label="有" data-off-label="無"></label>
            </div>
          </div>
        </div>
      </div>

      <!-- 管理者情報 -->
      <div class="card">
        <div class="card-header left-border">
          <h3 class="card-title">管理者情報</h3>
        </div>
        <div class="card-body">
          <div class="form-group row">
            <label class="col-xl-3">メールアドレス<required-mark /></label>
            <div class="col-xl-9">
              <ValidationProvider name="メールアドレス" rules="required|email|max:255" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="client[admin][email]"
                  placeholder="入力してください"
                  v-model.trim="clientFormData.admin.email"
                  maxlength="256"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">管理者名<required-mark /></label>
            <div class="col-xl-9">
              <ValidationProvider name="管理者名" rules="required|max:255" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="client[admin][name]"
                  placeholder="入力してください"
                  maxlength="256"
                  v-model.trim="clientFormData.admin.name"
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
                  name="client[admin][password]"
                  placeholder="入力してください"
                  maxlength="256"
                  v-model.trim="clientFormData.admin.password"
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
                  name="client[admin][password_confirmation]"
                  placeholder="入力してください"
                  maxlength="256"
                  v-model.trim="clientFormData.admin.password_confirmation"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
        </div>
      </div>

      <div class="d-flex">
        <div class="btn btn-info fw-120" :disabled="invalid" @click="validate().then(onSubmit)">登録</div>
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
      rootPath: import.meta.env.VITE_ROOT_PATH,
      submitted: false,
      clientFormData: {
        status: 'active',
        name: null,
        address: null,
        phone_number: null,
        admin: {
          name: null,
          email: null,
          password: null,
          password_confirmation: null
        }
      }
    };
  },
  methods: {
    ...mapActions('client', ['createClient']),

    onSubmit(e) {
      this.submitted = true;
      this.createClient(this.clientFormData)
        .then(response => {
          this.onReceiveCreateClientResponse(response.id, null);
        })
        .catch(error => {
          this.onReceiveCreateClientResponse(null, error.responseJSON.message);
        });
    },
    onReceiveCreateClientResponse(id, errorMessage) {
      if (id) {
        Util.showSuccessThenRedirect('クライアントの登録は完了しました。', `${this.rootPath}/agency/clients`);
      } else {
        window.toastr.error(errorMessage);
      }
    }
  }
};
</script>