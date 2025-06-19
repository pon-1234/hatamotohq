<template>
    <div class="form-group clearfix">
        <label class="col-sm-3">画像</label>
        <div class="col-sm-9 border-bottom">
            <img style="width: 150px; margin-bottom: 10px; height: 150px; object-fit: contain"
                :src="url"
                v-if="url"
            >
            <div>
              <input type="hidden" v-model="url">
              <button type="button" class="btn btn-upload"
                  @click="openAddFileModal()">
                  <i class="fa fa-upload"></i> ファイルをアップロード
              </button>
              <button type="button" class="btn btn-cancel"
                  @click="removeImage()">
                  <i class="fa fa-trash"></i> Remove
              </button>
            </div>
        </div>
        <media-modal :data="media_data" :id="name" @input="uploadedImg"/>
    </div>
</template>
<script setup>
import { ref, watch } from 'vue'
import { MessageType } from '@/core/constant'

const props = defineProps({
  data: {
    type: String,
    default: null
  },
  name: {
    type: String,
    required: true
  }
})

const emit = defineEmits(['input'])

const url = ref(props.data || null)
const media_data = ref({
  type: MessageType.Image,
  originalContentUrl: props.data || '',
  previewImageUrl: ''
})

// Watch for changes in props.data
watch(() => props.data, (newValue) => {
  url.value = newValue
  media_data.value.originalContentUrl = newValue || ''
})

const openAddFileModal = () => {
  $('#' + props.name).modal('show')
}

const uploadedImg = (value) => {
  console.log(value)
  url.value = value.originalContentUrl
  emit('input', value.originalContentUrl)
}

const removeImage = () => {
  url.value = null
  media_data.value.originalContentUrl = null
  emit('input', media_data.value.originalContentUrl)
}
</script>

<style scoped>
    .btn-upload {
        color: #ea5516;
        background: #fff;
        border: 1px solid #ccc;
    }
</style>
