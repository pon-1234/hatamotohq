<template>
  <div>
    <template v-if="locked">
      <div class="btn btn-sm btn-info" data-toggle="modal" data-target="#modalConfirmToggleLocked">アンブロック</div>
    </template>
    <template v-else>
      <div class="btn btn-sm btn-danger" data-toggle="modal" data-target="#modalConfirmToggleLocked">ブロック</div>
    </template>
    <template>
      <modal-confirm
        id="modalConfirmToggleLocked"
        title="友達状況の変更してもよろしいですか？"
        type="confirm"
        @confirm="toggle()"
      >
        <template v-slot:content>
          <b>{{ locked ? "ブロックした" : "有効" }}</b> <i class="mdi mdi-arrow-right-bold"></i>
          <b>{{ locked ? "有効" : "ブロックした" }}</b>
        </template>
      </modal-confirm>
    </template>
  </div>
</template>

<script setup>
import { useStore } from 'vuex'

const props = defineProps({
  id: {
    type: Number
  },
  locked: {
    type: Boolean
  }
})

const store = useStore()

const toggle = async () => {
  await store.dispatch('friend/toggleLocked', props.id)
  setTimeout(() => {
    location.reload()
  }, 300)
}
</script>
