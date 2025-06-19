<template>
  <form
    ref="form"
    @submit.prevent="onSubmit"
    :action="formAction"
    method="post"
    enctype="multipart/form-data"
  >
    <input type="hidden" name="authenticity_token" :value="csrfToken" />
    <div class="card" v-if="survey">
      <div class="card-body">
        <survey-form-content :survey="survey" :preview="false"></survey-form-content>
      </div>
      <div class="card-footer border-top border-success text-align-center">
        <button type="submit" class="btn btn-success fw-120">送信</button>
      </div>
      <loading-indicator :loading="loading"></loading-indicator>
    </div>
    <div class="alert alert-warning" role="alert" v-if="!survey && !loading">
      <h4 class="alert-heading">エラー</h4>
      <p>アクセスが拒否されました。</p>
    </div>
  </form>
</template>

<script setup>
import { ref, computed, onBeforeMount, provide } from 'vue'
import { useStore } from 'vuex'
import Util from '@/core/util.js'

const props = defineProps({
  code: {
    type: Number,
    required: true
  },
  friend_id: {
    type: String,
    required: true
  }
})

const store = useStore()
const form = ref(null)

const userRootUrl = process.env.MIX_ROOT_PATH
const csrfToken = Util.getCsrfToken()
const loading = ref(true)
const survey = ref(null)

const formAction = computed(() => {
  return `${userRootUrl}/surveys/${props.code}/${props.friend_id}`
})

// Provide a mock validator for child components
provide('parentValidator', null)

const getSurveyByCode = (code) => store.dispatch('survey/getSurveyByCode', code)

const onSubmit = async () => {
  // Since ValidationObserver is not available in this migration,
  // we'll submit the form directly and rely on HTML5 validation
  form.value.submit()
}

onBeforeMount(async () => {
  survey.value = await getSurveyByCode(props.code)
  loading.value = false
})
</script>

<style>
</style>