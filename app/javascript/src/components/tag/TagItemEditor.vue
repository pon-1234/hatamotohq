<template>
  <div>
    <div class="d-flex align-items-center" v-if="!isEdit">
      <span class="flex-grow-1">
        {{ data.name }}
      </span>
      <div class="btn-group flex-1">
        <button type="button" class="btn btn-light btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
          操作 <span class="caret"></span>
        </button>
        <div class="dropdown-menu" role="menu" style="">
          <a class="dropdown-item" @click="changeName">タグ名を変える</a>
          <div class="dropdown-divider"></div>
          <a class="dropdown-item" @click="deleteFolder" data-toggle="modal" data-target="#modalConfirmDelTag"
            >タグを削除</a
          >
        </div>
      </div>
    </div>
    <div v-if="isEdit">
      <div class="input-group newgroup-inputs">
        <input
          type="text"
          placeholder="タグ名"
          class="form-control"
          @click.stop
          v-model.trim="tagName"
          @keyup.enter="enterSubmitChangeName"
          @compositionend="compositionend($event)"
          @compositionstart="compositionstart($event)"
          name="tag_name"
          data-vv-as="タグ名"
          maxlength="33"
          :class="{ 'is-invalid': tagName && tagName.length > 32 }"
        />
        <span class="input-group-btn">
          <button type="button" class="btn btn-light" @click="submitChangeName" ref="buttonChange">決定</button>
        </span>
      </div>
      <error-message :message="tagName && tagName.length > 32 ? 'タグ名は32文字以内で入力してください' : (!tagName && isEdit ? 'タグ名を入力してください' : null)"></error-message>
    </div>
  </div>
</template>
<script setup>
import { ref, watch, onMounted } from 'vue'

const props = defineProps(['data'])
const emit = defineEmits(['editTag', 'deleteTag'])

const isEdit = ref(false)
const isEnter = ref(true)
const tagName = ref(null)
const buttonChange = ref(null)
const errors = ref({ first: () => null })

watch(() => props.data, (val) => {
  tagName.value = val.name
  isEdit.value = false
})

onMounted(() => {
  tagName.value = props.data.name
})

const changeName = () => {
  isEdit.value = true
}

const submitChangeName = async () => {
  // Simple validation check
  if (!tagName.value || tagName.value.length > 32) {
    return
  }
  if (tagName.value !== props.data.name) {
    emit('editTag', { id: props.data.id, name: tagName.value })
  }

  isEdit.value = false
}

const deleteFolder = () => {
  emit('deleteTag', props.data)
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
</script>
<style lang="scss" scoped>
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
    color: white;
    .caret {
      margin-left: 2px;
    }
  }

  input {
    height: 36px !important;
  }
</style>
