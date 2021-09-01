<template>
  <div class="mw-1200" >
    <div class="card">
      <div class="card-header d-flex align-items-center">
        <a :href="`${userRootUrl}/admin/users`" class="text-info">
          <i class="fa fa-arrow-left"></i> Back to list
        </a>
        <h5 class="m-auto font-weight-bold">Create user</h5>
      </div>
      <ValidationObserver ref="observer" v-slot="{ validate }">
        <form ref="form" @submit.prevent="validate().then(onSubmit)" :action="getAction()" method="post" enctype="multipart/form-data">
          <input type="hidden" name="authenticity_token" :value="csrfToken">
          <div class="card-body">
            <div class="form-group row">
              <label class="col-12">email<required-mark/></label>
              <div class="col-12">
                <ValidationProvider name="email" rules="required" v-slot="{ errors }">
                  <input type="text" class="form-control" name="user[email]" placeholder="入力してください" v-model="userFormData.email">
                  <span class="error-explanation">{{ errors[0] }}</span>
                </ValidationProvider>
              </div>
            </div>
            <div class="form-group row">
              <label class="col-12">name<required-mark/></label>
              <div class="col-12">
                <ValidationProvider name="name" rules="required" v-slot="{ errors }">
                  <input type="text" class="form-control" name="user[name]" placeholder="入力してください" v-model="userFormData.name">
                  <span class="error-explanation">{{ errors[0] }}</span>
                </ValidationProvider>
              </div>
            </div>
            <div class="form-group row">
              <label class="col-12">password<required-mark/></label>
              <div class="col-12">
                <ValidationProvider name="password" rules="required|min:8|max:128" type="password" v-slot="{ errors }" vid="password">
                  <input type="text" class="form-control" name="user[password]" placeholder="入力してください" v-model="userFormData.password">
                  <span class="error-explanation">{{ errors[0] }}</span>
                </ValidationProvider>
              </div>
            </div>
            <div class="form-group row">
              <label class="col-12">email<required-mark/></label>
              <div class="col-12">
                <ValidationProvider name="password_confirmation" rules="required|min:8|max:128|confirmed:password" type="password" v-slot="{ errors }">
                  <input type="text" class="form-control" name="user[password_confirmation]" placeholder="入力してください" v-model="userFormData.passwordConfirmation">
                  <span class="error-explanation">{{ errors[0] }}</span>
                </ValidationProvider>
              </div>
            </div>
          </div>
          <div class="card-footer row-form-btn d-flex">
            <submit-button object="btn" action="保存" :submitted="submitted"></submit-button>
          </div>
        </form>
      </ValidationObserver>
    </div>
  </div>
</template>
<script>
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
        name: null
      }
    };
  },
  methods: {
    async onSubmit(e) {
      this.submitted = true;
      this.$refs.form.submit();
    },
    getAction() {
      return `${this.userRootUrl}/admin/users`;
    }
  }
};
</script>
<style lang="scss" scoped>
</style>