<template>
  <div>
    <div>
      <div>
        <div>
          <div class="row">
            <div class="col-sm-6">
              <div class="site-name border rounded p-2">
                <p class="mb-1"><strong>{{siteDetail.name}}</strong></p>
                <a :href="siteDetail.url">{{siteDetail.url}}</a>
              </div>
            </div>
            <div class="col-sm-6">
              <table class="table table-striped">
                <thead>
                  <tr>
                    <th>総クリック数(配信)</th>
                    <th>訪問者数(配信)</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>{{siteDetail.click_count}}クリック</td>
                    <td>{{siteDetail.visitor_count}}人</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <ul class="nav nav-tabs nav-bordered" role="tablist">
          <li role="presentation">
            <a
              aria-controls="text"
              role="tab"
              data-toggle="tab"
              aria-expanded="true"
              class="active"
              @click="changeTab('general')"
            >
              概要
            </a>
          </li>
          <li role="presentation">
            <a
              aria-controls="text"
              role="tab"
              data-toggle="tab"
              aria-expanded="true"
              @click="changeTab('scenario')"
            >
              シナリオ配信
            </a>
          </li>
          <li role="presentation">
            <a
              aria-controls="text"
              role="tab"
              data-toggle="tab"
              aria-expanded="true"
              @click="changeTab('broadcast')"
            >
              一斉配信
            </a>
          </li>
        </ul>

        <div class="row">
          <general-info :siteDetail="siteDetail" v-if="showedTab === 'general'" />
          <group-by-broadcast-info :siteId="site_id" v-if="showedTab === 'broadcast'" />
          <group-by-scenario-info :siteId="site_id" v-if="showedTab === 'scenario'" />
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { mapActions, mapState } from 'vuex';
import GeneralInfo from './site-detail-components/GeneralInfo.vue';
import GroupByBroadcastInfo from './site-detail-components/GroupByBroadcastInfo.vue';
import GroupByScenarioInfo from './site-detail-components/GroupByScenarioInfo.vue';

export default {
  components: { GeneralInfo, GroupByBroadcastInfo, GroupByScenarioInfo },
  props: ['site_id'],
  data() {
    return {
      showedTab: 'general',
      loading: true
    };
  },
  async beforeMount() {
    await this.getSiteDetail({ id: this.site_id });
    this.loading = false;
  },
  computed: {
    ...mapState('site', {
      siteDetail: state => state.siteDetail
    })
  },
  methods: {
    ...mapActions('site', ['getSiteDetail']),
    changeTab(tabName) {
      this.showedTab = tabName;
    }
  }
};
</script>
<style lang="scss" scoped>
  li {
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    .nav-button {
      width: 100% !important;
      display: flex !important;
      height: 40px;
      align-items: center !important;
      border: 1px solid #e4e4e4;
      padding-left: 10px;
    }
  }

  li.active {
    .nav-button {
      border-left: 3px solid #727cf5;
      color: #727cf5;
      font-weight: bold;
    }
  }
</style>
