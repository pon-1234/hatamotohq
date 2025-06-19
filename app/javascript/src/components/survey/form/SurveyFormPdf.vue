<template>
  <div>
    <survey-question-header :question="question" :qnum="qnum"></survey-question-header>
    <div class="form-group mt-2">
      <div class="input-group">
        <div class="custom-file">
          <input
            type="file"
            class="custom-file-input"
            :id="`inputFile${qnum}`"
            accept="application/pdf"
            :name="`answers[${qnum}][answer]`"
            @change="onFileChange"
            :required="isRequired"
          />
          <label class="custom-file-label" :for="`inputFile${qnum}`">{{ fileName || "ファイルを選択" }}</label>
        </div>
      </div>
      <error-message message="ファイルの形式が無効です。" v-if="!isValidMineType"></error-message>
      <input type="hidden" v-model="fileName" />
      <error-message :message="errorMessage"></error-message>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const props = defineProps({
  question: {
    type: Object,
    required: true
  },
  qnum: {
    type: Number,
    required: true
  }
})

const fileName = ref(null)
const isValidMineType = ref(true)
const errorMessage = ref('')

const prefix = computed(() => {
  return `surveyQuestion${props.qnum}`
})

const isRequired = computed(() => {
  return props.question ? props.question.required : false
})

const content = computed(() => {
  return props.question ? props.question.content : ''
})

const title = computed(() => {
  return content.value ? content.value.text : ''
})

const subTitle = computed(() => {
  return content.value ? content.value.sub_text : ''
})

const onFileChange = (event) => {
  const fileData = event.target.files[0]
  fileName.value = null
  isValidMineType.value = false
  if (fileData && fileData.type === 'application/pdf') {
    isValidMineType.value = true
    fileName.value = fileData.name
  }
}
</script>