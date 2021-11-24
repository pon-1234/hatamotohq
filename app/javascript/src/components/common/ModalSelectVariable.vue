<template>
  <div
    class="modal fade"
    :id="id ? id : 'modal-template'"
    tabindex="-1"
    role="dialog"
    aria-labelledby="myModalLabel"
    aria-hidden="true"
    ref="modalSelectVariable"
  >
    <div class="modal-dialog modal-lg vh-90 modal-dialog-scrollable" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">友達情報名を選択してください</h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">×</span>
          </button>
        </div>
        <div class="modal-body overflow-hidden">
          <div class="d-flex">
            <folder-left
              type="variable"
              :isPerview="true"
              :data="folders"
              :selectedFolder="selectedFolderIndex"
              @changeSelectedFolder="changeSelectedFolder"
            ></folder-left>
            <div class="flex-grow-1 scroll-table" :key="contentKey">
              <table class="table">
                <thead class="thead-light">
                  <tr>
                    <th>名称</th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(variable, index) in variables" v-bind:key="index">
                    <td>{{ variable.name }}</td>
                    <td class="fw-120">
                      <div @click="selectVariable(variable)" class="btn btn-sm btn-light" data-dismiss="modal">
                        選択
                      </div>
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
</template>

<script>
import { mapActions } from 'vuex';
export default {
  props: ['id', 'type'],
  data() {
    return {
      contentKey: 0,
      folders: [],
      selectedFolderIndex: 0,
      surveyContents: 0,
      survey: null
    };
  },

  computed: {
    curFolder() {
      return this.folders[this.selectedFolderIndex];
    },

    variables() {
      return this.curFolder ? this.curFolder.variables.filter(_ => _.type === this.type) : [];
    }
  },

  mounted() {
    $(this.$refs.modalSelectVariable).on('show.bs.modal', this.reloadVariables);
  },

  methods: {
    ...mapActions('variable', ['getFolders']),

    forceRerender() {
      this.contentKey++;
    },

    async reloadVariables() {
      this.folders = await this.getFolders({ type: this.type });
    },

    changeSelectedFolder(index) {
      this.selectedFolderIndex = index;
      this.forceRerender();
    },

    selectVariable(variable) {
      console.log(variable, 'survey');
      // eslint-disable-next-line no-undef
      const data = _.cloneDeep(variable);
      this.$emit('selectVariable', data);
    }
  }
};
</script>