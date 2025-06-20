<template>
  <section>

    <div v-if="isLoading">
      Loading...
    </div>
    <div v-else-if="isError">
      ERR:ERR
      <button @click="fetchData()"> RETRY</button>
    </div>
    <div v-else>
      <div class="tbl-admin01 tbl-linebot01 table-responsive fz14 text-center" style="overflow-x: scroll">
        <table class="table table-hover table-scenario">
          <thead>
          <tr>
            <th class="">No.</th>
            <th class="w30">回答日時</th>
            <th class="w30">回答者名</th>
            <th class=""></th>
          </tr>
          </thead>
          <tbody v-if="responseLists.length === 0">
          <tr>
            <td colspan="2">
              データなし
            </td>
            <td>
            </td>
          </tr>
          </tbody>
          <tbody v-else>
          <tr v-for="(object, index) of responseLists" :key="index">
            <td>
              {{index + 1}}
            </td>
            <td>
              {{ object.created}}
            </td>

            <td style="max-width: 300px; overflow: hidden; text-overflow: ellipsis">
              {{object.display_name || object.line_name}}
            </td>
            <td>
              <div class="btn-edit01">
                <a class="btn-more btn-more-linebot btn-block" @click="showAnswerDetail(data, object.survey_customer_id)">
                  回答表示
                </a>
              </div>
            </td>
          </tr>
          </tbody>
        </table>
      </div>
    </div>

  </section>
</template>

<script setup>
import { ref, computed, onBeforeMount } from 'vue'
import { useStore } from 'vuex'

const props = defineProps({
  data: {
    type: [String, Number],
    required: true
  },
  route: {
    type: String
  }
})

const store = useStore()

const responseLists = ref([])
const focus = ref(null)
const isLoading = ref(true)
const isError = ref(false)

const friend = computed(() => store.state.friend.friend)

const fetchData = async () => {
  isLoading.value = true
  isError.value = false
  try {
    const res = await store.dispatch('survey/getCustomers', { id: props.data })
    responseLists.value = res
    isLoading.value = false
  } catch (error) {
    // show error
    isLoading.value = false
    isError.value = true
  }
}

const showAnswerDetail = async (surveyId, answerId) => {
  window.location.href = import.meta.env.VITE_ROOT_PATH + '/surveys/' + surveyId + '/answer/' + answerId
}

const changeTilteActiveChannel = (title) => {
  if (focus.value != null) {
    responseLists.value[focus.value].display_name = title
    // this.blink();
  }
}

onBeforeMount(() => {
  console.log(props.data)
  fetchData()
})
</script>
