<template>
  <div
    class="card upload-container my-auto d-flex flex-column"
    @drop.prevent="addMedia($event, 'drop')"
    @dragover.prevent
  >
    <div
      class="card-body flex-grow-1 d-flex flex-column justify-content-center align-items-center position-relative"
      @drop.prevent="addFile"
      @dragover.prevent
    >
      <div class="text-center my-auto" v-if="isPreview">
        <button class="btn-delete-media" @click="deleteMedia()"><span class="close">×</span></button>
        <img class="fw-120 fh-120" v-if="mediaData.type === 'pdf'" :src="fileURL" />
        <img
          v-if="mediaData.type === 'image' || mediaData.type === 'richmenu' || mediaData.type === 'imagemap'"
          :src="fileURL"
        />
        <audio controls v-if="mediaData.type === 'audio'" @loadedmetadata="onTimeUpdate" ref="audio">
          <source :src="fileURL" />
        </audio>
        <video v-else-if="mediaData.type === 'video'" width="320" height="240" controls autoplay>
          <source :src="fileURL" type="video/mp4" />
        </video>
      </div>
      <div class="text-center text-md my-auto" v-else>
        <p>
          <label>ここにファイルをドラッグ＆ドロップ<br />または</label>
        </p>
        <div class="custom-file fw-200">
          <div class="custom-file-input h-100 w-100">
            <input
              class="fh-50"
              :accept="getAcceptedMineTypes()"
              :maxsize="getMaxSize()"
              type="file"
              ref="file"
              @change="addMedia($event, 'input')"
            />
          </div>
          <label class="custom-file-label text-left">ファイルを選択</label>
        </div>
        <span v-if="errorMessage" class="w-100 error">{{ errorMessage }}</span>
        <media-upload-hint class="m-4" :type="uploadRequiredType"></media-upload-hint>
      </div>

      <div class="text-right w-100 mt-auto">
        <button v-if="isPreview" class="btn btn-info fw-120" @click="handleUpload">確認する</button>
      </div>
    </div>
    <loading-indicator :loading="loading"></loading-indicator>
  </div>
</template>
<script setup>
import { ref, computed, watch } from 'vue'
import { useStore } from 'vuex'
import Media from '@/core/media'

const props = defineProps({
  types: {
    type: Array,
    default: () => ['image', 'audio', 'video']
  }
})

const emit = defineEmits(['upload'])
const store = useStore()

const loading = ref(false)
const mediaData = ref({
  type: null,
  originalContentUrl: '',
  previewImageUrl: ''
})
const errorMessage = ref('')
const description = ref('')
const isPreview = ref(false)
const input = ref(null)
const fileURL = ref('')
const inputFile = ref(null)
const duration = ref(null)
const oldType = ref(null)
const audio = ref(null)
const file = ref(null)

const isChannel = computed(() => props.types.length > 1)
const uploadRequiredType = computed(() => {
  if (isChannel.value) return null
  return props.types[0]
})

const ImageRichMenuSize = ['2500x1686', '2500x843', '1200x810', '1200x405', '800x540', '800x270']
const ImageImageMapSize = ['1040', '700', '460', '300', '240']

watch(() => props.types, (val) => {
  mediaData.value.type = val[0]
  oldType.value = val[0]
}, { immediate: true })

const getMaxSize = () => {
  return Media.getMaxSizeByType(mediaData.value.type)
}

const getAcceptedMineTypes = () => {
  return Media.getAcceptedMineTypes(props.types)
}

const addFile = (event) => {
  addMedia(event)
}

const addMedia = async (event, status) => {
  const inputData = status === 'input' ? event.currentTarget.files[0] : event.dataTransfer.files[0]
  isPreview.value = false
  inputFile.value = inputData
  const mediaType = Media.convertMineTypeToMediaType(inputData.type)
  if (mediaType === 'image' && !isChannel.value) {
    if (props.types.includes('richmenu')) mediaData.value.type = 'richmenu'
    else if (props.types.includes('imagemap')) mediaData.value.type = 'imagemap'
    else mediaData.value.type = 'image'
  } else {
    mediaData.value.type = mediaType
  }
  if (inputData.type === 'video/mp4' && oldType.value && mediaType !== oldType.value) mediaData.value.type = oldType.value
  const validationResult = Media.validateFileSizeByType(mediaData.value.type, inputData.size)
  // set default type if file cannot be read error
  if (!mediaData.value.type || !validationResult.valid) mediaData.value.type = oldType.value

  if (!validationResult) return

  if (!validationResult.valid) {
    errorMessage.value = validationResult.message
    return
  }

  const reader = new FileReader()
  reader.readAsArrayBuffer(inputData)
  reader.onload = async function(e) {
    const mimetype = props.types.includes(mediaData.value.type) ? mediaData.value.type : oldType.value
    const validMimeBytes = await Media.validateFileByMimeBytes(
      e,
      mimetype,
      (window.URL || window.webkitURL).createObjectURL(inputData),
      inputData.type
    )
    // check the valid first 4 bytes of the header
    if (!validMimeBytes.valid) {
      errorMessage.value = validMimeBytes.message
      mediaData.value.type = oldType.value
      return
    }

    // Generate preview
    if (mediaData.value.type === 'image') {
      generateImagePreview(inputData)
    } else if (mediaData.value.type === 'video') {
      generateVideoPreview(inputData)
    } else if (mediaData.value.type === 'pdf') {
      generatePdfPreview(inputData)
    } else if (mediaData.value.type === 'audio') {
      generateAudioPreview(inputData)
    } else if (mediaData.value.type === 'richmenu') {
      generateRichMenuPreview(inputData)
    } else if (mediaData.value.type === 'imagemap') {
      generateImageMapPreview(inputData)
    }
  }
  errorMessage.value = ''
  // Clear file input data

  if (status === 'input') event.target.value = ''
}

const generateImagePreview = (inputData) => {
  const reader = new FileReader()
  reader.readAsDataURL(inputData)
  reader.onload = function(e) {
    fileURL.value = e.target.result
    isPreview.value = true
  }
}

const generateVideoPreview = (inputData) => {
  fileURL.value = URL.createObjectURL(inputData)
  isPreview.value = true
}

const generatePdfPreview = (inputData) => {
  fileURL.value = '/img/pdf_temp.png'
  isPreview.value = true
}

const generateAudioPreview = (inputData) => {
  fileURL.value = URL.createObjectURL(inputData)
  isPreview.value = true
}

const generateRichMenuPreview = (inputData) => {
  const reader = new FileReader()
  reader.readAsDataURL(inputData)
  reader.onload = function(e) {
    const img = new Image()
    img.onload = function() {
      const size = `${this.width}x${this.height}`
      if (ImageRichMenuSize.includes(size)) {
        fileURL.value = e.target.result
        isPreview.value = true
      } else {
        isPreview.value = false
        errorMessage.value = '指定されたサイズの画像をアップロードしてください。'
      }
    }
    img.src = e.target.result
  }
}

const generateImageMapPreview = (inputData) => {
  const reader = new FileReader()
  reader.readAsDataURL(inputData)
  reader.onload = function(e) {
    const img = new Image()
    img.onload = function() {
      const size = `${this.width}`
      if (ImageImageMapSize.includes(size)) {
        fileURL.value = e.target.result
        isPreview.value = true
      } else {
        isPreview.value = false
        errorMessage.value = '指定されたサイズの画像をアップロードしてください。'
      }
    }
    img.src = e.target.result
  }
}

const handleUpload = async () => {
  loading.value = true

  const query = {
    file: inputFile.value,
    type: mediaData.value.type
  }

  if (mediaData.value.type === 'audio') {
    query.duration = duration.value
  }

  let response = null
  if (mediaData.value.type === 'imagemap') {
    response = await store.dispatch('media/uploadImageMap', inputFile.value)
  } else if (mediaData.value.type === 'richmenu') {
    response = await store.dispatch('media/uploadRichMenu', inputFile.value)
  } else {
    response = await store.dispatch('media/uploadMedia', query)
  }

  if (response.url) {
    const pickedData = ['id', 'type', 'url', 'preview_url', 'duration'].reduce((acc, key) => {
      if (response[key] !== undefined) acc[key] = response[key]
      return acc
    }, {})
    mediaData.value = pickedData
    emit('upload', mediaData.value)
  }
  errorMessage.value = null
  deleteMedia()
  loading.value = false
}

const getDuration = (media) => {
  return media.duration ? Media.getDuration(media) : '00:00'
}

const deleteMedia = () => {
  isPreview.value = false
  errorMessage.value = ''
  if (isChannel.value) {
    mediaData.value.type = null
  }
}

const onTimeUpdate = () => {
  duration.value = audio.value.duration * 1000
}
</script>

<style lang="scss" scoped>
  .upload-container {
    min-height: 500px;
  }

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

    .btn-delete-media {
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
    #preview-file {
      width: 100px;
      height: 100px;
    }
  }
</style>