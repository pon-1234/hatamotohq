<template>
  <div>
    <div class="mt-2" v-if="isSupportPostback">
      <div class="custom-control custom-radio custom-control-inline">
        <input
          type="radio"
          :id="`${name}ActionCategoryCustom${index}`"
          :name="name + '_message_action_type'"
          value="default"
          :checked="type === 'default'"
          @change="changeType('default')"
          class="custom-control-input"
        />
        <label class="custom-control-label" :for="`${name}ActionCategoryCustom${index}`">カスタムアクション</label>
      </div>
      <div class="custom-control custom-radio custom-control-inline">
        <input
          type="radio"
          :id="`${name}ActionCategoryBasic${index}`"
          :name="name + '_message_action_type'"
          value="basic"
          :checked="type === 'basic'"
          @change="changeType('basic')"
          class="custom-control-input"
        />
        <label class="custom-control-label" :for="`${name}ActionCategoryBasic${index}`">基本アクション</label>
      </div>
    </div>

    <div class="mt-2">
      <ActionEditorCustom
        v-if="type === 'default' && isSupportPostback"
        :name="name"
        :model-value="data"
        :required-label="requiredLabel"
        :show-title="showTitle"
        @update:model-value="updateAction"
      />

      <ActionEditorStandard
        v-if="type === 'basic'"
        :model-value="data"
        :name="name"
        :supports="supports"
        :is-none="isNone"
        :show-title="showTitle"
        :required-label="requiredLabel"
        :message-type="messageType"
        @update:model-value="updateAction"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, watch, onMounted } from 'vue';
import { useActionMessage, useActionObjectsType } from '@/composables/useConstants';
import ActionEditorCustom from './ActionEditorCustom.vue';
import ActionEditorStandard from './ActionEditorStandard.vue';

// Props
const props = defineProps({
  index: {
    type: Number,
    default: 0
  },
  name: {
    type: String,
    required: true
  },
  supports: {
    type: Array,
    default: () => []
  },
  requiredLabel: {
    type: Boolean,
    default: true
  },
  isNone: {
    type: Boolean,
    default: false
  },
  showTitle: {
    type: Boolean,
    default: true
  },
  modelValue: {
    type: Object,
    default: null
  },
  messageType: {
    type: String,
    default: null
  }
});

// Emits
const emit = defineEmits(['update:modelValue']);

// Composables
const ActionMessage = useActionMessage();
const ActionObjectsType = useActionObjectsType();

// State
const type = ref('default');
const isSupportPostback = ref(true);
const data = ref(JSON.parse(JSON.stringify(ActionMessage.default)));
const tempData = reactive({
  default: null,
  basic: null
});

// Methods
const updateAction = (action) => {
  emit('update:modelValue', action);
};

const changeType = (newType) => {
  data.value = tempData[newType];
  type.value = newType;
  emit('update:modelValue', data.value);
};

const setupData = () => {
  data.value = JSON.parse(JSON.stringify(props.modelValue));
  if (data.value.type === 'postback') {
    type.value = 'default';
  } else {
    type.value = 'basic';
  }
  tempData[type.value] = JSON.parse(JSON.stringify(props.modelValue));
};

// Watch
watch(() => props.modelValue, (val) => {
  if (val) {
    setupData();
  }
}, { deep: true });

// Lifecycle
onMounted(() => {
  tempData.default = JSON.parse(JSON.stringify(ActionMessage.default));
  
  tempData.basic = props.isNone
    ? { type: 'none' }
    : {
        id: 1,
        type: ActionObjectsType.Uri,
        label: '',
        uri: '',
        linkUri: ''
      };
      
  if (!props.modelValue) {
    return;
  }

  setupData();

  if (props.supports && !props.supports.includes('postback')) {
    type.value = 'basic';
    isSupportPostback.value = false;
  }
});
</script>
