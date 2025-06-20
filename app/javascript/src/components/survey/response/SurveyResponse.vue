<template>
  <div class="card">
    <div class="card-header">回答日時：{{ formattedTime(response.created_at) }}</div>
    <div class="card-body">
      <div class="d-flex py-2 border-bottom border-light">
        <div class="mw-200 mr-2 font-weight-bold">質問</div>
        <div class="flex-grow-1">回答</div>
      </div>
      <div v-for="(answer, index) in response.survey_answers" :key="index">
        <div class="divider my-2" v-if="index > 0"></div>
        <div class="d-flex my-1">
          <div class="mw-200 mr-2 font-weight-bold">{{ answer.survey_question.content["text"] }}</div>
          <div class="flex-grow-1">
            <div v-if="answer.survey_question.type === 'image'">
              <div :style="{ backgroundImage: `url(${answer.file_url})` }" class="fw-120 fh-81 background-cover"></div>
            </div>
            <div v-else-if="answer.survey_question.type === 'pdf'" class="d-flex">
              <img :src="`${rootPath}/images/messages/pdf.png`" class="fw-120 fh-120 background-cover" />
              <a class="btn btn-sm btn-light my-auto text-nowrap" :href="answer.file_url" download="lineinsight.pdf"
                >ダウンロード</a
              >
            </div>
            <p class="vw-60 item-name" v-else>{{ answer.answer || "未設定" }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  response: {
    type: Object,
    required: true
  }
})

const rootPath = import.meta.env.VITE_ROOT_PATH || ''

// フォーマット関数を定義
const formattedTime = (datetime) => {
  if (!datetime) return ''
  // Simple date formatting - you may want to use a proper date library
  const date = new Date(datetime)
  return date.toLocaleString('ja-JP')
}
</script>

<style>
</style>