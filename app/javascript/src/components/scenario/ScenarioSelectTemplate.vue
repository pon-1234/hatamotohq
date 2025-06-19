<template>
  <section>
    <div data-toggle="modal" data-target="#modalSelectTemplate" class="btn btn-primary mw-150">テンプレートを追加</div>
    <modal-select-template @selectTemplate="onSelectTemplate" id="modalSelectTemplate"></modal-select-template>
  </section>
</template>

<script setup>
import { useStore } from 'vuex'

const props = defineProps({
  scenario_id: {
    type: Number,
    required: true
  }
})

const store = useStore()

const createMessagesFromTemplate = (payload) => store.dispatch('scenario/createMessagesFromTemplate', payload)

const onSelectTemplate = async (template) => {
  const payload = {
    scenario_id: props.scenario_id,
    template_id: template.id
  }
  await createMessagesFromTemplate(payload)
  location.reload()
}
</script>

<style>

</style>