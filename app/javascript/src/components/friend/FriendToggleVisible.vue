<template>
  <div>
    <template v-if="visible">
      <div class="btn btn-sm btn-secondary" data-toggle="modal" data-target="#modalConfirmToggleVisible">未表示</div>
    </template>
    <template v-else>
      <div class="btn btn-sm btn-secondary" data-toggle="modal" data-target="#modalConfirmToggleVisible">表示</div>
    </template>

    <modal-confirm id="modalConfirmToggleVisible" title="友達表示状況の変更してもよろしいですか？" type="confirm" @confirm="toggle()">
      <template v-slot:content>
        <b>{{ visible ? '表示' : '未表示' }}</b> <i class="mdi mdi-arrow-right-bold"></i> <b>{{ visible ? '未表示' : '表示' }}</b>
      </template>
    </modal-confirm>
  </div>
</template>

<script setup>
import { useStore } from 'vuex'

const props = defineProps({
  id: {
    type: Number
  },
  visible: {
    type: Boolean
  }
})

const store = useStore()

const toggle = async () => {
  await store.dispatch('friend/toggleVisible', props.id)
  location.reload()
}
</script>
