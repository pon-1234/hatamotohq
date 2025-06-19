<template>
  <div>
    <div class="border template-buttons row" :key="contentKey">
      <div class="d-flex group-title col-12">
        <label class="mt-2"> タイトル<required-mark /></label>
        <input
          class="form-control"
          placeholder="タイトルを入力してください"
          type="text"
          maxlength="41"
          v-model.trim="templateData.title"
          data-vv-as="タイトル"
          :name="'button-title' + indexParent"
        />
        <error-message :message="errors.first('button-title' + indexParent)" />
      </div>

      <div class="d-flex group-title col-12">
        <label class="mt-2 d-flex align-items-center"> テキスト<required-mark /> </label>
        <input
          class="form-control"
          placeholder="テキストを入力してください"
          :name="'button-text' + indexParent"
          type="text"
          maxlength="61"
          v-model.trim="templateData.text"
          data-vv-as="テキスト"
        />
        <error-message :message="errors.first('button-text' + indexParent)" />
      </div>

      <div class="row col-12" style="margin-top: 15px !important">
        <div class="col-sm-3">
          <ul class="nav nav-tabs nav-stacked nav-buttons d-block">
            <li
              v-for="(item, index) in templateData.actions"
              :key="index"
              :class="selected == index ? 'active' : ''"
              @click="changeSelected(index)"
            >
              <div
                class="nav-button d-flex"
                :class="
                  errors.items.find((item) => item.field.includes(indexParent + 'template_button_' + index))
                    ? 'invalid-box'
                    : ''
                "
              >
                ボタン{{ index + 1 }}
                <span v-if="templateData.actions.length > 1" @click.stop="removeAction(index)" class="ml-auto mr-1"
                  ><i class="dripicons-trash"></i
                ></span>
              </div>
            </li>
            <li v-if="templateData.actions.length < 4">
              <div class="nav-button btn btn-primary justify-content-center" @click="addMoreAction">
                <i class="uil-plus"></i> 追加
              </div>
            </li>
          </ul>
        </div>
        <div class="col-sm-9">
          <div class="card">
            <div class="card-header">
              <b>選択肢{{ selected + 1 }}</b>
            </div>
            <div class="card-body">
              <div v-for="(item, index) in templateData.actions" :key="index" v-show="index === selected">
                <action-editor
                  :name="'parent_' + indexParent + 'template_button_' + index"
                  :value="item"
                  @input="changeAction(index, $event)"
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, watch, onMounted } from 'vue'
import { TemplateMessageType } from '@/core/constant'
import { useActionMessage } from '@/composables/useConstants'

const props = defineProps({
  data: Object,
  indexParent: Number
})

const emit = defineEmits(['input'])

const actionMessage = useActionMessage()

const selected = ref(0)
const action_type = ref('message')
const contentKey = ref(0)
const templateData = ref({
  type: TemplateMessageType.Buttons,
  title: '',
  text: '',
  altText: '',
  actions: [actionMessage.default]
})

const errors = ref({ items: [], first: () => null })

onMounted(() => {
  if (props.data) {
    Object.assign(templateData.value, props.data)
    action_type.value = templateData.value.actions[0].type
  }
})

watch(templateData, (val) => {
  emit('input', val)
}, { deep: true })

const forceRerender = () => {
  contentKey.value++
}

const addMoreAction = () => {
  selected.value = templateData.value.actions.length
  templateData.value.actions.push({ ...actionMessage.default })
}

const changeSelected = (index) => {
  selected.value = index
  action_type.value = templateData.value.actions[index].type
}

const removeAction = (index) => {
  templateData.value.actions.splice(index, 1)
  selected.value = 0
  forceRerender()
}

const changeAction = (index, data) => {
  templateData.value.actions.splice(index, 1, data)
}
</script>

<style lang="scss" scoped>
  :deep() {
    .row {
      margin: 0 !important;
    }

    .group-title {
      flex-direction: column;
    }

    .nav-stacked > li {
      float: none;
      position: relative;
      display: block;
    }

    li {
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      .nav-button {
        width: 100% !important;
        display: flex !important;
        height: 40px;
        align-items: center !important;
        border: 1px solid #e4e4e4;
        padding-left: 10px;
      }

      .action-tab-selector-remover {
        padding: 5px;
        cursor: pointer;
        line-height: 1;
        align-items: center;
        margin-left: auto;
        display: inline-flex;
      }
    }

    li.active {
      .nav-button {
        border-left: 3px solid #727cf5;
        color: #727cf5;
        font-weight: bold;
      }
      .action-tab-selector-remover {
        color: white;
      }
    }

    .glyphicon-remove {
      font-size: 13px;
      margin-bottom: 2px;
    }
  }
</style>
