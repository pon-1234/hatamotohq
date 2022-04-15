<template>
  <div class="mt-2">
    <div class="d-flex align-items-center">
      <button @click="searchSites" class="btn btn-primary mw-200">URLもし込</button>
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
    <div>{{sites}}</div>
  </div>
</template>
<script>
import { mapState, mapActions } from 'vuex';

export default {
  props: ['messageContent', 'index'],
  // inject: ['parentValidator'],
  // created() {
  //   this.$validator = this.parentValidator;
  // },
  data() {
    return {
      notUseShorternUrl: false,
      sites: []
    };
  },
  mounted() {
    // abc
  },
  computed: {
    ...mapState('site', {
      sites: state => _.flatten(state.folders.map((folder) => folder.sites))
    })
  },
  methods: {
    ...mapActions('site', [
      'getSites'
    ]),
    changeShortenUrlUsage() {
      this.notUseShorternUrl = !this.notUseShorternUrl;
    },
    async searchSites() {
      // Todo call ajax to get site of current client
      // this.sites = [
      //   { name: 'google.com', url: 'https://google.com' },
      //   { name: 'Vnexpress', url: 'http://vnexpress.net' }
      // ];
      await this.getSites();
    }
  }
};
</script>

<style lang="scss" scoped>
</style>
