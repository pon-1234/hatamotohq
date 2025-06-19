<template>
  <div>
    <div class="border">
      <div v-if="isLoading" style="padding: 20px">
        Loading...
      </div>
      <div v-else class="flex-content" :class="errors.first('flex-template' + index)?'invalid-box':'' ">
        <div v-if="flexMessageHtml == null">
          <a data-toggle="modal"
             :data-target="'#flexMessageModal_'+index"
             class="select-sticker">
            <div class="figure figure-grid-sm my-4 text-center cursor-pointer" >
              <p>Flexメッセージを選択する</p>
              <div class="text-muted opacity-30"><i class="far fa-address-card fa-3x"></i>
              </div>
            </div>
          </a>
        </div>
        <div v-else>
          <div v-html="flexMessageHtml" class="flex-editor-preview"></div>

          <button type="button"
                  class="position-absolute close"
                  style="top: 10px; right: 10px;"
                  @click="removeFlexMessage()"
          >
          <i class="fas fa-times"></i>
          </button>
        </div>
      </div>
    </div>
    <span v-if="errors.first('flex-template' + index)" class="invalid-box-label">Flexメッセージは必須です</span>
    <modal-select-flex-message-template :name="'flexMessageModal_'+index" @input="pickFlexmessage"/>
    <input type="hidden" v-model="flexMessageHtml" :name="'flex-template' + index" />
  </div>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue'
import { useStore } from 'vuex'
import { MessageType } from '@/core/constant'

const props = defineProps({
  data: Object,
  index: Number
})

const emit = defineEmits(['input'])

const store = useStore()

const isLoading = ref(false)
const flexMessageHtml = ref(null)
const errors = ref({ first: () => null })

onMounted(() => {
  if (props.data && props.data.id) {
    fetchFlexMessageLayout(props.data)
  }
})

watch(() => props.data, (val) => {
  if (val && val.id) {
    fetchFlexMessageLayout(val)
  } else {
    flexMessageHtml.value = null
  }
}, { deep: true })

const fetchFlexMessageLayout = (flexMessage) => {
  isLoading.value = true
  store.dispatch('flexMessage/renderFlexMessage', {
    flexMessageId: flexMessage.id
  }).done((html) => {
    flexMessageHtml.value = html
  }).fail(() => {
    flexMessageHtml.value = 'FlexMessage: Fetch error'
  }).always(() => {
    isLoading.value = false
  })
}

const removeFlexMessage = () => {
  emit('input', {
    type: MessageType.Flex,
    contents: null
  })
}

const pickFlexmessage = (flexMessage) => {
  const json = JSON.parse(flexMessage.json_message)
  json.id = flexMessage.id
  emit('input', json)
}
</script>
<style lang="scss" scoped>
  :deep() {
    .flex-editor-preview {
      zoom: 0.6;
      overflow: auto;
      padding: 10px;
      width: auto;
    }
    .flex-editor-preview:hover {
      cursor: col-resize;

    }
    .select-sticker {
      color: #00b900 !important;
      text-decoration: none !important;
      background-color: transparent !important;
    }

    .flex-content {
      position: relative;
      padding: 10px;
      background: #ededed;
    }
    .btn-close {
      position: absolute;
      right: 10px;
      top: 10px;
      border-radius: 30px;
      width: 30px;
      height: 30px;
      background: rgba(255, 87, 34, 0.8);
      color: white;
    }
    .flex-editor {
      border: 0px solid transparent;
    }

    .flex-editor:hover {
      border: 0px solid #0a90eb;
    }
  }
</style>
