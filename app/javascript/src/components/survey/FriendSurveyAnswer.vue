<template>
  <div v-if="isLoading">
    Loading...
  </div>
  <div v-else-if="isError">
    ERR:ERR
    <button @click="fetchData()"> RETRY</button>
  </div>
  <div v-else-if="responseLists.length === 0" style="padding: 10px; text-align: center;">
      データなし
  </div>
  <table v-else class="table table-hover table-scenario">
    <thead>
      <tr>
        <th>No.</th>
        <th>アンケート名</th>
        <th>質問の1問目の回答</th>
        <th></th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="(object, index) of responseLists" :key="index">
        <td>{{ 1 + Number(index) }}</td>
        <td>{{ object.survey_name }}</td>
        <td>
          <div style="vertical-align: top; padding: 10px; position: relative" v-if="object.first_answer.content">
            <div v-if="object.first_answer.content.type === 'file'">
              <img style="width: 150px; margin-bottom: 10px"
                    :src="`${SERVEY_MEDIA_FLEXA_URL}/${object.first_answer.content.content.alias}`"
                    v-if="object.first_answer.content.content.mine_type.includes('image/')">
              <div style="width: 150px; font-size: 60px" v-else><i class="fa fa-file"></i></div>
              <div>
                <a style="color: #ea5516"
                    :href="`${SERVEY_MEDIA_FLEXA_URL}/${object.first_answer.content.content.alias}`"
                    target="_blank">
                  <i
                    class="fa fa-download"></i><span>{{trimMidString(object.first_answer.content.content.name, 25, 10)}}</span>
                </a>
              </div>
            </div>
            <div v-else style="word-break: break-word">
              {{autoText(object.first_answer.content.content)}}
            </div>
          </div>
        </td>
        <td>
          <div class="btn-edit01">
            <a class="btn-more btn-more-linebot btn-block" :href="ROOT_PATH + '/surveys/' + object.survey_id + '/answer/' + object.survey_customer_id"> 回答表示 </a>
          </div>
        </td>
      </tr>
    </tbody>
  </table>
</template>
<script setup>
import { ref, onBeforeMount } from 'vue'
import { useStore } from 'vuex'

const props = defineProps({
  friendId: {
    type: [String, Number],
    required: true
  }
})

const store = useStore()

const SERVEY_MEDIA_FLEXA_URL = import.meta.env.VITE_SERVEY_MEDIA_FLEXA_URL
const ROOT_PATH = import.meta.env.VITE_ROOT_PATH
const responseLists = ref([])
const isLoading = ref(true)
const isError = ref(false)

const fetchData = async () => {
  isLoading.value = true
  isError.value = false
  try {
    const res = await store.dispatch('survey/friendAnswers', { id: props.friendId })
    console.log(res)
    responseLists.value = res
    isLoading.value = false
  } catch (error) {
    // show error
    isLoading.value = false
    isError.value = true
  }
}

const trimMidString = (originStr, maxChars, trailingCharCount) => {
  let shrinkedStr = originStr
  const shrinkedLength = maxChars - trailingCharCount - 3
  if (originStr.length > shrinkedLength) {
    const front = originStr.substr(0, shrinkedLength)
    const mid = '...'
    const end = originStr.substr(-trailingCharCount)
    shrinkedStr = front + mid + end
  }
  return shrinkedStr
}

const autoText = (data) => {
  return Array.isArray(data) ? data.join(', ') : data
}

onBeforeMount(() => {
  fetchData()
})
</script>
