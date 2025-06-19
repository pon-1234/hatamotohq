<template>
  <div>
    <p class="text-right" @click="expand()">
      <span class="float-left">テキスト</span>
      <i class="mdi mdi-arrow-expand" aria-hidden="true"></i>
    </p>
    <div style="margin-top: 10px; display: none" :class="name + '-expand'" class="card-container">
      <div class="card">
        <h5 class="card-header">Text</h5>
        <div class="card-body">
          <div class="form-group row">
            <label class="col-sm-4 col-form-label"> Text </label>
            <div class="col-sm-8">
              <input
                type="text"
                :name="'text_' + name"
                class="form-control"
                v-model.trim="text"
                @change="input"
                required
              />
            </div>
          </div>
          <div class="form-group row">
            <label class="col-sm-4 col-form-label">サイズ変更</label>
            <div class="col-sm-8">
              <input-with-suggestion
                type="text"
                :name="'size_' + name"
                :validate="{ regex: getRegexFontSize() }"
                :list="FontSizeClass.map((item) => item.toLowerCase())"
                :value="size"
                @change="changeSize"
                classes="form-control"
              />
              <span v-if="errors.first('size_' + name)" class="invalid-box-label">サイズが無効です</span>
            </div>
          </div>
        </div>
      </div>
      <div class="card">
        <h5 class="card-header">アクション設定</h5>
        <div class="card-body">
          <div class="form-group">
            <label class="col-form-label"> タイプ </label>
            <action-editor
              class="form-group"
              :title="'Action Type'"
              :supports="['postback', 'uri', 'message', 'datetimepicker', 'survey']"
              :showTitle="false"
              :name="name"
              :value="action"
              @input="action = $event"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import { ActionMessage } from '../../../core/constant'
import Util from '@/core/util'

const props = defineProps(['name', 'data'])
const emit = defineEmits(['input'])

const action = ref(props.data.action || ActionMessage.default)
const text = ref(props.data.text)
const size = ref(props.data.size)
const errors = ref({ first: () => null })
const FontSizeClass = window.FontSizeClass || []
watch(() => props.data, () => {
  text.value = props.data.text
  size.value = props.data.size
  action.value = props.data.action || {
    type: 'none'
  }
})

watch(text, () => {
  input()
})

watch(action, (val) => {
  const mData = props.data
  mData.text = text.value
  mData.size = size.value
  mData.action = val
  emit('input', mData)
}, { deep: true })

const input = () => {
  const mData = props.data
  mData.text = text.value
  mData.size = size.value
  mData.action = action.value
  emit('input', mData)
}

const changeSize = (value) => {
  size.value = value
  input()
}

const expand = () => {
  if ($('div.' + props.name + '-expand').is(':visible')) {
    $('div.' + props.name + '-expand').parent().removeClass('active')
  } else {
    $('div.' + props.name + '-expand').parent().addClass('active')
  }
}

const getRegexFontSize = () => {
  return Util.regexFontSize()
}
</script>

<style lang="scss" scoped>
  .active .card-container {
    display: block !important;
  }

  i.fa-arrow-expand::before {
    content: "\f078";
  }

  .active i.fa-arrow-expand::before {
    content: "\f077";
  }
  :deep() {
    .card-header:first-child {
      border-radius: calc(0.25rem - 1px) calc(0.25rem - 1px) 0 0;
    }
    .card-header {
      padding: 0.75rem 1.25rem;
      margin: 0;
      background-color: rgba(0, 0, 0, 0.03);
      border-bottom: 1px solid rgba(0, 0, 0, 0.125);
    }

    .card:nth-child(n + 2) {
      margin-top: 20px;
    }
    .card {
      position: relative;
      display: -ms-flexbox;
      display: flex;
      -ms-flex-direction: column;
      flex-direction: column;
      min-width: 0;
      word-wrap: break-word;
      background-color: #fff;
      background-clip: border-box;
      border: 1px solid rgba(0, 0, 0, 0.125);
      border-radius: 0.25rem;
    }

    .card-body {
      background-color: #efefef;
    }
    .card-body {
      -ms-flex: 1 1 auto;
      flex: 1 1 auto;
      min-height: 1px;
      padding: 1.25rem;
    }

    .col-form-label {
      padding-top: calc(0.375rem + 1px);
      padding-bottom: calc(0.375rem + 1px);
      margin-bottom: 0;
      font-size: inherit;
      line-height: 1.5;
    }

    h5,
    .h5 {
      font-size: 25px;
    }
  }
</style>
