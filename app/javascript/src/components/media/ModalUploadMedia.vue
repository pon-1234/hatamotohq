<template>
  <div
    class="modal fade"
    id="modalSelectMedia"
    tabindex="-1"
    role="dialog"
    aria-labelledby="myModalLabel"
    aria-hidden="true"
    ref="modalUploadMedia"
    :key="contentKey"
  >
    <div class="modal-dialog modal-xl" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">
            <label>アップロードする</label>
          </h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close" ref="close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body overflow-hidden position-relative">
          <media-upload ref="mediaUpload" :types="types" @upload="onUploadFinished(event)"></media-upload>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'

const props = defineProps({
  types: {
    type: Array,
    default: () => ['image']
  }
})

const emit = defineEmits(['upload'])

const contentKey = ref(0)
const modalUploadMedia = ref(null)
const close = ref(null)
const mediaUpload = ref(null)

const onUploadFinished = (event) => {
  emit('upload', event)
  close.value.click()
}

const shownModal = () => {
  mediaUpload.value?.deleteMedia()
}

onMounted(() => {
  $(modalUploadMedia.value).on('show.bs.modal', shownModal)
})
</script>

<style  lang="scss"  scoped>
  :deep() {
    .custom-file {
      position: relative;
      display: inline-block;
      height: 40px;
      margin-bottom: 0;
    }

    .h-100 {
      height: 100% !important;
    }

    .w-100 {
      width: 100% !important;
    }

    input {
      overflow: visible;
    }

    .custom-file-input {
      position: relative;
      z-index: 2;
      margin: 0;
      opacity: 0;
    }

    .custom-file-label {
      position: absolute;
      top: 0;
      right: 0;
      left: 0;
      z-index: 1;
      height: 40px;
      color: #495057;
      background-color: #fff;
      border: 1px solid #cfd4da;
      border-radius: 2px;
      display: flex;
      align-items: center;
      padding-left: 10px;
      font-weight: 200;
      font-size: 15px;
    }

    .custom-file-label::after {
      position: absolute;
      top: 0;
      right: 0;
      bottom: 0;
      z-index: 3;
      display: flex;
      align-items: center;
      height: 38px;
      color: #495057;
      content: "+";
      background-color: #f8f9fa;
      border-left: 1px solid #cfd4da;
      border-radius: 0 2px 2px 0;
      padding-left: 10px;
      padding-right: 10px;
    }

    .text-muted {
      color: #adb5bd !important;
      display: block;
      font-size: 10px;
    }

    .text-center {
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
    }

    .error {
      color: red;
    }

    .btn-delete-image {
      top: 9px;
      right: 8px;
      position: absolute;
      border: none;
    }

    .text-center img {
      max-width: 100%;
      height: 350px;
      object-fit: contain;
    }

  }
</style>
