<template>
  <div class="modal fade" id="announcementDetail" tabindex="-1" role="dialog" aria-hidden="true" ref="vuemodal">
    <div class="modal-dialog modal-lg" role="document">
      <div class="modal-content p-2">
        <div class="modal-header">
          <label class="modal-title" id="exampleModalLongTitle">announcement detail</label>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="row mb-2">
            <label class="col-12 m-0">日時</label>
            <div class="col-12">{{ announcement.announced_at }}</div>
          </div>
          <div class="row mb-2">
            <label class="col-12 m-0">タイトル</label>
            <div class="col-12">{{ announcement.title }}</div>
          </div>
          <div class="row mb-2">
            <label class="col-12 m-0">Body</label>
            <section class="col-12">
              <div id="output" class="" v-html="modifyUrl(announcement.body)"></div>
            </section>
          </div>
        </div>
        <div class="modal-footer d-flex justify-content-center">
          <button type="button" class="btn btn"></button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import moment from 'moment-timezone';
export default {
  props: ['announcements'],
  data() {
    return {
      announcement: {}
    };
  },

  mounted() {
    $(this.$refs.vuemodal).on('show.bs.modal', this.shownModal);
  },

  methods: {
    shownModal() {
      if ($('#inputValue').val()) {
        const currAnnouncementId = $('#inputValue').val();
        this.announcement = this.announcements.find(e => e.id === Number(currAnnouncementId));
        this.announcement.announced_at = moment(this.announcement.announced_at).format('YYYY年MM月DD日');
        console.log(this.announcement);
      }
    },
    modifyUrl(url) {
      let endpoint = url;
      if (endpoint && endpoint.includes('<oembed')) {
        endpoint = endpoint.replaceAll('oembed', 'iframe');
        endpoint = endpoint.replaceAll('url', 'src');
        endpoint = endpoint.replaceAll('watch?v=', 'embed/');
      }
      return endpoint;
    }
  }
};
</script>

<style lang="scss" scoped>
</style>