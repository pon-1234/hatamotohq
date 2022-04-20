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
              <th class="d-none d-md-table-cell">訪問時</th>
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
              <td class="d-none d-md-table-cell">
                <div>-</div>
              </td>
              <td>
                <button @click="selectSite(index)" class="btn btn-sm btn-primary mw-120 float-right">設定</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="col-sm-6" v-show="showConfigUrlPanel" v-if="sitesInMessageContent[selectedSiteIndex]">
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
                <div class="input-group">
                  <span class="input-group-text">(変更) -&gt;</span>
                  <input v-model="redirectUrl" type="text" placeholder="http://example.com" class="form-control">
                </div>
                <small class="form-help">
                  転送先を変更します。<br><b style="color: red;">記録は元(変更前)のURLへのアクセスとしてカウントされます</b>
                </small>
              </div>
              <div class="form-group"><b>訪問時アクション</b>
                <div class="has-modal-xl">
                  <div class="row">
                    <div class="col-sm-8">
                      <span class="btn btn-warning btn-sm btn-block"><i class="glyphicon glyphicon-flash"></i> アクションを設定する</span>
                    </div>
                    <div class="col-sm-4"></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="panel-footer">
            <button @click="showConfigUrlPanel = false; selectedSiteIndex = null" type="button" class="btn btn-danger float-left">閉じる</button>
            <button @click="configUrl" type="button" class="btn btn-success float-right">設定する</button>
            <div class="clearfix"></div>
          </div>
        </div>
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
      currentSiteMeasurementId: null
    };
  },
  mounted() {
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
      if (this.siteMeasurements && this.siteMeasurements.length) {
        const currentSiteMeasurement = _.find(this.siteMeasurements, siteMeasurement => siteMeasurement.site_id === this.sitesInMessageContent[this.selectedSiteIndex].id);
        this.currentSiteMeasurementId = currentSiteMeasurement.id;
        this.siteName = currentSiteMeasurement.site_name;
        this.redirectUrl = currentSiteMeasurement.redirect_url;
      } else {
        this.siteName = this.sitesInMessageContent[this.selectedSiteIndex].name;
      }
    },
    configUrl() {
      this.showConfigUrlPanel = false;
      this.$emit('configured', { index: this.index, content: { id: this.currentSiteMeasurementId, site_name: this.siteName, redirect_url: this.redirectUrl, site_id: this.sitesInMessageContent[this.selectedSiteIndex].id } });
    }
  }
};
</script>

<style lang="scss" scoped>
  .site-row.selected {
    background-color: #fcf8e3;
  }
</style>
