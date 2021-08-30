<template>
  <div>
    <div class="card">
      <div class="card-header d-flex">
        <h5 class="m-auto font-weight-bold">アカウント情報</h5>
      </div>
      <div class="card-body">
        <div class="form-group row">
          <label class="col-sm-2 col-form-label">クライアントID</label>
          <div class="col-sm-10">
            <input type="text" class="form-control" placeholder="Email" v-model="lineChannelId">
          </div>
        </div>
      </div>
    </div>
    <div class="">
      <div class="col-xs-12">
        <div class="panel panel-linebot panel-linebot01">
          <div class="panel-body">
            <dl class="flex group-admin01 group-linebot01">
              <dt>
                <span class="ja">クライアントID</span
                ><span class="en">Client id</span>
              </dt>
              <dd class="fz14">{{ lineChannelId }}</dd>
            </dl>
            <dl class="flex group-admin01 group-linebot01">
              <dt>
                <span class="ja">チャネルシークレット</span
                ><span class="en">Channel Secret</span>
              </dt>
              <dd class="fz14 flex ai_center">
                <span
                  >{{ lineChannelSecret
                  }}<i class="fa fa-check-circle" aria-hidden="true"></i
                ></span>
              </dd>
            </dl>
            <dl class="flex group-admin01 group-linebot01">
              <dt><span class="ja">Webhook URL</span></dt>
              <dd class="fz14">
                <span
                  >{{ webhook
                  }}<i class="fa fa-check-circle" aria-hidden="true"></i
                ></span>
              </dd>
            </dl>
            <dl class="flex group-admin01 group-linebot01">
              <dt><span class="ja">LIFF ID</span></dt>
              <dd class="fz14">
                <span>{{ liff_id }}</span>
              </dd>
            </dl>
          </div>
        </div>
      </div>
    </div>
    <b-modal
      class="modal modal-common01"
      id="modal-update-account"
      aria-hidden="true"
      title="Update"
      hide-footer
    >
      <div class="form-common01">
        <div class="modal-body">
          <div class="form-group p-0">
            <label>Client Id</label>
            <input
              v-model.trim="form.lineChannelId"
              type="text"
              class="form-control"
              placeholder="タイトルを入力してください"
            />
          </div>
          <div class="form-group">
            <label>チャネルシークレット</label>
            <input
              v-model.trim="form.lineChannelSecret"
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
        <p class="message-disconnect">連携解除をするとデータは全て削除され復元できません。<br>よろしいでしょうか。</p>
      </div>
    </div>

  </div>
</div>

  </div>
</template>

<script>
import Util from '@/core/util';

export default {
  props: ['line_account'],
  components: {},

  data() {
    return {
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH,
      lineChannelId: '',
      lineChannelId: '',
      lineChannelSecret: '',
      webhook: '',
      liff_id: '',
      isLoading: true,
      form: {
        lineChannelId: '',
        lineChannelSecret: ''
      }
    };
  },

  created() {
    this.lineChannelId = this.line_account.line_channel_id;
    this.lineChannelSecret = this.line_account.line_channel_secret;
    this.webhook = this.line_account.webhook_url;
    this.liff_id = this.line_account.liff_id;
    this.form.lineChannelId = this.line_account.line_channel_id;
    this.form.lineChannelSecret = this.line_account.channel_secret;
  },

  methods: {
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
