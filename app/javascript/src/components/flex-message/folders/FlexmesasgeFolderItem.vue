<template>
  <div @click="changeSelected" :class="getClassName()">
    <div class="d-flex align-items-center" v-if="!isEdit || !active">
      <i :class="active ? 'fas fa-folder-open' : 'fas fa-folder'"></i>
      <span class="title">
        {{ data.name }}
      </span>
      <span> ({{ data.flex_messages_count || 0 }}) </span>
      <div class="dropdown" v-if="active && !disableEditor && index > 0">
        <button
          type="button"
          class="btn dropdown-toggle btn-default action-tags"
          data-toggle="dropdown"
          aria-expanded="false"
        >
          編集<span class="caret"></span>
        </button>
        <ul class="dropdown-menu" role="menu">
          <li role="presentation" @click.stop="changeName"><a role="menuitem" tabindex="-1">名前を変える</a></li>
          <li role="presentation" @click.stop="deleteFolder"><a role="menuitem" tabindex="-1">フォルダーを削除</a></li>
        </ul>
      </div>
    </div>
    <div v-if="isEdit && active">
      <div class="input-group newgroup-inputs">
        <input
          type="text"
          placeholder="フォルダー名"
          class="form-control"
          @click.stop
          :value="data.name"
          ref="folderName"
          @keyup.enter="enterSubmitChangeName"
          @compositionend="compositionend($event)"
          @compositionstart="compositionstart($event)"
        />
        <span class="input-group-btn">
          <button type="button" class="btn btn-default" @click="submitChangeName" ref="buttonChange">決定</button>
        </span>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, computed } from 'vue'

const props = defineProps(['data', 'active', 'index', 'disableEditor'])
const emit = defineEmits(['changeSelected', 'editFolder', 'deleteFolder'])

const isEdit = ref(false)
const isEnter = ref(true)
const folderName = ref(null)
const buttonChange = ref(null)

const getClassName = () => {
  let className = 'folder-item '
  if (props.active) {
    className += 'active'
  }
  return className
}

const changeName = () => {
  isEdit.value = true
}

const changeSelected = () => {
  isEdit.value = false
  emit('changeSelected', { index: props.index, folderId: props.data.id })
}

const submitChangeName = () => {
  if (folderName.value.value !== props.data.name) {
    emit('editFolder', { id: props.data.id, name: folderName.value.value })
  }
}

const enterSubmitChangeName = (e) => {
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

const deleteFolder = () => {
  emit('deleteFolder', props.data)
}
</script>
<style lang="scss" scoped>
  .folder-item {
    cursor: pointer;
    padding: 10px;
  }

  .folder-item span.title {
    width: calc(100% - 110px);
    overflow: hidden;
    text-overflow: ellipsis;
    margin-right: 5px;
    margin-left: 5px;
    flex: 1;
    white-space: nowrap;
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
