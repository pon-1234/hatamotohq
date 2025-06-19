<template>
  <div>
    <div
      class="d-flex align-items-center w-100"
      :class="getClassName"
      v-if="!isEdit || !active"
      @click="changeSelected"
    >
      <span class="d-flex w-100 align-items-center">
        <i :class="active ? 'fas fa-folder-open' : 'fas fa-folder'"></i>
        <span style="vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; overflow: hidden">{{
          data.name
        }}</span
        ><span>({{ childsCount }})</span>

        <div class="dropdown" v-if="active && data.name != '未分類' && !isPerview">
          <div class="btn-group">
            <div
              class="btn btn-light btn-sm dropdown-toggle dropdown-icon"
              data-toggle="dropdown"
              aria-expanded="false"
            >
              編集
            </div>
            <div class="dropdown-menu bg-white" role="menu">
              <a role="button" class="dropdown-item" @click.stop="changeName">名前を変える</a>
              <div class="dropdown-divider" v-if="canDelete(data)"></div>
              <a
                role="button"
                class="dropdown-item"
                data-toggle="modal"
                data-target="#modalDeleteFolder"
                @click="deleteFolder"
                v-if="canDelete(data)"
                >フォルダーを削除</a
              >
            </div>
          </div>
        </div>
      </span>
    </div>
    <div class="d-flex flex-column w-100" :class="getClassName" v-if="isEdit && active">
      <div class="d-flex align-items-center input-group">
        <input
          type="text"
          placeholder="フォルダー名"
          class="form-control"
          v-model.trim="folderName"
          @keyup.enter="enterSubmitChangeName"
          @compositionend="compositionend($event)"
          @compositionstart="compositionstart($event)"
          @click.stop
          maxlength="33"
          name="folder_name"
        />
        <div class="btn btn-light btn-sm ml-auto" @click="submitChangeName" ref="buttonChange">決定</div>
      </div>
      <error-message :message="errors.first('folder_name')" v-if="errors.first('folder_name')"></error-message>
    </div>
  </div>
</template>
<script setup>
import { ref, computed, onMounted } from 'vue'

const props = defineProps(['data', 'active', 'index', 'type', 'isPerview'])
const emit = defineEmits(['changeSelected', 'editTag', 'deleteTag'])

const isEdit = ref(false)
const isEnter = ref(true)
const folderName = ref('')
const buttonChange = ref(null)
const errors = ref({ first: () => null })

onMounted(() => {
  folderName.value = props.data.name
})

const childsCount = computed(() => {
  switch (props.type) {
    case 'tag':
      return props.data.tags.length
    case 'scenario':
      return props.data.scenarios.length
    case 'template_message':
      return props.data.templates.length
    case 'rich_menu':
      return props.data.rich_menus.length
    case 'auto_response':
      return props.data.auto_responses.length
    case 'survey':
      return props.data.surveys.length
    case 'variable':
      return props.data.variables.length
    case 'reminder':
      return props.data.reminders.length
    case 'site':
      return props.data.sites ? props.data.sites.length : 0
    case 'stream_route':
      return props.data.stream_routes ? props.data.stream_routes.length : 0
  }
  return 0
})

const getClassName = computed(() => {
  return 'folder-item ' + (props.active ? 'active' : '')
})

const canDelete = () => {
  return !(
    (props.type === 'survey' && props.data.surveys.length > 0) ||
    (props.type === 'variable' && props.data.variables.length > 0) ||
    (props.type === 'reminder' && props.data.reminders.length > 0)
  )
}

const changeName = () => {
  isEdit.value = true
}

const changeSelected = () => {
  isEdit.value = false
  folderName.value = props.data.name

  emit('changeSelected', { index: props.index, folderId: props.data.id })
}

const submitChangeName = () => {
  // Basic validation
  if (!folderName.value || folderName.value.length > 32) {
    return
  }
  isEdit.value = false
  if (folderName.value !== props.data.name) {
    emit('editTag', { id: props.data.id, name: folderName.value })
  }
}

const enterSubmitChangeName = (e) => {
  if (!isEnter.value) {
    isEnter.value = true
    return
  }
  buttonChange.value.click()
}

const deleteFolder = () => {
  emit('deleteTag')
}

const compositionend = () => {
  isEnter.value = false
}

const compositionstart = () => {
  isEnter.value = true
}
</script>
<style lang="scss" scoped>
  .folder-item {
    display: flex;
    cursor: pointer;
    padding: 10px;
    min-height: 55px !important;
  }
  .active {
    background-color: #e0e0e0;
  }

  .fa-folder {
    color: #fedc67;
  }

  .fa-folder-open {
    color: #f0ad4e;
  }

  .fa-folder::before,
  .fa-folder-open::before {
    margin-right: 5px;

    vertical-align: sub;
  }

  .action-tags {
    padding: 1px 5px;
    .caret {
      margin-left: 2px;
    }
  }

  .dropdown {
    margin-left: auto;
  }

  input {
    height: 36px !important;
  }
</style>
