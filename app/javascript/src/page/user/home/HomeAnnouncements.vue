<template>
  <div>
    <div class="card mvh-50">
      <div class="card-header border-bottom border-primary text-md">
        <b>お知らせ</b>
      </div>
      <div class="card-body" v-if="!loading">
        <div
          v-for="announcement in announcements"
          :key="announcement.id"
          role="button"
          data-toggle="modal"
          data-target="#modalAnnouncementDetail"
          @click="curAnnouncement = announcement"
        >
          <h4 class="mt-0 mb-1 font-16 max-3-lines">{{ announcement.title }}</h4>
          <p class="text-muted">
            <small>{{ formattedDate(announcement.announced_at) }}</small>
          </p>
        </div>
        <div class="d-flex justify-content-center mt-4" v-if="totalRows > perPage">
          <b-pagination
            v-model="currentPage"
            :total-rows="totalRows"
            :per-page="perPage"
            @change="loadPage"
            aria-controls="my-table"
          ></b-pagination>
        </div>
        <div v-if="totalRows === 0" class="text-center mt-4"><b>お知らせはありません。</b></div>
      </div>

      <loading-indicator :loading="loading"></loading-indicator>
    </div>
    <modal-announcement-detail :announcement="curAnnouncement"></modal-announcement-detail>
  </div>
</template>
<script>
import { mapActions, mapState, mapMutations } from 'vuex';
import Util from '@/core/util';

export default {
  data() {
    return {
      loading: true,
      currentPage: 1,
      curAnnouncement: null,
      contentKey: 0
    };
  },

  async beforeMount() {
    await this.getPublishedAnnouncements();
    this.loading = false;
  },

  computed: {
    ...mapState('announcement', {
      announcements: state => state.announcements,
      totalRows: state => state.totalRows,
      perPage: state => state.perPage
    })
  },

  methods: {
    ...mapMutations('announcement', ['setCurPage']),
    ...mapActions('announcement', ['getPublishedAnnouncements']),

    async loadPage() {
      // bootstrap pagination return old value of current page,
      // using nextTick to solve the issue
      this.$nextTick(async() => {
        this.loading = true;
        this.setCurPage(this.currentPage);
        await this.getPublishedAnnouncements();
        this.forceRerender();
        this.loading = false;
      });
    },

    forceRerender() {
      this.contentKey++;
    },

    formattedDate(time) {
      return Util.formattedDate(time);
    }
  }
};
</script>
<style lang="scss" scoped>
</style>