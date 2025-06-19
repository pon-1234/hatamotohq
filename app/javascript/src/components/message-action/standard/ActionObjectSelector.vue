<template>
  <div>
    <select v-model="selected" class="form-control w-100" @change="changeSelected">
      <option value="none" :disabled="!isNone" v-if="actionTypes && actionTypes.length > 1">
        - 選択してください -
      </option>
      <option v-for="(item, index) in actionTypes" :key="index" :value="item.id">
        {{ item.title }}
      </option>
    </select>
  </div>
</template>

<script setup>
import { ref, computed, onBeforeMount } from 'vue';
import { useActionObjectsType, useActionObjectsCollect } from '@/composables/useConstants';
import Util from '../../../core/util';

// Props
const props = defineProps({
  modelValue: {
    type: Object,
    required: true
  },
  isNone: {
    type: Boolean,
    default: false
  },
  supports: {
    type: Array,
    default: () => []
  },
  messageType: {
    type: String,
    default: null
  }
});

// Emits
const emit = defineEmits(['update:modelValue']);

// Composables
const ActionObjectsType = useActionObjectsType();
const ActionObjectsCollect = useActionObjectsCollect();

// State
const selected = ref(props.modelValue.id || 'none');

// Computed
const actionTypes = computed(() => {
  const objects = JSON.parse(JSON.stringify(ActionObjectsCollect));
  // with message is not rich image message, remove message action object
  if (props.messageType !== 'imagemap') {
    const index = objects.findIndex(object => object.type === 'message');
    if (index > -1) objects.splice(index, 1);
  }
  
  let result = objects != null
    ? objects.filter(
        item =>
          (props.supports.length > 0 ? props.supports.indexOf(item.type) >= 0 : true) && item.type !== 'postback'
      )
    : [];
    
  if (props.messageType === 'imagemap') {
    result = result.filter(item => item.title !== '電話する');
  }
  
  return result;
});

// Methods
const changeSelected = () => {
  emitObj(selected.value);
};

const emitObj = (value) => {
  // TODO this is bad smelling code :3 need refactoring
  let val = actionTypes.value.find(item => item.id === value);

  if (!val) {
    val = { type: 'none' };
  }
  
  if (val.type === props.modelValue.type) {
    if (!(val.type === 'uri' && val.id !== props.modelValue.id)) {
      return;
    }
  }

  let option = null;
  switch (val.type) {
    case 'none':
      option = { type: 'none' };
      break;
      
    case ActionObjectsType.Postback:
      option = {
        type: ActionObjectsType.Postback,
        label: null,
        data: {
          type: 'text',
          content: {
            text: null
          }
        }
      };
      break;

    case ActionObjectsType.Message:
      option = {
        type: ActionObjectsType.Message,
        label: '',
        text: ''
      };
      break;

    case ActionObjectsType.Uri:
      if (val.id === 1) {
        option = {
          id: 1,
          type: ActionObjectsType.Uri,
          label: '',
          uri: '',
          linkUri: ''
        };
      } else {
        option = {
          id: 2,
          type: ActionObjectsType.Uri,
          label: '',
          uri: '',
          linkUri: ''
        };
      }
      break;

    case ActionObjectsType.DatetimePicker:
      option = {
        type: ActionObjectsType.DatetimePicker,
        label: '',
        data: '',
        mode: 'date'
      };
      break;
      
    case ActionObjectsType.Camera:
      option = {
        type: ActionObjectsType.Camera,
        label: ''
      };
      break;
      
    case ActionObjectsType.CameraRoll:
      option = {
        type: ActionObjectsType.CameraRoll,
        label: ''
      };
      break;
      
    case ActionObjectsType.Location:
      option = {
        type: ActionObjectsType.Location,
        label: ''
      };
      break;
      
    case 'survey':
      option = {
        type: 'survey',
        label: '',
        content: {
          name: '',
          id: null
        }
      };
      break;
  }
  
  emit('update:modelValue', option);
};

// Lifecycle
onBeforeMount(() => {
  // TODO this is bad smelling code :3 need refactoring
  if (props.modelValue.type === 'uri') {
    selected.value = props.modelValue.id || (Util.validateUrl(props.modelValue.uri) ? 1 : 2);
  } else {
    const val = actionTypes.value.find(item => item.type === props.modelValue.type);
    selected.value = val ? val.id : 'none';
    emitObj(selected.value);
  }
});
</script>