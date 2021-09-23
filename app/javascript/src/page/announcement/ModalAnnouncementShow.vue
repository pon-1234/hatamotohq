<template>
  <div class="modal fade" id="announcementDetail" tabindex="-1" role="dialog" aria-hidden="true" data-keyboard="false" ref="vuemodal">
    <div class="modal-dialog modal-xl modal-xlg modal-dialog-centered" role="document">
      <div class="modal-content p-2">
        <div class="modal-header">
          <h3 class="card-title" :class="status == 'admin' ? 'card-title_admin' : 'card-title_user' ">announcement detail</h3>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body modal-scroll-x">
          <!--title-->
          <div class="announcement_page--title">{{ announcement.title }}</div>
          <!--EDITOR-OUTPUT-->
          <section class="page-output">
            <div class="page-output__inner c-grid">
              <div id="output" class="" v-html="modifyUrl(announcement.body)"></div>
            </div>
          </section>
        </div>
        <div class="modal-footer d-flex justify-content-center" v-if="status == 'admin'">
          <a :href="`${rootUrl}/admin/announcements/${announcement.id}/edit`" class="btn btn-info m-auto fw-120">編集</a>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import moment from 'moment-timezone';
export default {
  props: ['announcements', 'status'],
  data() {
    return {
      rootUrl: process.env.MIX_ROOT_PATH,
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
  @media screen and (min-width: 576px) and (max-width: 1100px) {
    .modal-dialog {
      max-width: 95vw;
    }
  }

  .modal-header {
    border-bottom: 1px solid #fff;
    .card-title{
      padding-left: 15px;
      font-size: 1.2rem;
      line-height: 35px;
      font-weight: 600;
    }
    .card-title_admin {
      border-left: 4px solid #17a2b8;
    }
    .card-title_user {
      border-left: 4px solid #28a745;
    }
  }

  .modal-scroll-x {
    height: 75vh;
    overflow-x: auto;
    .announcement_page--title {
      font-size: 1.2rem;
      font-weight: 700;
      text-align: center;
    }
    .page-output__inner {
      padding-bottom: 100px
    }
    .c-grid {
      width: 100%;
      max-width: 1180px;
      padding-left: 40px;
      padding-right: 40px;
      margin: 0 auto;
      box-sizing: border-box
    }
    @media screen and (max-width:768px) {
      .page-output__inner {
        padding-bottom: 50px
      }
      .c-grid {
        padding-left: 20px;
        padding-right: 20px
      }
    }
  }
</style>