<template>
  <BaseModal
    :id="name"
    title="Flexメッセージを選択"
    size="lg"
    hide-footer
    modal-class="modal-template modal-common01"
    ref="modalRef"
  >
    <div class="tag-list">
      <div class="row">
        <div class="col-md-4 tag-content-left p-0">
          <div class="tag-content">
            <div class="folder-list-title">
              <table class="table table-tags-header">
                <thead class="thead-light">
                  <tr>
                    <th scope="col" class="header-title">フォルダー</th>
                    <th scope="col" style="text-align: right"></th>
                  </tr>
                </thead>
              </table>
            </div>
            <div class="tag-scroll folder-list">
              <div class="folder-item new-folder" v-if="isAddMoreFolder">
                <div class="input-group newgroup-inputs">
                  <input
                    type="text"
                    placeholder="フォルダー名"
                    v-model.trim="folderForm.name"
                    class="form-control"
                  />
                  <span class="input-group-btn"></span>
                </div>
              </div>
              <div v-if="loading.folderLoading">Loading...</div>
              <flexmesasge-folder-item
                v-else
                v-for="(item, index) in folderLists"
                :key="index"
                :data="item"
                :active="folderId == item.id"
                :disable-editor="true"
                :index="index"
                @change-selected="handleFolderChange"
              />
            </div>
          </div>
        </div>
        <div class="col-md-8 tag-content-right" :class="currentFolder !== null ? 'show' : ''">
          <div class="tag-content" style="background: rgb(249, 249, 249)">
            <table class="table table-tags-header" v-if="currentFolder !== null">
              <thead class="thead-light">
                <tr>
                  <th class="hidden-pc">
                    <i class="mdi mdi-arrow-left" @click="backToFolder"></i>
                  </th>
                  <th class="header-title folder-title">
                    {{ currentFolder.name || "" }}
                  </th>
                </tr>
              </thead>
            </table>

            <div class="tag-scroll tag-list">
              <div v-if="loading.flexMessageLoading">Loading...</div>
              <table class="table" style="max-width: initial !important" v-else>
                <tbody>
                  <template v-if="flexMessageList && flexMessageList.length">
                    <template v-for="(item, index) in flexMessageList" :key="index">
                      <tr style="display: flex">
                        <td class="flex-item">
                          <span>{{ item.name }}</span>
                        </td>
                        <td style="text-align: right; width: auto">
                          <button
                            @click="togglePreview(item)"
                            class="btn-more btn-more-linebot btn-block cursor-pointer"
                            type="button"
                          >
                            プレビュー
                          </button>
                          <button
                            class="btn-more btn-more-linebot btn-block cursor-pointer"
                            @click="pickFlexMessage(item)"
                            type="button"
                          >
                            選択
                          </button>
                        </td>
                      </tr>
                      <tr
                        v-if="item === currentFlexMessage"
                        style="background: #ededed"
                        :key="`${index}_preview`"
                      >
                        <td colspan="2">
                          <div v-html="item.html_template" style="zoom: 0.6"></div>
                        </td>
                      </tr>
                    </template>
                  </template>
                  <tr v-else>
                    <td colspan="2" class="text-center pt-5">データーがありません</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>

      <flexmessage-modal-preview
        :id="'flexMessagePreview'"
        :model="currentFlexMessage"
        v-if="currentFlexMessage != null"
      />
    </div>
  </BaseModal>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue';
import { useStore } from 'vuex';
import BaseModal from '../base/BaseModal.vue';
import FlexmesasgeFolderItem from '../flexmessage/FlexmesasgeFolderItem.vue';
import FlexmessageModalPreview from '../flexmessage/FlexmessageModalPreview.vue';

// Props
const props = defineProps({
  name: {
    type: String,
    required: true
  },
  folderId: {
    type: [String, Number],
    default: null
  }
});

// Emits
const emit = defineEmits(['input']);

// Store
const store = useStore();

// Refs
const modalRef = ref(null);

// State
const isAddMoreFolder = ref(false);
const folderId = ref(props.folderId);
const currentFolder = ref(null);
const currentFlexMessage = ref(null);
const folderForm = ref({
  name: ''
});
const loading = ref({
  folderLoading: false,
  flexMessageLoading: false
});
const folderLists = ref([]);
const flexMessageList = ref([]);

// Methods
const backToFolder = () => {
  currentFolder.value = null;
};

const handleFolderChange = (event) => {
  folderId.value = event.folderId;
};

const togglePreview = (item) => {
  currentFlexMessage.value = currentFlexMessage.value === item ? null : item;
};

const folderFlexMessages = async (id, isLoading = true) => {
  currentFolder.value = folderLists.value.find(folder => folder.id === id);
  if (currentFolder.value) {
    folderId.value = id;
  }

  loading.value.flexMessageLoading = isLoading;
  try {
    const res = await store.dispatch('flexMessage/folderFlexMessages', {
      folderId: id
    });
    flexMessageList.value = res;
  } catch (error) {
    console.error('Failed to load flex messages:', error);
  } finally {
    loading.value.flexMessageLoading = false;
  }
};

const indexFolders = async (isLoading = true) => {
  loading.value.folderLoading = isLoading;
  try {
    const res = await store.dispatch('flexMessage/indexFolders');
    folderLists.value = res;
    if (folderId.value && folderId.value > 0) {
      await folderFlexMessages(folderId.value, isLoading);
    } else if (folderLists.value.length > 0) {
      folderId.value = folderLists.value[0].id;
    }
  } catch (error) {
    console.error('Failed to load folders:', error);
  } finally {
    loading.value.folderLoading = false;
  }
};

const pickFlexMessage = (item) => {
  emit('input', item);
  modalRef.value?.hide();
};

const show = () => {
  modalRef.value?.show();
};

const hide = () => {
  modalRef.value?.hide();
};

// Watch
watch(folderId, (val) => {
  if (val && val > 0) {
    folderFlexMessages(val);
  }
});

// Lifecycle
onMounted(() => {
  indexFolders();
});

// Expose methods for parent component access
defineExpose({
  show,
  hide
});
</script>

<style lang="scss" scoped>
.pt-5 {
  padding-top: 3rem !important;
}

.row {
  display: flex;
  flex-wrap: wrap;
  margin-right: -15px;
  margin-left: -15px;
}

::v-deep {
  .modal-common01.fade .modal-dialog {
    -webkit-transform: translateY(-50%);
    transform: translateY(-50%);
  }

  .sample-item {
    width: 30%;
    margin-bottom: 20px;
    cursor: pointer;
    display: inline-block;
  }
  .label {
    color: #1b1b1b;
  }

  .modal-dialog {
    top: 0 !important;
    margin: auto;
    transform: translateY(0) !important;
    padding: 80px !important;
    max-width: 1000px;
  }
  .flex-item {
    flex: 1;
    max-width: 400px;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
    line-height: 2em;
  }
  @media (max-width: 1000px) {
    .flex-item {
      max-width: 700px;
    }

    .tag-content {
      height: 70vh !important;
    }
    .sample-item {
      width: 40%;
    }
    .modal-dialog {
      margin: auto;
      padding: 80px 20px !important;
    }
  }
  @media (max-width: 768px) {
    .flex-item {
      flex: 1;
      max-width: 500px;
      overflow: hidden;
      white-space: nowrap;
      text-overflow: ellipsis;
      line-height: 2em;
    }

    .tag-content {
      height: 45vh !important;
    }
    .modal-dialog {
      padding: 40px 0 !important;

      position: relative;
      width: auto;
      margin: auto;
      max-width: 95%;
    }
  }
}

.btn-block {
  display: inline-block;
  width: auto;
  font-size: 13px;
  padding: 7px;
}

.header-title {
  font-size: 19px;
  flex: 1;
  text-overflow: ellipsis;
  overflow: hidden;
}

.tag-list {
  position: relative;
}

.tag-header {
  color: white;
}

.tag-content {
  height: 70vh;
  background-color: #f0f0f0;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  .tag-scroll {
    height: 100%;
    overflow-x: auto;
    overflow-y: auto;
    margin: 0 0;
    display: flex;
    flex-direction: column;
  }
}

.tag-content-left {
  padding-right: 0px !important;
  min-width: 250px;
}

.tag-content-right {
  max-width: calc(100% - 250px);
}

.thead-light {
  width: 100%;
}

.table-tags-header {
  margin-bottom: 0px !important;
  min-height: 47px;
  display: flex;
  max-width: initial !important;
  margin-top: 0px !important;
}

.table-tags-header tr {
  display: flex;
  vertical-align: middle;
}

.item-sm {
  display: none;
}

.folder-list {
  min-width: 200px;
}

.hidden-pc {
  display: none;
}

.new-folder {
  background: #fff3a0 !important;
  padding: 10px;
}

.tag-item {
  background: white;
}

.show {
  display: initial;
}

@media (max-width: 991px) {
  .hidden-pc {
    display: initial;
    width: auto;
    line-height: 2em;
  }

  .item-pc {
    display: none !important;
  }

  .item-sm {
    display: inline-block !important;
  }

  .fa-arrow-left {
    margin-right: 10px;
    cursor: pointer;
    line-height: 1.9em;
  }

  .tag-content-left {
    /*padding-right: 15px !important;*/
    min-width: initial;
  }

  .tag-content-right {
    display: none;
    max-width: initial;
    position: absolute;
    z-index: 1;
    top: 0;
    right: 0;
    left: 0;
    bottom: 0;
    .tag-scroll {
      padding-left: 10px;
      padding-right: 10px;
    }
  }
}

.btn-sm {
  font-size: 12px !important;
  padding: 5px 8px;
  color: white;
}

::v-deep {
  .modal-common01.fade .modal-dialog {
    -webkit-transform: translateY(-50%);
    transform: translateY(-50%);
  }

  .folder-title {
    white-space: nowrap;
    width: 20%;
  }

  .flex-editor {
    border: 0px solid transparent;
  }

  .flex-editor:hover {
    border: 0px solid #0a90eb;
  }
}

.tag-scroll {
  table {
    margin-top: 0px !important;
  }
}

.cursor-pointer {
  cursor: pointer;
}

.btn-more {
  background: none;
  border: 1px solid #ccc;
  color: #333;
  text-decoration: none;
}

.btn-more:hover {
  background-color: #f5f5f5;
}

.btn-more-linebot {
  margin: 2px;
}
</style>
