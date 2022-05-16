<template>
  <ValidationObserver ref="observer" v-slot="{ validate }">
    <form
      ref="form"
      @submit.prevent="validate().then(onSubmit)"
      :action="formAction"
      method="post"
      enctype="multipart/form-data"
      data-remote="true"
    >
      <input type="hidden" name="authenticity_token" :value="csrfToken" />
      <div class="mxw-1200">
        <div class="card">
          <div class="card-body">
            <div class="form-border">
              <div class="form-group">
                <label class="fw-300">フォルダー</label>
                <div class="flex-grow-1">
                  <select v-model="siteFormData.folder_id" class="form-control fw-300" name="site[folder_id]">
                    <option v-for="(folder, index) in folders" :key="index" :value="folder.id">
                      {{ folder.name }}
                    </option>
                  </select>
                </div>
              </div>
            </div>
            <div class="form-border">
              <ValidationProvider
                :name="'サイト名'"
                :rules="'required'"
                v-slot="{ errors }"
              >
                <div class="form-group">
                  <label>サイト名<required-mark /></label>
                  <input
                    type="text"
                    class="form-control"
                    name="site[name]"
                    placeholder="サイト名を入力してください"
                    v-model.trim="siteFormData.name"
                  />
                  <span class="error-explanation">{{ errors[0] }}</span>
                </div>
              </ValidationProvider>
            </div>
            <div class="form-border">
              <ValidationProvider
                :name="'URL'"
                :rules="'required|url'"
                v-slot="{ errors }"
              >
                <div class="form-group">
                  <label>URL<required-mark /></label>
                  <input
                    type="text"
                    class="form-control"
                    name="site[url]"
                    placeholder="URLを入力してください"
                    v-model.trim="siteFormData.url"
                  />
                  <span class="error-explanation">{{ errors[0] }}</span>
                </div>
              </ValidationProvider>
            </div>
          </div>
          <div class="card-footer d-flex">
            <button type="submit" class="btn btn-success mw-120"><strong>サイト登録</strong></button>
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
  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH,
      csrfToken: Util.getCsrfToken(),
      loading: true,
      siteFormData: {
        url: null,
        name: null,
        folder_id: null
      }
    };
  },

  async beforeMount() {
    this.siteFormData.folder_id = Util.getParamFromUrl('folder_id');
    await this.getFolders();
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
    ...mapActions('site', [
      'getFolders'
    ]),

    async onSubmit(e) {
      // use requestSubmit() instead of submit() to use data-remote of Rails
      this.$refs.form.requestSubmit();
    }
  }
};
</script>
