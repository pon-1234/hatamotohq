<template>
  <div>
    <input type="hidden" :value="question.id" :name="`answers[${qnum}][id]`" />
    <p class="w-100">
      <span class="border-success question-title mr-2 font-weight-bold">{{ `Q${qnum}` }}</span
      >{{ title }} <required-mark v-if="isRequired"></required-mark>
    </p>
    <div class="w-100 text-muted text-sm my-1">{{ subTitle }}</div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

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
</script>

<style lang="scss" scoped>
  .question-title {
    border-bottom: 3px solid #0acf97;
  }

  .text-sm {
    font-size: 0.7rem;
  }
</style>