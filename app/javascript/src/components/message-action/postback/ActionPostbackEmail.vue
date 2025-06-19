<template>
  <div>
    <div>
      <label> 宛先 </label>
      <input
        type="text"
        :value="form.emails"
        :name="name + '_postback_email'"
        v-validate="'required'"
        class="d-none"
        data-vv-as="宛先"
      />
      <div class="email-tags-container" :class="{ 'is-invalid': errors.first(name + '_postback_email') }">
        <div class="email-tags-wrapper">
          <span v-for="(email, index) in form.emails" :key="index" class="email-tag">
            {{ email }}
            <button type="button" class="email-tag-remove" @click="removeEmail(index)">
              <i class="fas fa-times"></i>
            </button>
          </span>
          <input
            ref="emailInput"
            v-model="currentEmail"
            type="email"
            class="email-input"
            placeholder="メールアドレスを入力してください。"
            @keydown.enter.prevent="addEmail"
            @keydown.space.prevent="addEmail"
            @keydown.comma.prevent="addEmail"
            @keydown.semicolon.prevent="addEmail"
            @blur="addEmail"
          />
        </div>
        <button type="button" class="btn btn-sm btn-secondary add-email-btn" @click="addEmail">
          追加
        </button>
      </div>
      <div v-if="emailError" class="text-danger small mt-1">{{ emailError }}</div>
      <error-message :message="errors.first(name + '_postback_email')"></error-message>
    </div>

    <div class="mt-4">
      <label>本文</label>
      <textarea
        class="form-control"
        :name="name + '_postback_text_email'"
        rows="4"
        v-model.trim="form.text"
        placeholder="入力してください"
        v-validate="'required'"
        data-vv-as="本文"
      ></textarea>
      <div class="text-sm">
        <p class="m-0">{name}：お客様の名前</p>
      </div>
      <error-message :message="errors.first(name + '_postback_text_email')"></error-message>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, watch, inject, onMounted } from 'vue';

// Props
const props = defineProps({
  value: {
    type: Object,
    default: () => ({
      emails: [],
      text: null
    })
  },
  name: {
    type: String,
    default: 'postback_action'
  }
});

// Emits
const emit = defineEmits(['input']);

// Inject parent validator
const parentValidator = inject('parentValidator');
const errors = parentValidator ? parentValidator.errors : { first: () => null };

// Refs
const emailInput = ref(null);
const currentEmail = ref('');
const emailError = ref('');

// Reactive form data
const form = reactive({
  emails: props.value.emails || [],
  text: props.value.text || ''
});

// Email validation regex
const emailRegex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

// Methods
const validateEmail = (email) => {
  return emailRegex.test(email);
};

const addEmail = () => {
  const email = currentEmail.value.trim();
  if (!email) return;

  emailError.value = '';

  if (!validateEmail(email)) {
    emailError.value = '有効なメールアドレスを入力してください。';
    return;
  }

  if (form.emails.includes(email)) {
    emailError.value = '宛先が重複しています。';
    return;
  }

  form.emails.push(email);
  currentEmail.value = '';
  emailInput.value?.focus();
};

const removeEmail = (index) => {
  form.emails.splice(index, 1);
};

// Watch form changes
watch(form, (newValue) => {
  emit('input', newValue);
}, { deep: true });

// Set up validator on mount
onMounted(() => {
  if (parentValidator) {
    // Vue 2 vee-validate compatibility
    // This might need adjustment based on the actual validator implementation
  }
});
</script>

<style scoped lang="scss">
.email-tags-container {
  display: flex;
  align-items: flex-start;
  background-color: #fff;
  border: 1px solid #ededed;
  border-radius: 5px;
  padding: 5px 10px;
  min-width: 250px;
  
  &.is-invalid {
    border-color: #dc3545;
  }
}

.email-tags-wrapper {
  flex: 1;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 5px;
}

.email-tag {
  display: inline-flex;
  align-items: center;
  padding: 0.25rem 0.5rem;
  font-size: 0.875rem;
  font-weight: 400;
  line-height: 1;
  color: #212529;
  background-color: #e9ecef;
  border-radius: 0.25rem;
  margin: 2px;
}

.email-tag-remove {
  background: none;
  border: none;
  color: #6c757d;
  cursor: pointer;
  padding: 0;
  margin-left: 0.5rem;
  font-size: 0.75rem;
  
  &:hover {
    color: #dc3545;
  }
}

.email-input {
  flex: 1;
  min-width: 150px;
  border: none;
  outline: none;
  padding: 0.25rem;
  font-size: 0.875rem;
}

.add-email-btn {
  margin-left: 10px;
}

.text-sm {
  font-size: 0.875rem;
}
</style>
