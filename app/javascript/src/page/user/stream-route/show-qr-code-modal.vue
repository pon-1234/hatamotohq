<template>
  <div
    id="modalShowQRCode"
    class="modal fade"
    tabindex="-1"
    role="dialog"
    aria-labelledby="info-header-modalLabel"
    aria-hidden="true"
    ref="modalShowQRCode"
  >
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="info-header-modalLabel">QRコード</h5>
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        </div>
        <div class="modal-body" :key="contentKey">
          <div class="mr-auto">
            <div class="qr-code-container d-flex justify-content-center">
              <qr-code :text="streamRoute.stream_route_url"></qr-code>
            </div>
            <h4 class="text-center">{{streamRoute.qr_title}}</h4>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['streamRoute'],

  data() {
    return {
      contentKey: 0
    };
  },

  mounted() {
    $(this.$refs.modalShowQRCode).on('show.bs.modal', this.onShow);
  },

  methods: {
    forceRerender() {
      this.contentKey++;
    },

    async onShow() {
      this.forceRerender();
    }
  }
};
</script>
