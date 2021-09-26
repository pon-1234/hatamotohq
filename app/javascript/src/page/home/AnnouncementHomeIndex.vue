<template>
  <div>
    <div class="card">
      <div class="card-header text-md">
        <b>最新情報</b>
      </div>
      <div class="card-body">
          <div v-for="announcement in announcementList" :key="announcement.id">
            <a class="home_announcement_btn" data-toggle="modal" data-target="#announcementDetail" @click="onShowModal(announcement.id)">
              <span> {{ moment(announcement.announced_at) }}</span>
              <span> {{ announcement.title }}</span>
            </a>
          </div>
      </div>
    </div>
    <modal-announcement-show ref="modalAnnouncementDetail" :announcements=announcementList :status="`user`"></modal-announcement-show>
  </div>
</template>
<script>
import moment from 'moment-timezone';
export default {
  props: ['announcements'],
  data() {
    return {
      announcementList: [],
      currentPage: 1,
      totalRows: 0
    };
  },
  created() {
    this.announcementList = _.cloneDeep(this.announcements);
  },
  methods: {
    moment(date) {
      return moment(date).tz('Asia/Tokyo').format('YYYY.MM.DD. HH:mm');
    },
    onShowModal(id) {
      this.$refs.modalAnnouncementDetail.shownModal(id);
    }
  }
};
</script>
<style lang="scss" scoped>
</style>