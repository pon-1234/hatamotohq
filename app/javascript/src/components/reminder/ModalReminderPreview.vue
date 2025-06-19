<template>
  <div
    id="modalReminderPreview"
    class="modal fade"
    tabindex="-1"
    role="dialog"
    aria-labelledby="info-header-modalLabel"
    aria-hidden="true"
    ref="modalReminderPreview"
  >
    <div class="modal-dialog modal-xl">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="info-header-modalLabel">リマインダプレビュー</h5>
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        </div>
        <div class="modal-body" :key="contentKey">xxx</div>
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

const props = defineProps(['reminder_id'])
const store = useStore()

const reminder = ref(null)
const contentKey = ref(0)
const modalReminderPreview = ref(null)

const getReminder = (id) => store.dispatch('reminder/getReminder', id)

const forceRerender = () => {
  contentKey.value++
}

const onShow = async () => {
  reminder.value = await getReminder(props.reminder_id)
  forceRerender()
}

onMounted(() => {
  $(modalReminderPreview.value).on('show.bs.modal', onShow)
})
</script>
