<template>
  <div class="input-group input-group-merge">
    <div class="input-group input-group-merge">
      <input
        :type="inputType"
        class="form-control"
        :name="name"
        placeholder="パスワードを入力してください"
        :value="modelValue"
        @input="onInput"
        required
      />
      <div class="input-group-append" @click="toggle">
        <div class="input-group-text" :class="{ 'show-password': inputType === 'text' }">
          <span class="password-eye"></span>
        </div>
      </div>
    </div>
    <ErrorMessage v-if="errorMessage" :message="errorMessage" />
  </div>
</template>

<script setup>
import { ref } from 'vue';
import ErrorMessage from '../common/ErrorMessage.vue';

// Props
const props = defineProps({
  name: {
    type: String,
    required: true
  },
  modelValue: {
    type: String,
    default: ''
  },
  errorMessage: {
    type: String,
    default: null
  }
});

// Emits
const emit = defineEmits(['update:modelValue']);

// State
const inputType = ref('password');

// Methods
const toggle = () => {
  inputType.value = inputType.value === 'password' ? 'text' : 'password';
};

const onInput = (event) => {
  emit('update:modelValue', event.target.value.trim());
};
</script>

<style scoped>
.input-group-append {
  cursor: pointer;
}

.password-eye {
  display: inline-block;
  width: 20px;
  height: 20px;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2'%3E%3Cpath d='M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z'%3E%3C/path%3E%3Ccircle cx='12' cy='12' r='3'%3E%3C/circle%3E%3C/svg%3E");
  background-size: contain;
  background-repeat: no-repeat;
  background-position: center;
}

.show-password .password-eye {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2'%3E%3Cpath d='M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24'%3E%3C/path%3E%3Cline x1='1' y1='1' x2='23' y2='23'%3E%3C/line%3E%3C/svg%3E");
}
</style>