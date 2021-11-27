<template>
  <div
    class="modal fade modal-common01"
    :id="id ? id : 'modalSelectTemplate'"
    tabindex="-1"
    role="dialog"
    aria-labelledby="myModalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog modal-lg vh-90 modal-dialog-scrollable" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">テンプレートを選択してください</h4>
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
              @changeSelectedFolder="changeSelectedFolderTemplate"
            />
            <div class="flex-grow-1 scroll-table">
              <table class="table table-hover">
                <thead class="thead-light">
                  <tr>
                    <th>
                      <span v-if="folders[selectedFolder]">{{ folders[selectedFolder].name }}</span>
                    </th>
                  </tr>
                </thead>
                <tbody v-if="folders[this.selectedFolder].templates && folders[this.selectedFolder].templates.length">
                  <tr v-for="(item, index) in folders[this.selectedFolder].templates" :key="index" class="folder-item">
                    <td class="d-flex w-100">
                      <div class="box-item-name">
                        <p class="m-0 vw-10 item-name">{{ item.name }}</p>
                      </div>
                      <div
                        class="btn btn-info btn-sm ml-auto my-auto"
                        @click="selectTemplate(item)"
                        data-dismiss="modal"
                      >
                        選択
                      </div>
                    </td>
                  </tr>
                </tbody>
                <tbody v-else>
                  <tr>
                    <td class="text-center pt40">データーがありません</td>
                  </tr>
                </tbody>
              </table>
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
  props: ['id'],

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
      this.$emit('selectTemplate', data);
    },

    changeSelectedFolderTemplate(index) {
      this.selectedFolder = index;
      this.isPc = true;
    }
  }
};
</script>
