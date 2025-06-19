<template>
  <div>
    <!-- <action-postback :showTitle="showTitle" v-model="data" v-if="data.type === 'postback'" :type="type" :name="name" :requiredLabel="requiredLabel"/> -->
    <action-send-message
      :showTitle="showTitle"
      v-model="data"
      v-if="data.type === 'message'"
      :name="name"
      :requiredLabel="requiredLabel"
    ></action-send-message>

    <action-open-url
      :showTitle="showTitle"
      v-model="data"
      v-if="data.type === 'uri' && regexUrl"
      :name="name"
      :requiredLabel="requiredLabel"
    ></action-open-url>

    <action-open-tel
      :showTitle="showTitle"
      v-model="data"
      v-if="data.type === 'uri' && regexUri"
      :name="name"
      :requiredLabel="requiredLabel"
    ></action-open-tel>

    <action-datetime-picker
      :showTitle="showTitle"
      v-model="data"
      v-if="data.type === 'datetimepicker'"
      :name="name"
      :requiredLabel="requiredLabel"
    ></action-datetime-picker>

    <action-survey
      :showTitle="showTitle"
      v-model="data"
      v-if="data.type === 'survey'"
      :name="name"
      :requiredLabel="requiredLabel"
    ></action-survey>

    <action-default
      :showTitle="showTitle"
      v-model="data"
      v-if="data.type === 'camera' || data.type === 'cameraRoll' || data.type === 'location'"
      :name="name"
      :requiredLabel="requiredLabel"
    ></action-default>
  </div>
</template>
<script setup>
import { computed, watch } from 'vue';
import Util from '../../../core/util';
import ActionSendMessage from './ActionSendMessage.vue';
import ActionOpenUrl from './ActionOpenUrl.vue';
import ActionOpenTel from './ActionOpenTel.vue';
import ActionDatetimePicker from './ActionDatetimePicker.vue';
import ActionSurvey from './ActionSurvey.vue';
import ActionDefault from '../ActionDefault.vue';

const props = defineProps({
  showTitle: {
    type: Boolean,
    default: true
  },
  modelValue: {
    type: Object,
    required: true
  },
  name: {
    type: String
  },
  type: {
    type: String
  },
  requiredLabel: {
    type: Boolean,
    default: true
  }
});

const emit = defineEmits(['update:modelValue']);

const data = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value)
});

const regexUrl = computed(() => {
  return props.modelValue.id ? props.modelValue.id === 1 : Util.validateUrl(props.modelValue.uri);
});

const regexUri = computed(() => {
  return props.modelValue.id ? props.modelValue.id === 2 : !Util.validateUrl(props.modelValue.uri);
});
</script>
