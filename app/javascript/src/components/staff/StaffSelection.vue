<template>
  <div>
    <multiselect
      v-model="selectedStaff"
      :allow-empty="true"
      :options="agents"
      :option-height="60"
      :show-labels="false"
      placeholder="未割り当て"
      noOptions="データはありません"
      label="name"
      track-by="id"
      :multiple="false"
      :showNoResults="false"
      @select="onSelected"
      @remove="onSelected(null)"
      @open="emit('open', agents.length)"
      @close="emit('close')"
    >
      <template slot="singleLabel" slot-scope="props">
        <div class="d-flex align-items-center">
          <img class="option-image" :src="props.option.avatar_url || '/img/no-image-profile.png'" alt="Staff avatar" />
          <span class="ml-2">{{ props.option.name.slice(0, 12) + (props.option.name.length > 12 ? '...' : '') }}</span>
        </div>
      </template>
      <template slot="option" slot-scope="props">
        <div class="d-flex align-items-center">
          <img class="option-image" :src="props.option.avatar_url || '/img/no-image-profile.png'" alt="Staff avatar" />
          <span class="ml-2">{{ props.option.name.slice(0, 15) + (props.option.name.length > 15 ? '...' : '') }}</span>
        </div>
      </template>
      <span slot="noResult">担当者が見つかりません</span>
    </multiselect>
  </div>
</template>
<script setup>
import { ref, onBeforeMount } from 'vue'
import { useStore } from 'vuex'

const props = defineProps({
  selected: {
    type: Number,
    required: false
  }
})

const emit = defineEmits(['select', 'open', 'close'])

const store = useStore()

const selectedStaff = ref(null)
const agents = ref([])

const getAllStaffs = () => store.dispatch('staff/getAllStaffs')
const assign = (payload) => store.dispatch('channel/assign', payload)
const unassign = (payload) => store.dispatch('channel/unassign', payload)

onBeforeMount(async () => {
  const response = await getAllStaffs()
  if (!response) return
  agents.value = response
  if (props.selected) findStaff(props.selected)
})

const onSelected = async (agent) => {
  emit('select', agent ? agent.id : null)
}

const findStaff = (staffId) => {
  selectedStaff.value = agents.value.find(_ => _.id === staffId)
}
</script>
 <style lang="scss" scoped>
  :deep() {
    .option-image {
      width: 25px;
      height: 25px;
      border-radius: 50%;
      background-size: cover;
    }
    .multiselect__tags {
      height: 40px !important;
    }
  }
</style>