<template>
  <div class="mt-2">
    <div class="d-flex align-items-center">
      <button :disabled="notUseShorternUrl" @click="searchSites" class="btn btn-primary mw-200">読み込み</button>
      <div class="checkbox-inline ml-3">
        <div class="custom-control custom-checkbox mr-4" @click="changeShortenUrlUsage">
          <input
            type="checkbox"
            :value="true"
            v-model="notUseShorternUrl"
            class="custom-control-input"
          />
          <label class="custom-control-label text-nowrap">このメッセージではURLを短縮しない</label>
        </div>
      </div>
    </div>
    <div class="row" v-show="sitesInMessageContent && sitesInMessageContent.length">
      <div :class="`mt-2 ${showConfigUrlPanel ? 'col-sm-6' : 'col'}`" v-show="!notUseShorternUrl">
        <table class="table table-centered mb-0">
          <thead>
            <tr>
              <th>サイト名</th>
              <th :class="`d-none ${showConfigUrlPanel ? '' : 'd-md-table-cell'}`" v-show="!showConfigUrlPanel">訪問時</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(site, index) in sitesInMessageContent" :key="site.id" :class="`site-row ${selectedSiteIndex === index ? 'selected' : ''}`">
              <td>
                <strong>{{site.name}}</strong>
                <br/>
                <span>{{site.url}}</span>
              </td>
              <td :class="`d-none ${showConfigUrlPanel ? '' : 'd-md-table-cell'}`" v-show="!showConfigUrlPanel">
                <div v-html="getActionsOfUrl(site)"></div>
              </td>
              <td>
                <button @click="selectSite(index)" class="btn btn-sm btn-primary mw-120 float-right">設定</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="col-sm-6" v-show="showConfigUrlPanel" v-if="sitesInMessageContent[selectedSiteIndex]">
        <ValidationObserver ref="observer" v-slot="{ validate }">
          <div class="panel panel-default border p-2 rounded">
            <div class="mb-2">
              <b>サイト設定</b> <small>URL:<span>{{sitesInMessageContent[selectedSiteIndex].url}}</span></small>
            </div>
            <div class="panel-body">
              <div>
                <div class="form-group">
                  <b>サイト登録名</b>
                  <input v-model="siteName" type="text" class="form-control">
                </div>
                <div class="form-group"><b>リダイレクト設定</b> <br>
                  (元)
                  <a target="_blank" :href="sitesInMessageContent[selectedSiteIndex].url">{{sitesInMessageContent[selectedSiteIndex].url}}</a>
                  <ValidationProvider
                    :name="'リダイレクトURL'"
                    :rules="'url'"
                    v-slot="{ errors }"
                  >
                    <div class="input-group">
                      <span class="input-group-text">(変更) -&gt;</span>
                      <input v-model="redirectUrl" type="text" placeholder="http://example.com" class="form-control">
                    </div>
                    <span class="error-explanation">{{ errors[0] }}</span>
                  </ValidationProvider>
                  <p><small class="form-help">
                    転送先を変更します。<br><b style="color: red;">記録は元(変更前)のURLへのアクセスとしてカウントされます</b>
                  </small></p>
                </div>
                <div class="form-group">
                  <div class="has-modal-xl">
                    <div class="row">
                      <div class="col">
                        <action-editor-custom
                          :requiredLabel="requiredLabel"
                          :showTitle="showTitle"
                          :showLaunchMessage="false"
                          :value="actionData"
                          :key="contentKey"
                          @input="updateAction"
                        />
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="panel-footer">
              <button @click="showConfigUrlPanel = false; selectedSiteIndex = null" type="button" class="btn btn-danger float-left">閉じる</button>
              <button type="button" class="btn btn-success float-right" @click="validate().then(configUrl)">設定する</button>
              <div class="clearfix"></div>
            </div>
          </div>
        </ValidationObserver>
      </div>
    </div>
  </div>
</template>
<script>
import { mapState, mapActions } from 'vuex';

export default {
  props: ['messageContent', 'index', 'siteMeasurements'],
  data() {
    return {
      notUseShorternUrl: false,
      showConfigUrlPanel: false,
      selectedSiteIndex: null,
      siteName: null,
      redirectUrl: null,
      currentSiteMeasurementId: null,
      actionData: null,
      mutationSiteMeasurements: [],
      contentKey: 0
    };
  },
  provide() {
    return { parentValidator: this.$validator };
  },
  mounted() {
    if (this.siteMeasurements) this.mutationSiteMeasurements = _.cloneDeep(this.siteMeasurements);
  },
  computed: {
    ...mapState('site', {
      sites: state => _.flatten(state.folders.map((folder) => folder.sites))
    }),
    sitesInMessageContent: function() {
      return this.sites.filter(site => this.messageContent.text.includes(site.url)) || [];
    }
  },
  methods: {
    ...mapActions('site', [
      'getSites'
    ]),
    changeShortenUrlUsage() {
      this.notUseShorternUrl = !this.notUseShorternUrl;
      if (this.notUseShorternUrl) { this.showConfigUrlPanel = false; }
      this.$emit('changeShortenUrlUsage', { index: this.index, notUseShorternUrl: this.notUseShorternUrl });
    },
    async searchSites() {
      await this.getSites();
    },
    selectSite(index) {
      this.showConfigUrlPanel = true;
      this.selectedSiteIndex = index;
      if (this.mutationSiteMeasurements && this.mutationSiteMeasurements.length) {
        const currentSiteMeasurement = _.find(this.mutationSiteMeasurements, siteMeasurement => siteMeasurement.site_id === this.sitesInMessageContent[this.selectedSiteIndex].id);
        if (!currentSiteMeasurement) {
          this.siteName = this.sitesInMessageContent[this.selectedSiteIndex].name;
          return;
        }
        this.currentSiteMeasurementId = currentSiteMeasurement.id;
        this.siteName = currentSiteMeasurement.site_name;
        this.redirectUrl = currentSiteMeasurement.redirect_url;
        this.actionData = currentSiteMeasurement.actions;
        if (currentSiteMeasurement.actions && currentSiteMeasurement.actions.length) {
          this.actionData = currentSiteMeasurement.actions[0];
          this.forceRerenderActionForm();
        }
      } else {
        this.siteName = this.sitesInMessageContent[this.selectedSiteIndex].name;
      }
    },
    async configUrl() {
      const result = await this.$validator.validateAll();
      if (!result) return;
      this.showConfigUrlPanel = false;
      const urlConfigObject = { id: this.currentSiteMeasurementId, site_name: this.siteName, redirect_url: this.redirectUrl, site_id: this.sitesInMessageContent[this.selectedSiteIndex].id, actions: [this.actionData] };
      const currentSiteMeasurement = _.find(this.mutationSiteMeasurements, siteMeasurement => siteMeasurement.site_id === this.sitesInMessageContent[this.selectedSiteIndex].id);
      if (currentSiteMeasurement) {
        Object.assign(currentSiteMeasurement, urlConfigObject);
      } else {
        this.mutationSiteMeasurements.push(urlConfigObject);
      }

      this.$emit('configured', { index: this.index, content: this.mutationSiteMeasurements });
      this.actionData = null;
      this.forceRerenderActionForm();
    },
    updateAction(actions) {
      this.actionData = actions;
    },
    getActionsOfUrl(site) {
      const siteMeasurement = _.find(this.mutationSiteMeasurements, siteMeasurement => siteMeasurement.site_id === site.id);
      let result = '';
      if (!siteMeasurement || !siteMeasurement.actions.length || siteMeasurement.actions[0] === null) return '';
      siteMeasurement.actions[0].data.actions.forEach(action => {
        switch (action.type) {
        case 'text':
          result += `テキスト[${action.content.text}]を送信 <br>`;
          break;
        case 'template':
          result += `テンプレート[${action.content.name}]を送信 <br>`;
          break;
        case 'scenario':
          result += `シナリオ[${action.content.title}]を送信 <br>`;
          break;
        case 'email':
          result += `メール通知[${action.content.text}]を送信 <br>`;
          break;
        case 'tag':
          result += 'タグ操作を送信 <br>';
          break;
        case 'reminder':
          result += `リマインダ操作[${action.content.reminder.name}]を送信 <br>`;
          break;
        case 'scoring':
          result += `スコアリング操作[${action.content.variable.name}]を送信 <br>`;
          break;
        case 'rsv_intro':
          result += '予約・紹介送信を送信 <br>';
          break;
        case 'rsv_contact':
          result += '予約・お問い合わせを送信 <br>';
          break;
        case 'rsv_cancel_intro':
          result += '予約・空室待ちキャンセルを送信 <br>';
          break;
        case 'service_review':
          result += 'サービス評価フォームを送信 <br>';
          break;
        }
      });
      return result;
    },
    forceRerenderActionForm() {
      this.contentKey++;
    }
  }
};
</script>

<style lang="scss" scoped>
  .site-row.selected {
    background-color: #fcf8e3;
  }
  ::v-deep {
    .config-score-container {
      overflow-x: scroll;
    }
  }
</style>
