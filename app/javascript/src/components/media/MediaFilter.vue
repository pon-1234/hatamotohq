<template>
  <div class="d-flex align-items-center">
    <div class="filter-list">
      <div class="checkbox-inline" v-for="option in options" :key="option.type">
        <div class="custom-control custom-checkbox mr-4">
          <input
            type="checkbox"
            :value="option.type"
            v-model="selectedTypes"
            class="custom-control-input"
            :id="option.type"
          />
          <label class="custom-control-label text-nowrap" :for="option.type">{{ option.text }}</label>
        </div>
      </div>
    </div>
    <div class="btn btn-primary text-nowrap" @click="applyFilter">表示変更</div>
  </div>
</template>
<script setup>
import { ref } from 'vue'
import { useStore } from 'vuex'

const emit = defineEmits(['filterChanged'])
const store = useStore()

const options = ref([
  { type: 'image', text: '画像' },
  { type: 'audio', text: '音声' },
  { type: 'video', text: '動画' },
  { type: 'richmenu', text: 'メニュー画像' }
])

const selectedTypes = ref(['image', 'audio', 'video', 'richmenu'])

const applyFilter = () => {
  store.commit('media/setFilter', selectedTypes.value)
  emit('filterChanged')
}
</script>
<style lang="scss" scoped>
  .form-check-label {
    margin-bottom: 0px !important;
    font-size: 16px !important;
  }

  .filter-list {
    display: inline-flex;
    align-items: center;
  }

  .btn-default {
    margin-left: 10px;
  }

  @media (max-width: 1000px) {
    .filter-list {
      width: 75%;
      display: flex;
      flex-wrap: wrap;
    }

    .checkbox-inline {
      width: 50%;
    }
  }

  @media (max-width: 677px) {
    .checkbox-inline {
      width: 100%;
    }
  }

</style>
