<template>
  <div class="card">
    <div class="card-body">
      <div v-for="(answer, index) in response.survey_answers" :key="index">
        <div class="divider my-2" v-if="index > 0"></div>
        <div class="d-flex border-bottom border-light my-1">
          <div class="mw-300 mr-2 font-weight-bold">{{ answer.survey_question.content["text"] }}</div>
          <div class="mw-250">
            <div v-if="answer.survey_question.type === 'image'">
              <div v-lazy:background-image="answer.file_url" class="fw-120 fh-81 background-cover"></div>
            </div>
            <div v-else-if="answer.survey_question.type === 'pdf'" class="d-flex">
              <img :src="`${rootPath}/images/messages/pdf.png`" class="fw-120 fh-120 background-cover" />
              <a class="btn btn-sm btn-light my-auto text-nowrap" :href="answer.file_url" download="lineinsight.pdf"
                >ダウンロード</a
              >
            </div>
            <div v-else>
              {{ answer.answer || "未設定" }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['response']
};
</script>

<style>
</style>