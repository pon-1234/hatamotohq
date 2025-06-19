<template>
  <section>
    <div>
      <label class="w-100 mt-2"> リマインダ設定</label>
      <div class="m-0">
        <div>
          <div class="custom-control custom-radio custom-control-inline">
            <input
              type="radio"
              :id="`${name}typeSet`"
              :name="`${name}_type`"
              value="set"
              v-model="localActionData.type"
              @change="onDataChanged()"
              class="custom-control-input"
            />
            <label class="custom-control-label" :for="`${name}typeSet`">リマインダを開始</label>
          </div>
          <div class="custom-control custom-radio custom-control-inline">
            <input
              type="radio"
              :id="`${name}typeUnset`"
              :name="`${name}_type`"
              value="unset"
              v-model="localActionData.type"
              @change="onDataChanged()"
              class="custom-control-input"
            />
            <label class="custom-control-label" :for="`${name}typeUnset`">リマインダをキャンセル</label>
          </div>
        </div>
        <div class="mt-2 d-flex">
          <label class="fw-150">リマインダ選択</label>
          <div class="mw-200 mxw-400">
            <div class="btn btn-secondary w-100" @click="showReminderModal = true">
              <span class="max-1-lines">{{
                localActionData.reminder.id ? localActionData.reminder.name : "リマインダを選択する"
              }}</span>
            </div>
            <input
              type="hidden"
              v-model="localActionData.reminder.id"
              :name="name + '_reminder_id'"
              :class="{ 'is-invalid': reminderError }"
            />
            <error-message class="w-100" :message="reminderError"></error-message>
          </div>
        </div>
        <div class="mt-2 d-flex" v-if="localActionData.type === 'set'">
          <label class="fw-150">ゴール日</label>
          <div class="flex-grow-1">
            <datetime
              v-model="localActionData.goal"
              :name="name + '_reminder_goal'"
              input-class="form-control"
              type="date"
              :phrases="{ ok: '確定', cancel: '閉じる' }"
              placeholder="日付を選択してください"
              :min-datetime="currentDate"
              value-zone="Asia/Tokyo"
              zone="Asia/Tokyo"
              :class="{ 'is-invalid': goalError }"
            ></datetime>
            <error-message :message="goalError"></error-message>
          </div>
        </div>
      </div>
    </div>
    <modal-select-reminder
      v-model="showReminderModal"
      @selectReminder="onSelectReminder($event)"
    ></modal-select-reminder>
  </section>
</template>

<script setup>
import { ref, reactive, computed, watch } from 'vue';
import moment from 'moment';
import { Datetime } from 'vue-datetime';
import ModalSelectReminder from '../../common/ModalSelectReminder.vue';
import ErrorMessage from '../../common/ErrorMessage.vue';

const props = defineProps({
  modelValue: {
    type: Object,
    default: () => ({
      type: 'set',
      reminder: {
        id: null,
        name: null
      },
      goal: null
    })
  },
  name: {
    type: String,
    default: 'postback_action'
  }
});

const emit = defineEmits(['update:modelValue']);

const localActionData = reactive({
  type: props.modelValue.type || 'set',
  reminder: {
    id: props.modelValue.reminder?.id || null,
    name: props.modelValue.reminder?.name || null
  },
  goal: props.modelValue.goal || null
});

const showReminderModal = ref(false);
const currentDate = moment().tz('Asia/Tokyo').format();

const reminderError = ref('');
const goalError = ref('');

watch(() => props.modelValue, (newValue) => {
  localActionData.type = newValue.type || 'set';
  localActionData.reminder.id = newValue.reminder?.id || null;
  localActionData.reminder.name = newValue.reminder?.name || null;
  localActionData.goal = newValue.goal || null;
}, { deep: true });

watch(() => localActionData.reminder.id, () => {
  validateReminder();
});

watch(() => localActionData.goal, () => {
  validateGoal();
});

const validateReminder = () => {
  if (!localActionData.reminder.id) {
    reminderError.value = 'リマインダを入力してください。';
  } else {
    reminderError.value = '';
  }
};

const validateGoal = () => {
  if (localActionData.type === 'set' && !localActionData.goal) {
    goalError.value = 'ゴール日を入力してください。';
  } else {
    goalError.value = '';
  }
};

const onSelectReminder = (reminder) => {
  localActionData.reminder = {
    id: reminder.id,
    name: reminder.name
  };
  onDataChanged();
};

const onDataChanged = () => {
  validateReminder();
  validateGoal();
  emit('update:modelValue', {
    type: localActionData.type,
    reminder: {
      id: localActionData.reminder.id,
      name: localActionData.reminder.name
    },
    goal: localActionData.goal
  });
};

defineExpose({
  validate: () => {
    validateReminder();
    validateGoal();
    return !reminderError.value && (!goalError.value || localActionData.type === 'unset');
  }
});
</script>