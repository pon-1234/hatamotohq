<template>
  <div
    class="modal fade"
    id="modalSendTemplate"
    tabindex="-1"
    role="dialog"
    aria-labelledby="myModalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog modal-xl vh-90 modal-dialog-scrollable" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">テンプレートを選択してください</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">×</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="d-flex" v-if="folders && folders.length">
            <folder-left
              type="template_message"
              :isPerview="true"
              :data="folders"
              :isPc="isPc"
              :selectedFolder="selectedFolder"
              @changeSelectedFolder="changeTemplateFolder"
            />
            <div class="flex-grow-1">
              <div class="table-responsive">
                <table class="table table-hover">
                  <thead class="thead-light">
                    <tr>
                      <th>
                        <span v-if="folders[selectedFolder]">{{ folders[selectedFolder].name }}</span>
                      </th>
                    </tr>
                  </thead>
                  <tbody v-if="folders[this.selectedFolder].templates && folders[this.selectedFolder].templates.length">
                    <tr
                      v-for="(item, index) in folders[this.selectedFolder].templates"
                      :key="index"
                      class="folder-item"
                    >
                      <td class="d-flex w-100">
                        <div>{{ item.name }}</div>
                        <div class="btn btn-info btn-sm ml-auto" data-dismiss="modal" @click="selectTemplate(item)">
                          送信
                        </div>
                      </td>
                    </tr>
                  </tbody>
                  <tbody v-else>
                    <tr>
                      <td class="text-center mt-5">
                        <b>登録テンプレートはありません。</b>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex';
export default {
  data() {
    return {
      selectedFolder: 0,
      isPc: true
    };
  },

  computed: {
    ...mapState('template', {
      folders: state => state.folders
    })
  },

  async beforeMount() {
    await this.getTemplates();
  },

  methods: {
    ...mapActions('template', ['getTemplates']),

    backToFolder() {
      this.isPc = false;
    },

    selectTemplate(template) {
      // eslint-disable-next-line no-undef
      const data = _.cloneDeep(template);
      this.$emit('sendTemplate', data);
    },

    changeTemplateFolder(index) {
      this.selectedFolder = index;
      this.isPc = true;
    }
  }
};
</script>