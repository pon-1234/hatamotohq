<template>
  <div class="row" :key="contentKey">
    <div class="col-lg-3">
      <div class="btn btn-secondary ml-1 d-block" data-toggle="modal" data-target="#modalSelectReminder">
        <span class="max-1-lines">{{ reminder.id ? reminder.name : "リマインダを選択する" }}</span>
      </div>
      <div>
        <input type="hidden" v-model="reminder.id" name="reminder_id" />
        <error-message class="w-100" :message="errors.first('reminder_id')"></error-message>
      </div>
    </div>

    <div class="col-lg-9 d-flex flex-start">
      <div class="flex-grow-1">
        <datetime
          v-model="goal"
          name="reminder_goal"
          class="mr-1"
          input-class="form-control"
          type="date"
          :phrases="{ ok: '確定', cancel: '閉じる' }"
          placeholder="日付を選択してください"
          :min-datetime="currentDate"
          value-zone="Asia/Tokyo"
          zone="Asia/Tokyo"
        ></datetime>
        <error-message :message="errors.first('reminder_goal')"></error-message>
      </div>
      <div class="btn btn-light mr-1 mb-auto" data-toggle="modal" data-target="#modalReminderPreview" hidden>
        プレビュー
      </div>
      <div class="btn btn-success fw-120 mb-auto" @click="submit()">開始</div>
    </div>
    <modal-select-reminder id="modalSelectReminder" @selectReminder="onSelectReminder($event)"></modal-select-reminder>

    <!-- START: modal survey preview -->
    <modal-reminder-preview :reminder_id="reminder.id" v-if="reminder"></modal-reminder-preview>
    <!-- END: modal survey preview -->
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useStore } from 'vuex'
import moment from 'moment'
import { Datetime } from 'vue-datetime'

const props = defineProps({
  friend_id: {
    type: Number,
    required: true
  }
})

const store = useStore()

const contentKey = ref(0)
const loading = ref(false)
const goal = ref(null)
const reminder = ref({
  id: null,
  name: null
})
const currentDate = ref(moment().tz('Asia/Tokyo').format())
const errors = ref({ first: () => null })

const forceRerender = () => {
  contentKey.value++
}

const submit = async () => {
  if (loading.value) return
  loading.value = true
  
  // Basic validation
  if (!reminder.value.id || !goal.value) {
    loading.value = false
    return
  }
  
  const payload = {
    friend_id: props.friend_id,
    reminder_id: reminder.value.id,
    goal: goal.value
  }
  const response = await store.dispatch('friend/setReminder', payload)
  if (response) {
    window.toastr.success('リマインダの設定は完了しました。')
    resetData()
  } else {
    window.toastr.error('リマインダの設定は失敗しました。')
  }
  loading.value = false
}

const resetData = () => {
  goal.value = null
  reminder.value = { id: null, name: null }
  forceRerender()
}

const onSelectReminder = (reminderData) => {
  reminder.value = reminderData
}
</script>

<style>
</style>