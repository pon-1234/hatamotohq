<template>
  <div>
    <div>
      <label for="question_title">質問文</label>
      <required-mark />
      <input
        class="form-control"
        :name="'confirm-label' + indexParent"
        placeholder="質問文を入力してください"
        maxlength="241"
        autocomplete="off"
        type="text"
        v-model.trim="messageData.text"
        data-vv-as="質問文"
      />
      <error-message :message="errors.first('confirm-label' + indexParent)" />
    </div>

    <ul class="w-100 nav nav-tabs nav-bordered mt-2">
      <li class="nav-item" v-for="(item, index) in messageData.actions" :key="index">
        <a
          :href="`#messageAction${index}`"
          data-toggle="tab"
          @click="editingActionIndex = index"
          :aria-expanded="editingActionIndex === index"
          :class="editingActionIndex === index ? 'nav-link active' : 'nav-link'"
        >
          <i class="mdi mdi-home-variant d-md-none d-block"></i>
          <span class="d-none d-md-block">選択肢{{ index + 1 }}</span>
        </a>
      </li>
    </ul>

    <div class="w-100 tab-content">
      <div
        :class="editingActionIndex === index ? 'tab-pane show active' : 'tab-pane'"
        v-for="(item, index) in messageData.actions"
        :key="index"
        :id="`messageAction${index}`"
      >
        <div>
          <action-editor
            :index="index"
            :name="`message${indexParent}Confirm${index}`"
            :value="item"
            :supports="['postback', 'uri', 'message', 'datetimepicker', 'survey']"
            @input="changeAction(index, ...arguments)"
          ></action-editor>
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

const editingActionIndex = ref(0)
const messageData = ref({
  type: TemplateMessageType.Confirm,
  text: '',
  actions: [actionMessage.default, actionMessage.default]
})

const errors = ref({ items: [], first: () => null })

watch(messageData, (val) => {
  emit('input', val)
}, { deep: true })

onMounted(() => {
  if (props.data) {
    Object.assign(messageData.value, props.data)
  }
})

const changeSelectedAction = (index, value) => {
  messageData.value.actions.splice(index, 1, value)
}

const changeAction = (index, data) => {
  messageData.value.actions.splice(index, 1, data)
}
</script>

<style lang="scss" scoped>
  :deep() {
    .template-confirm {
      padding: 0px;
      margin: 0px !important;
    }
  }
</style>
