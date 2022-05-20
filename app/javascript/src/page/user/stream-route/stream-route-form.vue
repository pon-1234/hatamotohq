<template>
  <ValidationObserver ref="observer" v-slot="{ validate }">
    <form
      ref="form"
      @submit.prevent="validate().then(onSubmit)"
      :action="formAction"
      method="post"
      enctype="multipart/form-data"
    >
      <input type="hidden" name="authenticity_token" :value="csrfToken" />
      <div class="mxw-1200">
        <div class="card">
          <div class="card-body">
            <div class="form-border">
              <ValidationProvider
                :name="'流入経路名称'"
                :rules="'required|max:255'"
                v-slot="{ errors }"
              >
                <div class="form-group">
                  <label>流入経路名称<required-mark /></label>
                  <input
                    type="text"
                    class="form-control"
                    maxlength="255"
                    placeholder="流入経路名称を入力してください"
                    v-model.trim="streamRouteFormData.name"
                  />
                  <span class="error-explanation">{{ errors[0] }}</span>
                </div>
              </ValidationProvider>
            </div>
            <div class="form-border">
              <ValidationProvider
                :name="'QRコード表示用テキスト'"
                :rules="'max:16'"
                v-slot="{ errors }"
              >
                <div class="form-group">
                  <label>QRコード表示用テキスト</label>
                  <input
                    type="text"
                    class="form-control"
                    maxlength="255"
                    placeholder="QRコード表示用テキストを入力してください"
                    v-model.trim="streamRouteFormData.qr_title"
                  />
                  <span class="error-explanation">{{ errors[0] }}</span>
                </div>
              </ValidationProvider>
            </div>

            <div class=" form-group">
              <label for="action_id">アクション</label>
              <div id="action_selector">
                <div class="has-modal-xl">
                  <div class="row">
                    <div class="col-sm-4">
                      <span class="btn btn-warning btn-sm btn-block"><i class="glyphicon glyphicon-flash"></i> アクションを設定する</span>
                    </div>
                    <div class="col-sm-4"></div>
                  </div>
                  <input type="hidden" name="action_id" value="0">
                </div>
              </div>
            </div>

            <div class="row">
              <div class="col-sm-8">
                <label for="run_add_friend_actions">友だち追加時設定</label>
                <div class="btn-group btn-group-toggle w-100" data-toggle="buttons">
                    <label @click="changeRunAddFriendActions(false)" class="btn btn-primary d-flex justify-content-center prevent-default-label">
                      <input
                        type="radio"
                        name="run_add_friend_actions"
                        :value="false"
                        autocomplete="off"
                        :checked="!streamRouteFormData.run_add_friend_actions"
                      > 無視する
                    </label>
                    <label @click="changeRunAddFriendActions(true)" class="btn btn-primary text-center d-flex justify-content-center prevent-default-label">
                      <input
                        type="radio"
                        name="run_add_friend_actions"
                        :value="true"
                        autocomplete="off"
                        :checked="streamRouteFormData.run_add_friend_actions"
                      > 無視しない
                    </label>
                </div>
              </div>
            </div>

            <div class="row mt-3">
              <div class="col-sm-8">
                <label for="always_run_actions">アクションの実行</label>
                <div class="btn-group btn-group-toggle w-100" data-toggle="buttons">
                    <label @click="changeAlwaysRunActions(true)" class="btn btn-primary d-flex justify-content-center prevent-default-label">
                      <input
                        type="radio"
                        name="always_run_actions"
                        :value="false"
                        autocomplete="off"
                        :checked="streamRouteFormData.always_run_actions"
                      > いつでも
                    </label>
                    <label @click="changeAlwaysRunActions(false)" class="btn btn-primary text-center d-flex justify-content-center prevent-default-label">
                      <input
                        type="radio"
                        name="always_run_actions"
                        :value="true"
                        autocomplete="off"
                        :checked="!streamRouteFormData.always_run_actions"
                      > 初回の友だち追加時のみ
                    </label>
                </div>
              </div>
            </div>

            <div class="form-border mt-3">
              <div class="form-group">
                <label class="fw-300">フォルダー</label>
                <div class="flex-grow-1">
                  <select v-model="streamRouteFormData.folder_id" class="form-control fw-300" name="site[sxfolder_id]">
                    <option v-for="(folder, index) in folder_options" :key="index" :value="folder.id">
                      {{ folder.name }}
                    </option>
                  </select>
                </div>
              </div>
            </div>
          </div>
          <div class="card-footer text-center">
            <button type="submit" class="btn btn-primary mw-120"><strong>保存</strong></button>
          </div>

          <loading-indicator :loading="loading"></loading-indicator>
        </div>
      </div>
    </form>
  </ValidationObserver>
</template>
<script>
import { mapActions, mapState } from 'vuex';
import Util from '@/core/util';

export default {
  props: ['folder_options'],
  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH,
      csrfToken: Util.getCsrfToken(),
      loading: true,
      streamRouteFormData: {
        name: null,
        qr_title: null,
        run_add_friend_actions: false,
        always_run_actions: true,
        folder_id: null
      }
    };
  },

  async beforeMount() {
    this.streamRouteFormData.folder_id = Util.getParamFromUrl('folder_id');
    this.loading = false;
  },

  computed: {
    formAction() {
      return `${this.rootPath}/user/sites`;
    },
    ...mapState('site', {
      folders: state => state.folders
    })
  },

  methods: {
    ...mapActions('streamRoute', [
      'createStreamRoute'
    ]),

    async onSubmit(e) {
      const formData = _.pick(this.streamRouteFormData, ['name', 'qr_title', 'run_add_friend_actions', 'always_run_actions', 'folder_id']);
      this.createStreamRoute(formData)
        .then(response => {
          Util.showSuccessThenRedirect('create success!', `${this.rootPath}/user/`);
        })
        .catch(error => {
          window.toastr.error(error.responseJSON.message);
        });
    },

    changeRunAddFriendActions(value) {
      this.streamRouteFormData.run_add_friend_actions = value;
    },

    changeAlwaysRunActions(value) {
      this.streamRouteFormData.always_run_actions = value;
    }
  }
};
</script>

<style lang="scss" scoped>
  .prevent-default-label {
    background-color: #e6e6e6;
    color: #000;
    border-color: #adadad;
    box-shadow: unset;

  }
</style>