<template>
  <section>
    <div>
      <label class="w-100 mt-2">タグ設定</label>
      <div class="row m-0">
        <div class="col-md-6 d-flex-auto p-0">
          <span>タグを追加</span>
          <div>
            <InputTag 
              :all-tags="true" 
              :model-value="localValue[0].tags" 
              @update:model-value="onAssignTagsDataChanged"
            />
            <input type="hidden" v-model.trim="localValue" :name="name + '_assign_tag'" />
          </div>
        </div>

        <div class="col-md-6 d-flex-auto">
          <span>タグをはずす</span>
          <div>
            <InputTag 
              :all-tags="true" 
              :model-value="localValue[1].tags" 
              @update:model-value="onUnassignTagsDataChanged"
            />
            <input type="hidden" v-model.trim="localValue" :name="name + '_unassign_tag'" />
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, watch } from 'vue';
import InputTag from '../../input/InputTag.vue';

// Props
const props = defineProps({
  modelValue: {
    type: Array,
    default: () => [
      {
        type: 'assign',
        tags: []
      },
      {
        type: 'unassign',
        tags: []
      }
    ]
  },
  name: {
    type: String,
    default: 'postback_action'
  }
});

// Emits
const emit = defineEmits(['update:modelValue']);

// State
const localValue = ref(JSON.parse(JSON.stringify(props.modelValue)));

// Methods
const onAssignTagsDataChanged = (tags) => {
  localValue.value[0].tags = tags;
  emit('update:modelValue', localValue.value);
};

const onUnassignTagsDataChanged = (tags) => {
  localValue.value[1].tags = tags;
  emit('update:modelValue', localValue.value);
};

// Watch
watch(() => props.modelValue, (newVal) => {
  localValue.value = JSON.parse(JSON.stringify(newVal));
}, { deep: true });
</script>