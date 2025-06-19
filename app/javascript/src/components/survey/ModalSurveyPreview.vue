<template>
  <div
    id="modalSurveyPreview"
    class="modal fade"
    tabindex="-1"
    role="dialog"
    aria-labelledby="info-header-modalLabel"
    aria-hidden="true"
    ref="modalSurveyPreview"
  >
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="info-header-modalLabel">回答フォームプレビュー</h5>
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        </div>
        <div class="modal-body" :key="contentKey">
          <survey-form-content :survey="survey" :preview="true"></survey-form-content>
        </div>
      </div>
      <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
  </div>
  <!-- /.modal -->
</template>
<script setup>
import { ref, onMounted } from 'vue'
import { useStore } from 'vuex'

const props = defineProps({
  survey_id: {
    type: [String, Number],
    required: true
  }
})

const store = useStore()
const modalSurveyPreview = ref(null)
const survey = ref(null)
const contentKey = ref(0)

const forceRerender = () => {
  contentKey.value++
}

const onShow = async () => {
  survey.value = await store.dispatch('survey/getSurvey', props.survey_id)
  forceRerender()
}

onMounted(() => {
  $(modalSurveyPreview.value).on('show.bs.modal', onShow)
})
</script>
