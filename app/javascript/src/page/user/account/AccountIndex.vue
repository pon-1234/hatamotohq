<template>
  <div v-if="isLoading">ローディング...</div>
  <div v-else>
    <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
      <h3 class="hdg3">アカウント情報編集</h3>
      <div class="row-ttl02 flex">
        <div class="btn-common02 fz14"><a href="/information/edit">編集</a></div>
        <button class="btn btn-default" data-target="#modal-delete-account" data-toggle="modal" style="color: red">
          連携解除
        </button>
        <div></div>
      </div>
    </div>
    <div class="">
      <div class="col-xs-12">
        <div class="panel panel-linebot panel-linebot01">
          <div class="panel-body">
            <dl class="flex group-admin01 group-linebot01">
              <dt><span class="ja">LINEアカウント名</span><span class="en">Account name</span></dt>
              <dd>{{ accountName }}</dd>
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
          </div>
        </div>
      </div>
    </div>
    <div class="">
      <div class="col-xs-12">
        <div class="panel panel-linebot panel-linebot01">
          <div class="panel-body">
            <dl class="flex group-admin01 group-linebot01 no-mgn">
              <dt><span class="ja">管理者</span><span class="en">admin</span></dt>
              <dd>{{ admin.name }}</dd>
            </dl>
          </div>
        </div>
      </div>
    </div>

    <!--MOdal-->

    <b-modal class="modal modal-common01" id="modal-update-account" aria-hidden="true" title="Update" hide-footer>
      <div class="form-common01">
        <div class="modal-body">
          <div class="form-group p-0">
            <label>Client Id</label>
            <input
              v-model.trim="form.lineClientId"
              type="text"
              class="form-control"
              placeholder="タイトルを入力してください"
            />
          </div>
          <div class="form-group">
            <label>チャネルシークレット</label>
            <input
              v-model.trim="form.lineSecret"
              type="text"
              class="form-control"
              placeholder="タイトルを入力してください"
            />
          </div>
        </div>
      </div>
    </b-modal>

    <div id="modal-delete-account" class="modal fade" role="dialog">
      <div class="modal-dialog" style="margin-top: 100px">
        <!-- Modal content-->
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">&times;</button>
            <h4 class="modal-title">アカウントを切断</h4>
          </div>
          <div class="modal-body">
            <p class="message-disconnect">
              連携解除をするとデータは全て削除され復元できません。<br />よろしいでしょうか。
            </p>
          </div>
          <form :action="routeDelete" method="POST">
            <input type="hidden" name="_method" value="DELETE" />
            <input type="hidden" name="uid" :value="auth.uid" />

            <div class="modal-footer">
              <div class="btn btn-default" data-dismiss="modal">キャンセル</div>
              <div class="btn btn-default btn-disconnect">同意する</div>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Util from '@/core/util';

export default {
  props: ['auth', 'admin', 'plan', 'routeDelete', 'errMsg'],
  components: {},

  data() {
    return {
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH,
      accountName: this.auth.line_name,
      lineClientId: '',
      lineSecret: '',
      webhook: '',
      isLoading: true,
      form: {
        lineClientId: '',
        lineSecret: ''
      }
    };
  },

  created() {
    if (performance.navigation.type !== performance.navigation.TYPE_RELOAD) {
      if (Util.getParamFromUrl('is_updated') === 'true') {
        window.toastr.success('アカウントのパスワードを変更しました');
      }
    }
  },

  beforeMount() {
    this.getAcount();
    if (this.errMsg) {
      window.toastr.error(this.errMsg);
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

          this.form.lineClientId = res.line_setting.client_id;
          this.form.lineSecret = res.line_setting.channel_secret;
        })
        .fail(err => {
          // show error
          console.log(err);
        });
    }
  }
};
</script>

<style scoped lang="scss">
  .btn-disconnect {
    display: inline;
    background-color: #e80000 !important;
    color: white;
  }

  .message-disconnect {
    color: rgb(232, 0, 0);
  }
</style>
