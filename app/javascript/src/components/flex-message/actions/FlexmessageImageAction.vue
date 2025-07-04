<template>
  <div>
    <p class="text-right" @click="expand()">
      <span class="float-left">画像</span>
      <i class="mdi mdi-arrow-expand" aria-hidden="true"></i>
    </p>
    <div style="margin-top: 10px; display: none" :class="name + '-expand'" class="card-container">
      <div class="card">
        <h5 class="card-header">Image</h5>
        <div class="card-body">
          <input type="hidden" v-model="url" class="form-control" />
          <div class="form-group row">
            <label class="col-sm-4 col-form-label">画像</label>
            <div class="col-sm-8">
              <button
                type="button"
                class="btn btn-submit btn-block"
                data-toggle="modal"
                :data-target="'#modalSelectMedia-' + name"
              >
                画像を選択する
              </button>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-sm-4 col-form-label">サイズ変更</label>
            <div class="col-sm-8">
              <select type="text" v-model="aspectModeParams" class="w-100 form-control" @change="changeAspectMode">
                <option v-for="(val, index) of aspectModesOption" :key="index" :value="val">
                  {{ val }}
                </option>
              </select>
            </div>
          </div>
        </div>
      </div>
      <div class="card">
        <h5 class="card-header">アクション設定</h5>
        <div class="card-body">
          <div class="form-group">
            <action-editor
              :supports="['postback', 'uri', 'message', 'datetimepicker', 'survey']"
              :name="name"
              :value="action"
              :showTitle="false"
              :requiredLabel="false"
              @input="action = $event"
            />
          </div>
        </div>
      </div>
      <modal-select-media @input="uploadImage" :data="{ type: 'image' }" :id="'modalSelectMedia-' + name" />
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import { ActionMessage } from '../../../core/constant'

const props = defineProps(['name', 'data', 'aspectMode'])
const emit = defineEmits(['input'])

const action = ref(props.data.action || ActionMessage.default)
const url = ref(props.data.url)
const aspectModeParams = ref(props.aspectMode === 'contain' ? 'fit' : 'cover')
const aspectModesOption = window.aspectModes || ['cover', 'fit']

watch(() => props.data, () => {
  url.value = props.data.url
  action.value = props.data.action || {
    type: 'none'
  }
})

watch(action, (val) => {
  input()
}, { deep: true })

watch(() => props.aspectMode, (val) => {
  aspectModeParams.value = props.aspectMode === 'contain' ? 'fit' : 'cover'
}, { deep: true })

const input = () => {
  const mData = props.data
  mData.url = url.value
  mData.action = action.value
  mData.aspectMode = aspectModeParams.value
  emit('input', mData)
}

const uploadImage = (data) => {
  url.value = data.originalContentUrl
  input()
}

const expand = () => {
  if ($('div.' + props.name + '-expand').is(':visible')) {
    $('div.' + props.name + '-expand')
      .parent()
      .removeClass('active')
  } else {
    $('div.' + props.name + '-expand')
      .parent()
      .addClass('active')
  }
}

const changeAspectMode = () => {
  console.log(aspectModeParams.value)
  input()
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

    .btn.btn-add {
      color: #fff;
      background: rgba(227, 100, 48, 1);
      background: -moz-linear-gradient(
        90deg,
        rgba(208, 120, 83, 1) 0%,
        rgba(227, 100, 48, 1) 50%,
        rgba(240, 71, 0, 1) 100%
      );
      background: -webkit-linear-gradient(
        90deg,
        rgba(208, 120, 83, 1) 0%,
        rgba(227, 100, 48, 1) 50%,
        rgba(240, 71, 0, 1) 100%
      );
      background: linear-gradient(90deg, rgba(208, 120, 83, 1) 0%, rgba(227, 100, 48, 1) 50%, rgba(240, 71, 0, 1) 100%);
    }
  }
</style>
