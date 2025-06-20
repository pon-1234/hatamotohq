<template>
  <div v-if="isLoading">ローディング...</div>
  <div v-else>
    <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
      <h3 class="hdg3">アカウント情報</h3>
    </div>
    <div class="form-common01 create-content">
      <div class="panel panel-linebot01">
        <div class="panel-body">
          <dl class="flex group-admin01 group-linebot01">
            <dt>
              <span class="ja">LINEアカウント名<required-mark /></span><span class="en">Account name</span>
            </dt>
            <dd>
              <input
                type="text"
                class="form-control"
                placeholder="LINEアカウント名を入力してください"
                v-model.trim="userInfo.accountName"
              />
              <input type="text" :value="userInfo.email" autocomplete="username" class="hidden" />
            </dd>
          </dl>
          <dl class="flex group-admin01 group-linebot01">
            <dt><span class="ja">プラン</span><span class="en">Plan</span></dt>
            <dd>{{ plan.title }}</dd>
          </dl>
          <dl class="flex group-admin01 group-linebot01">
            <dt><span class="ja">クライアントID</span><span class="en">Client id</span></dt>
            <dd class="fz14">{{ lineClientId }}</dd>
          </dl>
          <dl class="flex group-admin01 group-linebot01">
            <dt><span class="ja">チャネルシークレット</span><span class="en">Channel Secret</span></dt>
            <dd class="fz14 flex ai_center">
              <span>{{ lineSecret }}<i class="fa fa-check-circle" aria-hidden="true"></i></span>
            </dd>
          </dl>
          <dl class="flex group-admin01 group-linebot01">
            <dt><span class="ja">Webhook URL</span></dt>
            <dd class="fz14">
              <span>{{ webhook }}<i class="fa fa-check-circle" aria-hidden="true"></i></span>
            </dd>
          </dl>
          <dl class="flex group-admin01 group-linebot01">
            <dt><span class="ja">管理者</span></dt>
            <dd class="fz14">
              <span>{{ admin.name }}</span>
            </dd>
          </dl>
          <dl class="flex group-admin01 group-linebot01">
            <dt>
              <span class="ja">LIFF ID<required-mark /></span>
              <span class="en">from LIFFアプリ詳細</span>
            </dt>
          </dl>
          <dl class="flex group-admin01 group-linebot01">
            <dt>
              <span class="ja">現在のパスワード<required-mark /></span>
              <span class="en">Current password</span>
            </dt>
            <dd class="fz14">
              <input
                id="password"
                type="password"
                class="form-control"
                v-model.trim="userInfo.currentPassword"
                autocomplete="off"
              />
            </dd>
          </dl>
          <dl class="flex group-admin01 group-linebot01">
            <dt>
              <span class="ja">新しいパスワード</span>
              <span class="en">Password</span>
            </dt>
            <dd class="fz14">
              <input
                id="password"
                type="password"
                class="form-control"
                v-model.trim="userInfo.newPassword"
                autocomplete="new-password"
              />
            </dd>
          </dl>
          <dl class="flex group-admin01 group-linebot01">
            <dt>
              <span class="ja">パスワード(確認用) </span>
              <span class="en">Password confirm</span>
            </dt>
            <dd class="fz14">
              <input
                id="password"
                type="password"
                class="form-control"
                v-model.trim="userInfo.passwordConfirm"
                autocomplete="new-password"
              />
            </dd>
          </dl>
        </div>
        <div class="d-flex justify-content-center">
          <div class="btn btn-submit btn-block" :disabled="isDisabled" @click="submitForm">保存</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['auth', 'admin', 'plan'],
  components: {},

  data() {
    return {
      ROOT_PATH: import.meta.env.VITE_ROOT_PATH,
      userInfo: {
        accountName: this.auth.line_name,
        currentPassword: '',
        newPassword: '',
        passwordConfirm: '',
        email: this.auth.email
      },
      lineClientId: '',
      lineSecret: '',
      webhook: '',
      isLoading: true,
      isDisabled: false,
      errorMessage: ''
    };
  },

  beforeMount() {
    this.getAcount();
  },

  mounted() {},

  watch: {
    userInfo: {
      handler(val) {
        if (val.accountName) {
          this.isDisabled = false;
        } else {
          this.isDisabled = true;
        }
      },
      deep: true
    },
    errorMessage: {
      handler(val) {
        if (val.status) {
          window.toastr.success(val);
        } else {
          window.toastr.error(val);
        }
      },
      deep: true
    }
  },

  methods: {
    getAcount() {
      this.$store
        .dispatch('auth/getAccount')
        .done(res => {
          this.isLoading = false;
          this.lineClientId = res.line_setting.client_id;
          this.lineSecret = res.line_setting.channel_secret;
          this.webhook = res.line_setting.webhook_url;
          this.$nextTick(() => {
            window.initShowPassword();
          });
        })
        .fail(err => {
          // show error
          console.log(err);
        });
    },

    submitForm() {
      this.$store
        .dispatch('auth/editAccount', this.userInfo)
        .done(res => {
          if (this.userInfo.newPassword) {
            window.location.href = '/information?is_updated=true';
          } else {
            window.location.href = '/information';
          }
        })
        .fail(err => {
          // show error
          if (err.responseJSON.errors) {
            if (err.responseJSON.errors.newPassword) {
              this.errorMessage = err.responseJSON.errors.newPassword[0];
            }
            if (err.responseJSON.errors.passwordConfirm) {
              this.errorMessage = err.responseJSON.errors.passwordConfirm[0];
            }
            if (err.responseJSON.errors.currentPassword) {
              this.errorMessage = err.responseJSON.errors.currentPassword[0];
            }
          }

          console.log(err.responseJSON);
          if (err.responseJSON.error) {
            this.errorMessage = err.responseJSON.error;
          }

          // window.toastr.error(this.errorMessage);
        });
    }
  }
};
</script>

<style lang="scss" scoped>
  .group-admin01 {
    border-bottom: 1px solid #e5e5e5;
  }
</style>
