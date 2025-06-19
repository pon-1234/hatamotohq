<template>
  <div>
    <div class="editor-content">
      <div style="display: flex; flex-direction: column; background: rgb(245, 245, 245); max-width: 300px">
        <div class="line-nav-bar">
          <p>プレビュー</p>
        </div>
        <div
          v-if="editor === 'richmenu'"
          style="height: 400px !important"
          class="d-flex flex-column justify-content-center"
        >
          <table v-if="templateId === 201" style="width: 300px; height: 200px">
            <tbody>
              <tr>
                <td style="width: 100px">
                  <div
                    class="preview-area active"
                    :id="objectLists[0].name"
                    @click="chooseActive(0)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[0].name" />
                  </div>
                </td>
                <td style="width: 100px">
                  <div
                    class="preview-area"
                    :id="objectLists[1].name"
                    @click="chooseActive(1)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[1].name" />
                  </div>
                </td>
                <td style="width: 100px">
                  <div
                    class="preview-area"
                    :id="objectLists[2].name"
                    @click="chooseActive(2)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[2].name" />
                  </div>
                </td>
              </tr>
              <tr>
                <td style="width: 100px">
                  <div class="preview-area" :id="objectLists[3].name" @click="chooseActive(3)">
                    <img :id="'preview_' + objectLists[3].name" />
                  </div>
                </td>
                <td style="width: 100px">
                  <div class="preview-area" :id="objectLists[4].name" @click="chooseActive(4)">
                    <img :id="'preview_' + objectLists[4].name" />
                  </div>
                </td>
                <td style="width: 100px">
                  <div class="preview-area" :id="objectLists[5].name" @click="chooseActive(5)">
                    <img :id="'preview_' + objectLists[5].name" />
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
          <table v-if="templateId === 202" style="width: 300px">
            <tbody>
              <tr>
                <td style="width: 150px">
                  <div
                    class="preview-area active"
                    :id="objectLists[0].name"
                    @click="chooseActive(0)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[0].name" />
                  </div>
                </td>
                <td style="width: 150px">
                  <div
                    class="preview-area"
                    :id="objectLists[1].name"
                    @click="chooseActive(1)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[1].name" />
                  </div>
                </td>
              </tr>
              <tr>
                <td style="width: 150px">
                  <div
                    class="preview-area"
                    :id="objectLists[2].name"
                    @click="chooseActive(2)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[2].name" />
                  </div>
                </td>
                <td style="width: 150px">
                  <div class="preview-area" :id="objectLists[3].name" @click="chooseActive(3)">
                    <img :id="'preview_' + objectLists[3].name" />
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
          <table v-if="templateId === 203" style="width: 300px">
            <tbody>
              <tr>
                <td colspan="3" style="width: 300px">
                  <div
                    class="preview-area active"
                    :id="objectLists[0].name"
                    @click="chooseActive(0)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[0].name" />
                  </div>
                </td>
              </tr>
              <tr>
                <td style="width: 100px">
                  <div class="preview-area" :id="objectLists[1].name" @click="chooseActive(1)">
                    <img :id="'preview_' + objectLists[1].name" />
                  </div>
                </td>
                <td style="width: 100px">
                  <div class="preview-area" :id="objectLists[2].name" @click="chooseActive(2)">
                    <img :id="'preview_' + objectLists[2].name" />
                  </div>
                </td>
                <td style="width: 100px">
                  <div class="preview-area" :id="objectLists[3].name" @click="chooseActive(3)">
                    <img :id="'preview_' + objectLists[3].name" />
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
          <table v-if="templateId === 204" style="width: 300px">
            <tbody>
              <tr>
                <td style="width: 200px; height: 100%" rowspan="2">
                  <div
                    class="preview-area active"
                    :id="objectLists[0].name"
                    @click="chooseActive(0)"
                    style="width: 100%; height: 100%"
                  >
                    <img :id="'preview_' + objectLists[0].name" />
                  </div>
                </td>
                <td style="width: 100px">
                  <div
                    class="preview-area"
                    :id="objectLists[1].name"
                    @click="chooseActive(1)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[1].name" />
                  </div>
                </td>
              </tr>
              <tr>
                <td style="width: 100px">
                  <div
                    class="preview-area"
                    :id="objectLists[2].name"
                    @click="chooseActive(2)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[2].name" />
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
          <table v-if="templateId === 205" style="width: 300px">
            <tbody>
              <tr>
                <td style="width: 300px">
                  <div
                    class="preview-area active"
                    :id="objectLists[0].name"
                    @click="chooseActive(0)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[0].name" />
                  </div>
                </td>
              </tr>
              <tr>
                <td style="width: 300px">
                  <div
                    class="preview-area"
                    :id="objectLists[1].name"
                    @click="chooseActive(1)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[1].name" />
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
          <table v-if="templateId === 206" style="width: 300px">
            <tbody>
              <tr>
                <td style="width: 150px; height: 200px" rowspan="2">
                  <div
                    class="preview-area active"
                    :id="objectLists[0].name"
                    @click="chooseActive(0)"
                    style="width: 100%; height: 100%"
                  >
                    <img :id="'preview_' + objectLists[0].name" />
                  </div>
                </td>
              </tr>
              <tr>
                <td style="width: 150px; height: 200px" rowspan="2">
                  <div
                    class="preview-area"
                    :id="objectLists[1].name"
                    @click="chooseActive(1)"
                    style="width: 100%; height: 100%"
                  >
                    <img :id="'preview_' + objectLists[1].name" />
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
          <table v-if="templateId === 207" style="width: 300px">
            <tbody>
              <tr>
                <td style="width: 300px; height: 200px" rowspan="2">
                  <div
                    class="preview-area active"
                    :id="objectLists[0].name"
                    @click="chooseActive(0)"
                    style="width: 100%; height: 100%"
                  >
                    <img :id="'preview_' + objectLists[0].name" />
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
          <table v-if="templateId === 1001" style="width: 300px">
            <tbody>
              <tr>
                <td style="width: 100px">
                  <div
                    class="preview-area active"
                    :id="objectLists[0].name"
                    @click="chooseActive(0)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[0].name" />
                  </div>
                </td>
                <td style="width: 100px">
                  <div
                    class="preview-area"
                    :id="objectLists[1].name"
                    @click="chooseActive(1)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[1].name" />
                  </div>
                </td>
                <td style="width: 100px">
                  <div
                    class="preview-area"
                    :id="objectLists[2].name"
                    @click="chooseActive(2)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[2].name" />
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
          <table v-if="templateId === 1002" style="width: 300px">
            <tbody>
              <tr>
                <td style="width: 100px">
                  <div
                    class="preview-area active"
                    :id="objectLists[0].name"
                    @click="chooseActive(0)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[0].name" />
                  </div>
                </td>
                <td style="width: 200px">
                  <div
                    class="preview-area"
                    :id="objectLists[1].name"
                    @click="chooseActive(1)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[1].name" />
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
          <table v-if="templateId === 1003" style="width: 300px">
            <tbody>
              <tr>
                <td style="width: 200px">
                  <div
                    class="preview-area active"
                    :id="objectLists[0].name"
                    @click="chooseActive(0)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[0].name" />
                  </div>
                </td>
                <td style="width: 100px">
                  <div
                    class="preview-area"
                    :id="objectLists[1].name"
                    @click="chooseActive(1)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[1].name" />
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
          <table v-if="templateId === 1004" style="width: 300px">
            <tbody>
              <tr>
                <td style="width: 150px">
                  <div
                    class="preview-area active"
                    :id="objectLists[0].name"
                    @click="chooseActive(0)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[0].name" />
                  </div>
                </td>
                <td style="width: 150px">
                  <div
                    class="preview-area"
                    :id="objectLists[1].name"
                    @click="chooseActive(1)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[1].name" />
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
          <table v-if="templateId === 1005" style="width: 300px">
            <tbody>
              <tr>
                <td style="width: 300px">
                  <div
                    class="preview-area active"
                    :id="objectLists[0].name"
                    @click="chooseActive(0)"
                    style="width: 100%; height: 100px"
                  >
                    <img :id="'preview_' + objectLists[0].name" />
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div v-if="editor === 'imagemap'" style="height: 400px; width: 300px;"  class="d-flex flex-column justify-content-center align-items-center">
          <table v-if="templateId === 201" style="width: 270px; height: 270px">
            <tbody>
              <tr>
                <td style="width: 90px">
                  <div
                    class="preview-area active"
                    :id="objectLists[0].name"
                    @click="chooseActive(0)"
                    style="width: 100%; height: 135px"
                  >
                    <img :id="'preview_' + objectLists[0].name" />
                  </div>
                </td>
                <td style="width: 90px">
                  <div
                    class="preview-area"
                    :id="objectLists[1].name"
                    @click="chooseActive(1)"
                    style="width: 100%; height: 135px"
                  >
                    <img :id="'preview_' + objectLists[1].name" />
                  </div>
                </td>
                <td style="width: 90px">
                  <div
                    class="preview-area"
                    :id="objectLists[2].name"
                    @click="chooseActive(2)"
                    style="width: 100%; height: 135px"
                  >
                    <img :id="'preview_' + objectLists[2].name" />
                  </div>
                </td>
              </tr>
              <tr>
                <td style="width: 90px">
                  <div
                    class="preview-area"
                    :id="objectLists[3].name"
                    @click="chooseActive(3)"
                    style="width: 100%; height: 135px"
                  >
                    <img :id="'preview_' + objectLists[3].name" />
                  </div>
                </td>
                <td style="width: 90px">
                  <div
                    class="preview-area"
                    :id="objectLists[4].name"
                    @click="chooseActive(4)"
                    style="width: 100%; height: 135px"
                  >
                    <img :id="'preview_' + objectLists[4].name" />
                  </div>
                </td>
                <td style="width: 90px">
                  <div
                    class="preview-area"
                    :id="objectLists[5].name"
                    @click="chooseActive(5)"
                    style="width: 100%; height: 135px"
                  >
                    <img :id="'preview_' + objectLists[5].name" />
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
          <table v-if="templateId === 202" style="width: 270px; height: 270px">
            <tbody>
              <tr>
                <td style="width: 90px">
                  <div
                    class="preview-area active"
                    :id="objectLists[0].name"
                    @click="chooseActive(0)"
                    style="width: 100%; height: 135px"
                  >
                    <img :id="'preview_' + objectLists[0].name" />
                  </div>
                </td>
                <td style="width: 90px">
                  <div
                    class="preview-area"
                    :id="objectLists[1].name"
                    @click="chooseActive(1)"
                    style="width: 100%; height: 135px"
                  >
                    <img :id="'preview_' + objectLists[1].name" />
                  </div>
                </td>
              </tr>
              <tr>
                <td style="width: 135px">
                  <div
                    class="preview-area"
                    :id="objectLists[2].name"
                    @click="chooseActive(2)"
                    style="width: 100%; height: 135px"
                  >
                    <img :id="'preview_' + objectLists[2].name" />
                  </div>
                </td>
                <td style="width: 135px">
                  <div
                    class="preview-area"
                    :id="objectLists[3].name"
                    @click="chooseActive(3)"
                    style="width: 100%; height: 135px"
                  >
                    <img :id="'preview_' + objectLists[3].name" />
                  </div>
                </td>
              </tr>
            </tbody>
          </table>

          <table v-if="templateId === 203" style="width: 270px; height: 270px">
            <tbody>
              <tr>
                <td style="width: 270px">
                  <div
                    class="preview-area active"
                    :id="objectLists[0].name"
                    @click="chooseActive(0)"
                    style="width: 100%; height: 90px"
                  >
                    <img :id="'preview_' + objectLists[0].name" />
                  </div>
                </td>
              </tr>
              <tr>
                <td style="width: 270px">
                  <div
                    class="preview-area"
                    :id="objectLists[1].name"
                    @click="chooseActive(1)"
                    style="width: 100%; height: 90px"
                  >
                    <img :id="'preview_' + objectLists[1].name" />
                  </div>
                </td>
              </tr>
              <tr>
                <td style="width: 270px">
                  <div
                    class="preview-area"
                    :id="objectLists[2].name"
                    @click="chooseActive(2)"
                    style="width: 100%; height: 90px"
                  >
                    <img :id="'preview_' + objectLists[2].name" />
                  </div>
                </td>
              </tr>
            </tbody>
          </table>

          <table v-if="templateId === 204" style="width: 270px; height: 270px">
            <tbody>
              <tr>
                <td style="width: 270px" colspan="2">
                  <div
                    class="preview-area active"
                    :id="objectLists[0].name"
                    @click="chooseActive(0)"
                    style="width: 100%; height: 135px"
                  >
                    <img :id="'preview_' + objectLists[0].name" />
                  </div>
                </td>
              </tr>
              <tr>
                <td style="width: 90px">
                  <div
                    class="preview-area"
                    :id="objectLists[1].name"
                    @click="chooseActive(1)"
                    style="width: 100%; height: 135px"
                  >
                    <img :id="'preview_' + objectLists[1].name" />
                  </div>
                </td>
                <td style="width: 90px">
                  <div
                    class="preview-area"
                    :id="objectLists[2].name"
                    @click="chooseActive(2)"
                    style="width: 100%; height: 135px"
                  >
                    <img :id="'preview_' + objectLists[2].name" />
                  </div>
                </td>
              </tr>
            </tbody>
          </table>

          <table v-if="templateId === 208" style="width: 270px; height: 270px">
            <tbody>
              <tr>
                <td style="width: 90px">
                  <div
                    class="preview-area active"
                    :id="objectLists[0].name"
                    @click="chooseActive(0)"
                    style="width: 100%; height: 135px"
                  >
                    <img :id="'preview_' + objectLists[0].name" />
                  </div>
                </td>
              </tr>
              <tr>
                <td style="width: 90px">
                  <div
                    class="preview-area"
                    :id="objectLists[1].name"
                    @click="chooseActive(1)"
                    style="width: 100%; height: 75px"
                  >
                    <img :id="'preview_' + objectLists[1].name" />
                  </div>
                </td>
              </tr>
              <tr>
                <td style="width: 90px">
                  <div
                    class="preview-area"
                    :id="objectLists[2].name"
                    @click="chooseActive(2)"
                    style="width: 100%; height: 75px"
                  >
                    <img :id="'preview_' + objectLists[2].name" />
                  </div>
                </td>
              </tr>
            </tbody>
          </table>

          <table v-if="templateId === 205" style="width: 270px; height: 270px">
            <tbody>
              <tr>
                <td style="width: 90px">
                  <div
                    class="preview-area active"
                    :id="objectLists[0].name"
                    @click="chooseActive(0)"
                    style="width: 100%; height: 135px"
                  >
                    <img :id="'preview_' + objectLists[0].name" />
                  </div>
                </td>
              </tr>
              <tr>
                <td style="width: 90px">
                  <div
                    class="preview-area"
                    :id="objectLists[1].name"
                    @click="chooseActive(1)"
                    style="width: 100%; height: 135px"
                  >
                    <img :id="'preview_' + objectLists[1].name" />
                  </div>
                </td>
              </tr>
            </tbody>
          </table>

          <table v-if="templateId === 206" style="width: 270px; height: 270px">
            <tbody>
              <tr>
                <td style="width: 90px">
                  <div
                    class="preview-area active"
                    :id="objectLists[0].name"
                    @click="chooseActive(0)"
                    style="width: 135px; height: 270px"
                  >
                    <img :id="'preview_' + objectLists[0].name" />
                  </div>
                </td>
                <td style="width: 90px">
                  <div
                    class="preview-area"
                    :id="objectLists[1].name"
                    @click="chooseActive(1)"
                    style="width: 135px; height: 270px"
                  >
                    <img :id="'preview_' + objectLists[1].name" />
                  </div>
                </td>
              </tr>
            </tbody>
          </table>

          <table v-if="templateId === 207" style="width: 270px; height: 270px">
            <tbody>
              <tr>
                <td style="width: 90px">
                  <div
                    class="preview-area active"
                    :id="objectLists[0].name"
                    @click="chooseActive(0)"
                    style="width: 270px; height: 270px"
                  >
                    <img :id="'preview_' + objectLists[0].name" />
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      <div class="editor-divider"></div>
      <div class="d-flex flex-column editor-container w-100">
        <div class="d-flex mb-2">
          <button class="btn btn-info btn-xs ml-auto mr-1" @click="imageGeneration()">
            <i class="fa fa-download"></i>
            ダウンロード
          </button>
          <button class="btn btn-xs btn-info" @click="imageGeneration(false)"><i class="fa fa-save"></i> 保存</button>
        </div>
        <image-editor
          :data="objectLists[selectIndex]"
          :preview="'#preview_' + objectLists[selectIndex].name"
          :width="width"
          :height="height"
          @input="objectLists[selectIndex] = $event"
        ></image-editor>
        <div style="text-align: center; flex: 1; height: 50px"></div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, reactive, watch, onMounted } from 'vue'

const props = defineProps({
  editor: {
    type: String,
    default: 'richmenu'
  },
  templateId: {
    type: Number,
    default: 201
  }
})
const emit = defineEmits(['save'])

const RichMenuBounds = window.RichMenuBounds || {}
const ImageMapBounds = window.ImageMapBounds || {}

const bounds = ref(RichMenuBounds[props.templateId])
const currentData = ref({})
const selectIndex = ref(0)
const objectLists = ref([])
const rendering = ref(true)
const width = ref(833)
const height = ref(833)

onMounted(() => {
  if (props.editor === 'imagemap') {
    width.value = 346
    height.value = 520
    bounds.value = ImageMapBounds[props.templateId]
  }
  setup()
})

watch(() => props.templateId, (val) => {
  if (props.editor === 'imagemap') {
    bounds.value = ImageMapBounds[val]
  } else {
    bounds.value = RichMenuBounds[val]
  }
  setup()
})

const styleAuto = () => {
  return props.editor === 'imagemap' ? 'height: 50px;' : ''
}

const setup = () => {
  objectLists.value = []
  if (bounds.value) {
    for (const [index, bound] of bounds.value.entries()) {
      objectLists.value.push({
        name: 'obj_' + index,
        crop_type_index: bound.crop_index,
        bound: {
          x: bound.x,
          y: bound.y,
          w: bound.width,
          h: bound.height
        },
        image: {
          x: 0,
          y: 0,
          w: 0,
          h: 0,
          zoom: 1,
          data: null
        },
        cache: null
      })
    }
  }
  chooseActive(0)
}

const chooseActive = (index = 0) => {
  const object = objectLists.value[index]
  selectIndex.value = index

  $('.preview-area.active').removeClass('active')
  $('#' + object.name).addClass('active')
}

const saveImage = (data) => {
  emit('save', data)
}

const imageGeneration = (isDownload = true) => {
  const canvas = document.createElement('canvas')

  if (props.editor === 'imagemap') {
    canvas.width = 1040
    canvas.height = 1040
  } else {
    canvas.width = 2500
    canvas.height = 1686

    if (props.templateId > 1000) {
      canvas.height = 843
    }
  }

  const context = canvas.getContext('2d')
  context.fillStyle = 'white'
  context.fillRect(0, 0, canvas.width, canvas.height)

  // drawimage
  const tasks = []
  for (let index = 0; index < objectLists.value.length; index++) {
    const object = objectLists.value[index]
    if (object.cache) {
      tasks.push(new Promise((resolve, reject) => {
        const image = new Image()
        image.onload = () => {
          const bound = object.bound
          context.drawImage(image, bound.x, bound.y, bound.w, bound.h)
          resolve()
        }
        image.crossOrigin = 'anonymous'
        image.src = object.cache
      }))
    }
  }

  Promise.all(tasks).then(() => {
    if (isDownload) {
      const a = document.createElement('a')
      a.href = canvas.toDataURL('image/jpeg')
      a.download = `${(new Date().getTime())}_${props.editor}_${a.href.length}.jpg`
      document.body.appendChild(a)
      a.click()
      document.body.removeChild(a)
    } else {
      saveImage(canvas.toDataURL('image/jpeg'))
    }
  }).catch((err) => {
    console.log(err)
  })
}
</script>

<style scoped lang="scss">
  .preview-area {
    background: white;
    width: 100%;
    display: inline-table;
    height: 100px;
    overflow: hidden;
    border: 1px solid #ededed;
  }
  .preview-area > img {
    width: 100%;
  }

  .preview {
    width: 100% !important;
    height: 100% !important;
    overflow: hidden;
    background: white;
  }

  .preview-area.active {
    background: #f1f1f1;
  }

  :deep() {
    .editor-content {
      display: flex;
      flex-direction: row;
    }
    .editor-divider {
      width: 20px;
    }

    @media only screen and (max-width: 911px) {
      .editor-content {
        flex-direction: column;
      }

      .editor-divider {
        width: 100%;
        height: 20px;
      }
    }
    .btn-close {
      background: transparent;
      border: 1px solid #ededed;
      color: #00b900;
      padding: 5px 15px;
      font-size: 13px;
      border-radius: 4px;
      min-width: 100px;
    }

    .btn-save0 {
      background: #00b900;
      border: 1px solid #ededed;
      color: white;
      padding: 5px 15px;
      font-size: 13px;
      border-radius: 4px;
      min-width: 100px;
    }

    td {
      padding: 0 !important;
    }

    .line-nav-bar {
      width: 100%;
      height: 50px;
      background: #0a2f4c;
      color: white;
      display: flex;
    }
    .line-nav-bar > p {
      background: #0a2f4c;
      display: inline-block;
      margin: auto;
    }
  }
</style>
