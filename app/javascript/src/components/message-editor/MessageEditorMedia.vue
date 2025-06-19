<template>
  <div>
    <div class="d-flex align-items-center border" v-if="data.originalContentUrl">
      <div class="my-4 ml-2">
        <media-preview :type="data.type" :src="data.originalContentUrl"></media-preview>
      </div>
      <div role="button" class="btn btn-sm btn-danger ml-2" @click="removeMedia">削除</div>
    </div>

    <div v-else>
      <div class="border text-center" :class="errors.first('media-template' + index) ? 'invalid-box' : ''">
        <div class="figure figure-grid-sm my-4">
          <a href="#" class="text-primary" data-toggle="modal" data-target="#modalSelectMedia">
            <span v-if="data.type === 'image'">写真をアップロード</span>
            <span v-else-if="data.type === 'video'">動画をアップロード</span>
            <span v-else-if="data.type === 'audio'">ボイスメッセージをアップロード</span>
          </a>
          <div class="text-muted opacity-30">
            <i v-if="data.type === 'image'" class="mdi mdi-image mdi-3x"></i>
            <i v-else-if="data.type === 'video'" class="mdi mdi-video mdi-3x"></i>
            <i v-else-if="data.type === 'audio'" class="mdi mdi-voice mdi-3x"></i>
          </div>
        </div>
      </div>
      <error-message :message="errors.first('media-template' + index)" />
      <modal-select-media :types="[data.type]" @select="addMedia($event)"></modal-select-media>
    </div>
    <input
      type="hidden"
      v-model="data.originalContentUrl"
      :name="'media-template' + index"
      data-vv-as="ファイル"
    />
  </div>
</template>
<script setup>
import { ref } from 'vue'
import Util from '@/core/util'

const props = defineProps({
  data: {
    type: Object,
    required: true
  },
  index: Number
})

const emit = defineEmits(['input'])

const errors = ref({ first: () => null })

const removeMedia = () => {
  props.data.originalContentUrl = ''

  if (props.data.type === 'image' || props.data.type === 'video') {
    props.data.previewImageUrl = ''
  }

  if (props.data.type === 'audio') {
    props.data.duration = ''
  }

  emit('input', props.data)
}

const addMedia = (media) => {
  const messageData = {
    type: media.type,
    originalContentUrl: media.url,
    previewImageUrl: media.preview_url,
    duration: media.duration
  }
  emit('input', messageData)
}

const getDuration = () => {
  return Util.getDuration(props.data)
}
</script>

<style lang="scss" scoped>
  .btn-close {
    top: -50px;
    right: -50px;
  }
</style>