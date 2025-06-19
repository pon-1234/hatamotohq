<template>
  <div>
    <div class="form-group">
      <label>代替テキスト<required-mark></required-mark></label>
      <input
        type="text"
        :name="`altText${index}`"
        class="form-control"
        placeholder="代替テキストを入力してください"
        v-model="altText"
        v-validate="'required|max:400'"
        data-vv-as="代替テキスト"
      />
      <error-message :message="errors.first(`altText${index}`)"></error-message>
    </div>
    <div class="d-flex flex-column" style="">
      <div class="form-group" v-show="htmlPreview !== null">
        <label>メッセージ通知文</label>
        <input
          type="text"
          name="altText"
          class="form-control alt-text-input"
          placeholder="メッセージ通知文を入力してください"
          v-validate="{ required: isValidate }"
          v-model="altText"
        />
      </div>
      <div class="flex-container">
        <div class="form-group flex-message preview" v-show="htmlPreview !== null">
          <div v-html="data.html_template"></div>
        </div>
        <div class="col-sm-6 form-group controls">
          <div
            v-for="item in mapObject"
            :key="item.id"
            class="group-action-flex-message"
            :class="item.id"
            @click="changeActive(item.id)"
          >
            <flexmessage-text-action v-if="item.type === 'text'" :data="item" :name="item.id" @input="editObject" />

            <flexmessage-button-action v-if="item.type === 'button'" :data="item" :name="item.id" @input="editObject" />

            <flexmessage-image-action
              v-if="item.type === 'image'"
              :data="item"
              :name="item.id"
              :aspectMode="aspectMode"
              @input="editObject"
            />

            <flexmessage-box-action v-if="item.type === 'box'" :data="item" :name="item.id" @input="editObject" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, watch, onMounted, nextTick } from 'vue'
import { omitDeep } from '@/core/omitDeep'
import Util from '@/core/util'
import RequiredMark from '../common/RequiredMark.vue'

const props = defineProps({
  data: Object,
  isValidate: Boolean,
  index: Number
})
const emit = defineEmits(['input'])

const altText = ref('')
const mapObject = reactive({})
const currentEditor = ref(null)
const htmlPreview = ref(null)
const jsonPreview = ref(null)
const aspectMode = ref('cover')
const passedObject = reactive({})
const errors = ref({ first: () => null, items: [] })
const FontSizeClass = window.FontSizeClass || []

watch(() => props.data, () => {
  nextTick(() => {
    setup()
  })
})

onMounted(() => {
  setup()
})

const setup = () => {
  if (props.data && props.data.json_template == null) return
  currentEditor.value = null
  htmlPreview.value = $('div.flex-message.preview')
  jsonPreview.value = JSON.parse(props.data.json_template)
  Object.keys(mapObject).forEach(key => delete mapObject[key])
  detectObject(jsonPreview.value)
  makeActionHtml(htmlPreview.value)
  objectMapToJson(jsonPreview.value)
  console.log(mapObject)
}

const detectObject = (json) => {
  if (json.contents) {
    detectObject(json.contents)
  }

  for (const value of Object.values(json)) {
    if (value && value.type != null && value.id != null) {
      if (value.type === 'bubble') {
        detectObject(value)
        // detectObject(value.body)
      } else if (value.type === 'text' && value.editable != null) {
        mapObject[value.id] = {
          id: value.id,
          type: value.type,
          text: value.text,
          size: value.size,
          action: value.action
        }
      } else if (value.type === 'box') {
        if (value.editable != null) {
          mapObject[value.id] = {
            id: value.id,
            type: value.type,
            action: value.action
          }
        }
        detectObject(value)
      } else if (value.type === 'image' && value.editable != null) {
        mapObject[value.id] = {
          id: value.id,
          type: value.type,
          url: value.url,
          action: value.action
        }
      } else if (value.type === 'button' && value.editable != null) {
        mapObject[value.id] = {
          id: value.id,
          type: value.type,
          action: value.action
        }
      }
    }
  }
}

    makeActionHtml($html) {
      const that = this;
      for (const key of Object.keys(this.mapObject)) {
        const $div = $html.find('#' + key);
        $div.addClass('flex-editor');
        $div.click(ev => {
          that.chooseObject(key);
          ev.stopPropagation();
        });
      }
    },

    chooseObject(id) {
      this.currentEditor = this.mapObject[id];

      this.$nextTick(async() => {
        this.$validator.validateAll().then(passed => {
          const isError = this.errors.items.find(item => item.field.includes(id));
          if (isError) {
            this.passedObject[id] = false;
            this.htmlPreview.find('div#' + id).addClass('flex-error');
          } else {
            this.passedObject[id] = true;
            this.htmlPreview.find('div#' + id).removeClass('flex-error');
          }
          this.emitObject();
        });
      });

      this.htmlPreview.find('.flex-editor-active').removeClass('flex-editor-active');
      $('.form-group')
        .find('.active-flex-el')
        .removeClass('active-flex-el');

      const className = '.' + id;
      $('.card-container')
        .parent()
        .removeClass('active');
      $(className + '-expand')
        .parent()
        .addClass('active');

      $('html,body').animate({ scrollTop: $(className).offset().top - 100 }, 'slow');
      this.htmlPreview.find('div#' + id).addClass('flex-editor-active');
      $(className).addClass('active-flex-el');

      const style = this.htmlPreview
        .find('div#' + id)
        .find('span')
        .css('background-size');
      this.aspectMode = style;
    },

const editObject = (value) => {
  objectMapToJson(jsonPreview.value)

  // view update
  if (value.type === 'text') {
    FontSizeClass.forEach(item => {
      htmlPreview.value.find('div#' + value.id).removeClass('Ex' + item)
    })
    htmlPreview.value.find('div#' + value.id).removeAttr('style')
    if (value.size.match(Util.regexFontSizeUsingPx())) {
      htmlPreview.value.find('div#' + value.id).css('font-size', value.size)
    } else if (value.size.match(Util.regexFontSizeUsingWord())) {
      const sizeClass =
        value.size.slice(0, value.size.length - 1).toUpperCase() + value.size.slice(-1).toLowerCase()
      htmlPreview.value.find('div#' + value.id).addClass('Ex' + sizeClass)
    }
    htmlPreview.value.find('div#' + value.id + ' p').text(value.text)
  } else if (value.type === 'button') {
    htmlPreview.value.find('div#' + value.id + ' a>div').text(value.action.label)
  } else if (value.type === 'image') {
    htmlPreview.value.find('div#' + value.id + ' div>a>span').css('background-image', "url('" + value.url + "')")
    if (value.aspectMode === 'cover') {
      htmlPreview.value.find('div#' + value.id + ' div>a>span').css('background-size', 'cover')
    } else {
      htmlPreview.value.find('div#' + value.id + ' div>a>span').css('background-size', 'contain')
    }
  }

  // validate
  nextTick(() => {
    // Validation logic removed - handle validation differently in Vue 3
    const isError = errors.value.items.find(item => item.field.includes(value.id))
    if (isError) {
      passedObject[value.id] = false
      htmlPreview.value.find('div#' + value.id).addClass('flex-error')
    } else {
      passedObject[value.id] = true
      htmlPreview.value.find('div#' + value.id).removeClass('flex-error')
    }

    emitObject()
  })
}

const objectMapToJson = (json) => {
  for (const value of Object.values(json)) {
    if (Array.isArray(value)) {
      for (let i = 0; i < value.length; i++) {
        objectMapToJson(value[i])
      }
    } else if (value.id) {
      if (value.type === 'text' && value.editable != null) {
        const objectMap = mapObject[value.id]
        value.text = objectMap.text
        if (objectMap.size) {
          value.size = objectMap.size
        }
        if (objectMap.action && objectMap.action.type !== 'none') {
          value.action = objectMap.action
        } else {
          delete value.action
        }
      } else if (value.type === 'box') {
        if (value.editable != null) {
          const objectMap = mapObject[value.id]

          if (objectMap.action && objectMap.action.type !== 'none') {
            value.action = objectMap.action
          } else {
            delete value.action
          }
        }
        // map treeObject
        if (value.contents) {
          objectMapToJson(value.contents)
        }
      } else if (value.type === 'image' && value.editable != null) {
        const objectMap = mapObject[value.id]
        value.url = objectMap.url
        if (objectMap.action && objectMap.action.type !== 'none') {
          value.action = objectMap.action
        } else {
          delete value.action
        }

        if (objectMap.aspectMode) {
          value.aspectMode = objectMap.aspectMode
        }
      } else if (value.type === 'button' && value.editable != null) {
        const objectMap = mapObject[value.id]
        if (objectMap.action && objectMap.action.type !== 'none') {
          value.action = objectMap.action
        } else {
          delete value.action
        }
      }
    }
  }
}

const emitObject = () => {
  console.log('emitObject', jsonPreview.value)
  emit('input', {
    altText: altText.value,
    passedObject: passedObject,
    html_template: htmlPreview.value.html(),
    json_template: JSON.stringify(jsonPreview.value),
    json_message: JSON.stringify(omitDeep(jsonPreview.value, 'editable', 'linkUri', 'id'))
  })
}

const changeActive = (id) => {
  htmlPreview.value.find('.flex-editor-active').removeClass('flex-editor-active')
  $('.form-group')
    .find('.active-flex-el')
    .removeClass('active-flex-el')

  const className = '.' + id
  htmlPreview.value.find('div#' + id).addClass('flex-editor-active')
  $(className).addClass('active-flex-el')
  const style = htmlPreview.value
    .find('div#' + id)
    .find('span')
    .css('background-size')
  aspectMode.value = style
}
</script>

<style lang="scss" scoped>
  :deep() {
    .flex-error {
      border: 1px solid red !important;
    }
    .flex-editor {
      border: 1px solid transparent;
    }

    .flex-editor:hover {
      border: 1px solid #0a90eb;
    }
    .flex-editor-active {
      border-color: #0a90eb;
    }

    .preview *::-webkit-scrollbar {
      display: inherit !important;
      color: inherit;

      height: 8px;
      margin-top: 2px;
    }
    .preview ::-webkit-scrollbar-thumb {
      /* leave most bars alone */
      background-color: grey;
      border-radius: 6px;
    }
  }

  .preview {
    padding: 20px;
    min-width: 350px;
    max-width: 500px;
    flex: 1;
    background: #ededed;
    display: flex;
  }

  .preview > div {
    margin: 10px auto;
    width: 100%;
    justify-content: center;
  }

  .controls {
    max-width: 500px;
  }

  .flex-container {
    display: flex;
    /*justify-content: center;*/
  }

  @media (max-width: 799px) {
    .preview {
      max-width: initial;
    }
    .col-sm-6 {
      padding: 0;
    }
    .controls {
      max-width: 100%;
      width: 100%;
    }
    .flex-container {
      flex-direction: column;
    }
  }

  .group-action-flex-message {
    border: thin solid #ccd0d2;
    padding: 10px;
    margin-bottom: 20px;
  }

  .active-flex-el {
    border-color: 2px solid #5bc0de;
    box-shadow: 0 0 2px 2px rgba(91, 192, 222, 0.6);
  }

  .alt-text-input {
    max-width: 985px;
  }
</style>
