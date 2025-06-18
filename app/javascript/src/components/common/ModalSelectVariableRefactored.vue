<template>
  <base-modal
    :id="modalId"
    ref="modal"
    title="友達情報名を選択してください"
    size="lg"
    hide-footer
    @show="reloadVariables"
  >
    <div class="d-flex modal-content-height">
      <folder-left
        type="variable"
        :is-preview="true"
        :data="folders"
        :selected-folder="selectedFolderIndex"
        @changeSelectedFolder="changeSelectedFolder"
      />
      <div class="flex-grow-1 scroll-table" :key="contentKey">
        <base-table
          :items="variables"
          :fields="fields"
          :paginate="false"
          :searchable="true"
          search-placeholder="変数名で検索..."
          :search-fields="['name']"
        >
          <template #cell(actions)="{ item }">
            <b-button
              size="sm"
              variant="light"
              @click="selectVariable(item)"
            >
              選択
            </b-button>
          </template>
        </base-table>
      </div>
    </div>
  </base-modal>
</template>

<script>
import { mapActions } from 'vuex';
import BaseModal from '../base/BaseModal.vue';
import BaseTable from '../base/BaseTable.vue';
import FolderLeft from '../folder/FolderLeft.vue';

export default {
  name: 'ModalSelectVariableRefactored',
  components: {
    BaseModal,
    BaseTable,
    FolderLeft
  },
  props: {
    id: {
      type: String,
      default: 'modal-select-variable'
    },
    type: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      contentKey: 0,
      folders: [],
      selectedFolderIndex: 0,
      fields: [
        {
          key: 'name',
          label: '名称',
          sortable: true
        },
        {
          key: 'actions',
          label: '',
          class: 'text-right fw-120'
        }
      ]
    };
  },
  computed: {
    modalId() {
      return this.id || 'modal-select-variable';
    },
    curFolder() {
      return this.folders[this.selectedFolderIndex];
    },
    variables() {
      return this.curFolder 
        ? this.curFolder.variables.filter(v => v.type === this.type) 
        : [];
    }
  },
  methods: {
    ...mapActions('variable', ['getFolders']),

    show() {
      this.$refs.modal.show();
    },

    hide() {
      this.$refs.modal.hide();
    },

    forceRerender() {
      this.contentKey++;
    },

    async reloadVariables() {
      try {
        this.folders = await this.getFolders({ type: this.type });
      } catch (error) {
        console.error('Failed to load variables:', error);
        this.$toast.error('変数の読み込みに失敗しました');
      }
    },

    changeSelectedFolder(index) {
      this.selectedFolderIndex = index;
      this.forceRerender();
    },

    selectVariable(variable) {
      const data = JSON.parse(JSON.stringify(variable)); // Deep clone without lodash
      this.$emit('select-variable', data);
      this.hide();
    }
  }
};
</script>

<style scoped>
.modal-content-height {
  min-height: 400px;
}

.scroll-table {
  overflow-y: auto;
  max-height: 500px;
}

.fw-120 {
  width: 120px;
}

:deep(.table) {
  margin-bottom: 0;
}
</style>