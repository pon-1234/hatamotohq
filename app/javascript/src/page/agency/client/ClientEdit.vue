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

      <div class="d-flex">
        <div class="btn btn-info fw-120" :disabled="invalid" @click="validate().then(onSubmit)">保存</div>
      </div>
    </ValidationObserver>
  </div>
</template>
<script>
import { mapActions } from 'vuex';
import Util from '@/core/util';

export default {
  props: ['client'],

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
          email: null
        }
      }
    };
  },

  beforeMount() {
    Object.assign(this.clientFormData, this.client);
  },

  methods: {
    ...mapActions('client', ['updateClient']),

    onSubmit(e) {
      this.submitted = true;
      this.updateClient(this.clientFormData)
        .then(response => {
          this.onReceiveUpdateClientResponse(response.id, null);
        })
        .catch(error => {
          this.onReceiveUpdateClientResponse(null, error.responseJSON.message);
        });
    },
    onReceiveUpdateClientResponse(id, errorMessage) {
      if (id) {
        Util.showSuccessThenRedirect('クライアントの変更は完了しました。', `${this.rootPath}/agency/clients`);
      } else {
        window.toastr.error(errorMessage);
      }
    }
  }
};
</script>