<template>
  <section>
    <label class="w-100">
      コンテンツ
      <RequiredMark />
    </label>

    <div>
      <div
        @click="showModal = true"
        class="btn btn-secondary mw-150"
        v-if="currentTemplate.template_id"
      >
        <MessageContent :data="currentTemplate" v-if="currentTemplate.content" />
        <span v-else>{{ currentTemplate.name }}</span>
      </div>
      <div @click="showModal = true" class="btn btn-secondary mw-150" v-else>
        テンプレートを選択
      </div>
      <input
        type="hidden"
        v-model="currentTemplate.template_id"
        :name="name + '_template_id'"
        required
      />
      <ErrorMessage v-if="errorMessage" class="w-100" :message="errorMessage" />
    </div>

    <ModalSelectTemplate 
      v-model:show="showModal"
      @select-template="selectTemplate" 
    />
  </section>
</template>

<script setup>
import { ref, watch, computed, onMounted } from 'vue';
import RequiredMark from '../../common/RequiredMark.vue';
import ErrorMessage from '../../common/ErrorMessage.vue';
import ModalSelectTemplate from '../../common/ModalSelectTemplate.vue';
import MessageContent from '../../message/type/MessageContent.vue';

// Props
const props = defineProps({
  modelValue: {
    type: Object,
    default: () => ({
      template_id: null,
      name: 'テンプレートから作成'
    })
  },
  name: {
    type: String,
    default: 'postback_action'
  }
});

// Emits
const emit = defineEmits(['update:modelValue']);

// State
const showModal = ref(false);
const currentTemplate = ref({
  template_id: null,
  name: null
});

// Computed
const errorMessage = computed(() => {
  if (!currentTemplate.value.template_id) {
    return 'テンプレートは必須です';
  }
  return null;
});

// Methods
const selectTemplate = (template) => {
  currentTemplate.value = { 
    template_id: template.id, 
    ...template 
  };
  emit('update:modelValue', {
    name: template.name,
    template_id: template.id
  });
};

// Watch
watch(currentTemplate, (val) => {
  if (props.modelValue.template_id) {
    emit('update:modelValue', {
      name: val.name,
      template_id: props.modelValue.template_id
    });
  }
}, { deep: true });

// Lifecycle
onMounted(() => {
  if (props.modelValue.template_id) {
    currentTemplate.value = {
      template_id: props.modelValue.template_id,
      name: props.modelValue.name
    };
  }
});
</script>

<style scoped>
.btn-block {
  cursor: pointer;
}

.mw-150 {
  max-width: 150px;
}
</style>
