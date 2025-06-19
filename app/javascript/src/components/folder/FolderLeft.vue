<template>
  <div class="fw-300">
    <div v-if="!isPerview">
      <div class="btn btn-success" @click="addMoreFolder">
        <i class="uil-plus"></i>
        新しいフォルダー
      </div>
    </div>
    <div class="mt-2" :class="!isPerview ? '' : 'tag-content-preview'">
      <table class="table table-centered mb-0">
        <thead class="thead-light">
          <tr>
            <th scope="col" class="fh-42">フォルダー</th>
          </tr>
        </thead>
      </table>
      <div class="d-flex m-0 overflow-auto flex-column folder-list">
        <div class="folder-item new-folder" v-if="isAddMoreFolder">
          <div class="input-group d-flex">
            <input
              type="text"
              placeholder="フォルダー名"
              class="form-control"
              v-model.trim="folderData.name"
              @click.stop
              ref="folderName"
              @keyup.enter="enterSubmitAddNewFolder"
              @compositionend="compositionend($event)"
              @compositionstart="compositionstart($event)"
              name="folder_name"
              maxlength="33"
            />
            <span class="ml-auto">
              <div class="btn btn-default" @click="submitCreateFolder" ref="buttonChange">決定</div>
            </span>
          </div>
          <error-message :message="errors.first('folder_name')"></error-message>
        </div>

        <folder-left-item
          v-for="(item, index) in data || []"
          :type="type"
          :isPerview="isPerview"
          :data="item"
          :active="selectedFolder == index"
          :index="index"
          :key="index"
          @changeSelected="changeSelectedFolder(index)"
          @editTag="submitUpdateFolder"
        />

        <div class="text-center mt-4" v-if="data.length === 0">データはありません</div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, reactive } from 'vue'

const props = defineProps(['isPc', 'data', 'selectedFolder', 'type', 'isPerview'])
const emit = defineEmits(['changeSelectedFolder', 'submitUpdateFolder', 'submitCreateFolder'])

const isAddMoreFolder = ref(false)
const folderData = reactive({
  type: props.type || '',
  name: null
})
const isEnter = ref(true)
const folderName = ref(null)
const buttonChange = ref(null)
const errors = ref({ first: () => null })

const changeSelectedFolder = (index) => {
  emit('changeSelectedFolder', index)
}

const submitUpdateFolder = (value) => {
  emit('submitUpdateFolder', value)
}

const addMoreFolder = () => {
  isAddMoreFolder.value = !isAddMoreFolder.value
  folderData.name = ''
}

const submitCreateFolder = (e) => {
  // Basic validation
  if (!folderData.name || folderData.name.length > 32) {
    return
  }
  if (folderData.name) {
    emit('submitCreateFolder', folderData)
    isAddMoreFolder.value = false
  }
}

const enterSubmitAddNewFolder = (e) => {
  if (!isEnter.value) {
    isEnter.value = true
    return
  }
  buttonChange.value.click()
}

const compositionend = () => {
  isEnter.value = false
}

const compositionstart = () => {
  isEnter.value = true
}
</script>
<style lang="scss" scoped>
  .folder-list {
    min-height: 70vh;
    background: #f3f3f3;
  }

  .tag-content-preview {
    max-height: 500px !important;
    margin-top: 0px !important;
  }

  .tag-content {
    height: 85vh;
    background-color: #f0f0f0;
    overflow: hidden;
    display: flex;
    flex-direction: column;
  }

  .tag-content-left {
    padding-right: 0px !important;
    padding-left: 0px !important;
  }

  .table-tags-header {
    margin-bottom: 0px !important;
  }

  @media (max-width: 991px) {
    .item-pc {
      display: none !important;
    }

    .tag-scroll {
      overflow: hidden;
    }
  }

  .new-folder {
    background: #fff3a0 !important;
    padding: 10px;
  }
</style>
