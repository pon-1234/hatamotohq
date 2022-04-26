<template>
  <div
    id="modalScenarioMessagePreview"
    class="modal fade"
    tabindex="-1"
    role="dialog"
    aria-labelledby="info-header-modalLabel"
    aria-hidden="true"
    ref="modalScenarioMessagePreview"
  >
    <div class="modal-dialog">
      <div class="modal-content" :key="contentKey">
        <div class="modal-header">
          <h5 class="modal-title" id="info-header-modalLabel">シナリオプレビュー</h5>
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        </div>
        <div class="modal-body modal-body-main">
          <div class="message-area">
            <TextMessage :data="`${scenariosMessage.content ? scenariosMessage.content.text : '' }`" />
          </div>
        </div>
        <div class="modal-body">
          <h5>URLクリック測定</h5>
          <table class="table table-striped">
            <thead>
              <tr>
                <th>サイト</th>
                <th>このシナリオ</th>
                <th class="hidden-xs"></th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <th>
                  <b>{{scenariosMessage.real_site_name}}</b><br />
                  <small>
                    <a :href="scenariosMessage.real_site_url" target="_blank"
                      >{{scenariosMessage.real_site_url}}</a
                    >
                  </small>
                </th>
                <td>
                  <b>{{scenariosMessage.visitor_count}}</b>人訪問 / <b>{{scenariosMessage.receiver_count}}</b>人<br />
                  <small>(計{{scenariosMessage.click_count}}クリック)</small>
                </td>
                <td class="hidden-xs">
                  <a :href="`/user/sites/${scenariosMessage.site_id}`" class="btn btn-warning btn-sm">サイトCV</a>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['scenariosMessage'],

  data() {
    return {
      contentKey: 0
    };
  },

  mounted() {
    $(this.$refs.modalScenarioMessagePreview).on('show.bs.modal', this.onShow);
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
<style lang="scss" scoped>
  .modal-body-main {
    background-color: #ddd;
  }
  .message-area {
    background-color: white;
    border-radius: 4px;
    padding: 1em;
    width: 20em;
    margin: 1em auto;
    word-break: break-all;
  }
</style>