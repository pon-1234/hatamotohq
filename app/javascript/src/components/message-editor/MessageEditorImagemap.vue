<template>
  <div>
    <div class="form-group">
      <label>代替テキスト<required-mark></required-mark></label>
      <input
        type="text"
        :name="`altText${index}`"
        class="form-control"
        placeholder="代替テキストを入力してください"
        v-model.trim="altText"
        maxlength="401"
        data-vv-as="代替テキスト"
      />
      <error-message :message="errors.first(`altText${index}`)" />
    </div>

    <!--Editor-->
    <div class="d-flex">
      <div class="fw-260">
        <input
          type="text"
          v-model="backgroundUrl"
          :name="'image-url' + index"
          data-vv-as="背景画像"
          class="d-none"
        />
        <imagemap-view
          :background="backgroundUrl"
          :template-id="templateId"
          :class="errors.first('image-url' + index) ? 'fh-260 invalid-box' : 'fh-260'"
          @click="expandAction"
        />
        <error-message :message="errors.first('image-url' + index)" />

        <button
          type="button"
          class="btn-block btn btn-secondary mt-2"
          data-toggle="modal"
          :data-target="`#imagemapTemplateSelectorModal${index}`"
        >
          テンプレートを選択
        </button>
        <button
          type="button"
          class="btn-block btn btn-secondary mt-2"
          data-toggle="modal"
          :data-target="`#imagemapModalUploadImage${index}`"
        >
          背景画像をアップロード
        </button>
        <button type="button" class="btn-block btn btn-secondary mt-2" @click="isShowingEditor = true">
          一式の個別画像を編集
        </button>
      </div>
      <div class="flex-grow-1 ml-4">
        <h5>アクション設定</h5>
        <div id="accordion">
          <div v-for="(item, index) in actionObjects" v-bind:key="index">
            <div
              class="card mb-2"
              :class="errors.items.find((item) => item.field.includes('imagemap_action_' + index)) ? 'invalid-box' : ''"
            >
              <div class="p-2" @click="expandAction(item.key, false, index)">
                <h5 class="m-0">
                  <button type="button" class="btn-block btn-link text-left btn btn-outline-block">
                    <i class="fas mr-2 mdi mdi-chevron-right" style="width: 20px" v-if="!item.expand"></i>
                    <i class="fas mr-2 mdi mdi-chevron-down" style="width: 20px" v-else></i>{{ item.key }}
                  </button>
                </h5>
              </div>
              <div v-show="item.expand">
                <div>
                  <div class="card-body pt-0 accordion-0 center">
                    <div>
                      <action-editor
                        :index="index"
                        :value="item.action"
                        :supports="['', 'message', 'uri', 'survey']"
                        :requiredLabel="false"
                        :showTitle="false"
                        :name="'imagemap_action_' + index"
                        :messageType="'imagemap'"
                        @input="item.action = $event"
                      />
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <imagemap-template-selector
      :id="'imagemapTemplateSelectorModal' + index"
      :selectionId="templateId"
      @accept="templateChange"
    >
    </imagemap-template-selector>

    <modal-select-media
      @select="onSelectMedia"
      :types="['imagemap']"
      :filterable="false"
      :id="`imagemapModalUploadImage${index}`"
    >
    </modal-select-media>

    <modal-rich-menu-image-editor
      v-if="isShowingEditor"
      :templateId="templateId"
      editor="imagemap"
      @close="isShowingEditor = false"
      @input="exportImage"
    ></modal-rich-menu-image-editor>
  </div>
</template>

<script setup>
import { ref, computed, watch, onBeforeMount } from 'vue'
import { useStore } from 'vuex'
import Util from '@/core/util'
import { ActionMessageImageMap, ImageMapBounds } from '@/core/constant'
import ErrorMessage from '../common/ErrorMessage.vue'

const props = defineProps({
  index: Number,
  data: Object
})

const emit = defineEmits(['input'])

const store = useStore()

const rootPath = import.meta.env.VITE_ROOT_PATH
const isShowingEditor = ref(false)
const templateId = ref(props.data.templateId)
const templateValue = ref(props.data.templateValue)
const altText = ref(props.data.altText)
const actionObjects = ref(props.data.actions)
const backgroundUrl = ref(props.data.baseUrl)
const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

const errors = ref({ items: [], first: () => null })

const isSubmitChange = computed(() => store.state.system.isSubmitChange)

onBeforeMount(() => {
  const old = actionObjects.value.length
  const val = templateValue.value

  if (old < val) {
    for (let i = old; i < val; i++) {
      actionObjects.value.push({
        key: alphabet.charAt(i),
        expand: false,
        action: ActionMessageImageMap.default,
        area: ImageMapBounds[templateId.value][i]
      })
    }
  } else if (old > val) {
    actionObjects.value.splice(val, old - val)
  }
})

watch(templateValue, (val, old) => {
  if (old < val) {
    for (let i = old; i < val; i++) {
      actionObjects.value.push({
        key: alphabet.charAt(i),
        expand: false,
        action: ActionMessageImageMap.default,
        area: ImageMapBounds[templateId.value][i]
      })
    }
  } else if (old > val) {
    actionObjects.value.splice(val, old - val)
  }
})

watch(templateId, (val) => {
  actionObjects.value.forEach((action, index) => {
    action.area = ImageMapBounds[val][index]
  })
})

watch(altText, () => {
  publish(actionObjects.value)
})

watch(actionObjects, (val) => {
  publish(val)
}, { deep: true })

watch(isSubmitChange, () => {
  for (const area of actionObjects.value) {
    if (Util.validateAction(area.action)) {
      area.expand = true
    } else {
      area.expand = false
    }
  }
}, { deep: true })

const uploadImageMap = (payload) => store.dispatch('global/uploadImageMap', payload)

const firstWhere = (array, cond) => {
  for (const o of array) {
    if (cond(o)) {
      return o
    }
  }
  return null
}

const expandAction = (key, isAutoCollapse = true, index) => {
  if (isAutoCollapse) {
    actionObjects.value.forEach((value, idx) => {
      if (key === value.key) {
        actionObjects.value[idx].expand = true
      } else {
        actionObjects.value[idx].expand = false
      }
    })
  } else {
    const idx = actionObjects.value.findIndex(val => val.key === key)
    actionObjects.value[idx].expand = !actionObjects.value[idx].expand
  }
}

const changeObjectAction = (key, value) => {
  actionObjects.value[key] = value
}

const templateChange = (data) => {
  templateId.value = data.id
  templateValue.value = data.value
}

const onSelectMedia = (media) => {
  backgroundUrl.value = `${rootPath}/medias/${media.id}/content`
  publish(actionObjects.value)
}

const publish = (actionObject) => {
  const actions = actionObject.map(object => {
    let objectNew = JSON.parse(JSON.stringify(object))
    objectNew = Object.assign(objectNew, objectNew.action)
    return objectNew
  })

  const params = {
    type: 'imagemap',
    baseUrl: backgroundUrl.value,
    templateId: templateId.value,
    templateValue: templateValue.value,
    altText: altText.value,
    baseSize: {
      width: 1040,
      height: 1040
    },
    actions: actions
  }

  emit('input', params)
}

const exportImage = (data) => {
  // remove header
  data = data.replace('data:image/jpeg;base64,', '')
  // upload image
  uploadImageMap({
    file: b64toBlob(data)
  })
    .then(res => {
      backgroundUrl.value = `${rootPath}/medias/${res.id}/content`
      publish(actionObjects.value)
    })
    .catch(err => {
      console.log(err)
    })
}

const b64toBlob = (b64Data, contentType = 'image/jpeg', sliceSize = 512) => {
  const byteCharacters = atob(b64Data)
  const byteArrays = []

  for (let offset = 0; offset < byteCharacters.length; offset += sliceSize) {
    const slice = byteCharacters.slice(offset, offset + sliceSize)

    const byteNumbers = new Array(slice.length)
    for (let i = 0; i < slice.length; i++) {
      byteNumbers[i] = slice.charCodeAt(i)
    }

    const byteArray = new Uint8Array(byteNumbers)
    byteArrays.push(byteArray)
  }

  return new Blob(byteArrays, { type: contentType })
}
</script>

<style lang="scss" scoped>
  .imagemap {
    border: 1px solid #ededed;
    padding: 5px;
    box-sizing: padding-box;
  }

  .btn {
    display: inline-block;
    font-weight: 400;
    text-align: center;
    vertical-align: middle;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    /*border: 1px solid transparent;*/
    padding: 0.375rem 0.75rem;
    line-height: 1.5;
    border-radius: 2px;
    transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out,
      box-shadow 0.15s ease-in-out;
  }

  .card {
    position: relative;
    display: -webkit-box;
    display: flex;
    -webkit-box-orient: vertical;
    -webkit-box-direction: normal;
    flex-direction: column;
    min-width: 0;
    word-wrap: break-word;
    background-color: #fff;
    background-clip: border-box;
    border: 1px solid rgba(0, 0, 0, 0.125);
    border-radius: 4px;
    padding: 5px;
  }

  .card-body {
    -webkit-box-flex: 1;
    flex: 1 1 auto;
    padding: 1.25rem;
  }

  .col-form-label {
    padding-top: calc(0.375rem + 1px);
    padding-bottom: calc(0.375rem + 1px);
    margin-bottom: 0;
    font-size: inherit;
    line-height: 1.5;
  }

  .custom-select {
    display: inline-block;
    width: 100%;
    height: calc(2.15625rem + 2px);
    padding: 0.375rem 1.75rem 0.375rem 0.75rem;
    line-height: 1.5;
    color: #495057;
    vertical-align: middle;
    background: #ebf0fb;
    background-size: 8px 10px;
    border: 1px solid #cfd4da;
    border-radius: 4px !important;
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
  }

  td {
    cursor: pointer;
  }

  table,
  table * {
    border-width: 2px !important;
  }
</style>
