<template>
  <div class="mt-2">
    <span class="title-editor ml-3">絵文字</span>
    <textarea
      ref="textarea"
      class="form-control"
      rows="5"
      placeholder="本文を入力してください"
      maxlength="5001"
      v-model="value"
    ></textarea>
    <input
      type="hidden"
      v-model.trim="value"
      data-vv-as="本文"
      :name="'message-editor' + index"
    />
    <div class="text-sm">
      <p class="m-0">{name}：お客様の名前</p>
    </div>
    <error-message :message="errors.first('message-editor' + index)" />
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'

const props = defineProps({
  value: String,
  index: Number
})

const emit = defineEmits(['input'])

const textarea = ref(null)
const errors = ref({ first: () => null })

onMounted(() => {
  $(textarea.value).emojioneArea({
    template: '<editor/><filters/><tabs/>',
    autocomplete: 'off',
    autocorrect: 'off',
    autocapitalize: 'off',
    placeholder: null,
    container: null,
    hideSource: true,
    autoHideFilters: true,
    useSprite: true,
    shortnames: true,
    searchPosition: 'bottom',
    pickerPosition: 'bottom',
    events: {
      keyup(editor, event) {
        emit('input', this.getText())
      },
      keydown(editor, event) {
        emit('input', this.getText())
      },
      keypress(editor, event) {
        emit('input', this.getText())
      },
      change(editor, event) {
        emit('input', this.getText())
      },
      emojibtn_click(editor, event) {
        emit('input', this.getText())
      }
    }
  })
})
</script>

<style lang="scss" scoped>
  :deep() {
    .emojionearea-button {
      left: -4px !important;
      top: -26px !important;
    }

    .emojionearea-picker-position-bottom {
      left: -20px !important;
      top: 10px !important;
    }

    .emojionearea-wrapper::after {
      left: 20px !important;
    }
  }

  .title-editor {
    display: flex;
    font-size: 12px;
    padding-bottom: 3px !important;
  }
</style>
