<template>
  <div class="d-flex">
    <img :src="imageUrl" v-if="imageUrl" class="banner me-2" :alt="altText">
    <div v-if="!imageUrl">
      <button
        type="button"
        class="btn btn-outline-primary mt-auto"
        @click="showModal"
      >
        {{ buttonTitle || "画像をアップロード" }}
      </button>
    </div>
    <div class="d-flex mt-auto flex-column" v-else>
      <button
        type="button"
        class="btn btn-outline-danger"
        @click="setImageUrl(null)"
      >
        削除
      </button>
      <button
        type="button"
        class="btn btn-outline-primary mt-1"
        @click="showModal"
      >
        変更
      </button>
    </div>
    <modal-select-media
      ref="modalRef"
      @select="onSelectMedia"
      :types="['image']"
      :filterable="false"
      :id="`imagemapModalUploadImage`"
    />
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import ModalSelectMedia from '../media/ModalSelectMedia.vue';

// Props
const props = defineProps({
  buttonTitle: {
    type: String,
    default: null
  },
  imageUrl: {
    type: String,
    default: null
  }
});

// Emits
const emit = defineEmits(['update:imageUrl']);

// Refs
const modalRef = ref(null);

// Computed
const altText = computed(() => {
  return props.imageUrl ? '選択された画像' : '';
});

// Methods
const onSelectMedia = (data) => {
  if (data) {
    setImageUrl(data.url);
  }
};

const setImageUrl = (url) => {
  emit('update:imageUrl', url);
};

const showModal = () => {
  modalRef.value?.show();
};
</script>

<style scoped>
.banner {
  width: 300px;
  height: auto;
  object-fit: contain;
}
</style>
