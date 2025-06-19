<template>
  <div class="border rounded">
    <div class="comment-area-box">
      <textarea
        :disabled="!isEnabled"
        rows="4"
        class="form-control border-0 resize-none"
        v-model="message"
        name="message"
        @keydown.enter.shift.exact.prevent
        @keydown.enter.shift.exact="sendTextMessage"
        placeholder="Enterで改行、Shift+Enterで送信"
        data-vv-as="メッセージ"
        maxlength="5001"
      >
      </textarea>
      <error-message :message="messageError" class="ml-2" v-if="messageError" />
      <div class="p-2 bg-light d-flex justify-content-between align-items-center">
        <div>
          <a
            data-toggle="modal"
            data-target="#modalSelectSticker"
            @click="showStickerModal()"
            class="btn btn-sm px-2 btn-light"
            ><i class="uil font-20 uil-smile"></i
          ></a>
          <a data-toggle="modal" data-target="#modalSendMedia" class="btn btn-sm px-2 font-20 btn-light"
            ><i class="uil uil-file"></i
          ></a>
          <div class="btn-group dropup">
            <button
              type="button"
              class="btn btn-sm px-2 btn-light dropdown-toggle"
              data-toggle="dropdown"
              aria-haspopup="true"
              aria-expanded="false"
            >
              <i class="uil-plus font-20"></i>
            </button>
            <div class="dropdown-menu">
              <div role="button" class="dropdown-item" data-toggle="modal" data-target="#modalSendTemplate">
                テンプレート配信
              </div>
              <div class="dropdown-divider"></div>
              <div role="button" class="dropdown-item" data-toggle="modal" data-target="#modalSendScenario">
                シナリオ配信
              </div>
            </div>
          </div>
        </div>
        <button class="btn btn-sm btn-success" @click="sendTextMessage" :disabled="!isEnabled || !message.trim()">
          <i class="uil uil-message mr-1"></i>送信
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useStore } from 'vuex'

const emit = defineEmits(['sendTextMessage', 'resetModalSticker'])

const store = useStore()

const message = ref('')
const messageError = ref('')

const activeChannel = computed(() => store.state.channel.activeChannel)
const isEnabled = computed(() => activeChannel.value)

const clearInput = () => {
  message.value = ''
  messageError.value = ''
}

const sendTextMessage = () => {
  if (message.value.length > 5000) {
    messageError.value = 'メッセージは5000文字以下にしてください。'
    return
  }
  emit('sendTextMessage', message.value)
  clearInput()
}

const showStickerModal = () => {
  if (isEnabled.value) {
    emit('resetModalSticker', true)
  }
}

defineExpose({
  clearInput
})
</script>

<style>
</style>