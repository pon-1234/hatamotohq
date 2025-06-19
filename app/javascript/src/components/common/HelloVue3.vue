<template>
  <div class="hello-vue3">
    <div class="card">
      <div class="card-header bg-success text-white">
        <h4 class="mb-0">Vue 3 Component Example</h4>
      </div>
      <div class="card-body">
        <p class="mb-3">
          This component uses Vue 3's Composition API with <code>&lt;script setup&gt;</code>
        </p>
        
        <div class="mb-3">
          <label class="form-label">Counter Example:</label>
          <div class="d-flex align-items-center gap-3">
            <button @click="decrement" class="btn btn-danger btn-sm">-</button>
            <span class="fs-4 fw-bold">{{ count }}</span>
            <button @click="increment" class="btn btn-success btn-sm">+</button>
          </div>
        </div>

        <div class="mb-3">
          <label class="form-label">Two-way Binding:</label>
          <input 
            v-model="message" 
            type="text" 
            class="form-control"
            placeholder="Type something..."
          />
          <p class="mt-2 text-muted">You typed: {{ message }}</p>
        </div>

        <div class="mb-3">
          <label class="form-label">Computed Property:</label>
          <p>The count {{ isEven ? 'is' : 'is not' }} even</p>
        </div>

        <div>
          <label class="form-label">Using Composables:</label>
          <p>Current time: {{ formattedTime }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';

// Reactive state
const count = ref(0);
const message = ref('Hello Vue 3!');
const currentTime = ref(new Date());

// Methods
const increment = () => {
  count.value++;
};

const decrement = () => {
  count.value--;
};

// Computed properties
const isEven = computed(() => count.value % 2 === 0);

const formattedTime = computed(() => {
  return currentTime.value.toLocaleTimeString('ja-JP');
});

// Lifecycle hooks
let timer;

onMounted(() => {
  console.log('HelloVue3 component mounted!');
  timer = setInterval(() => {
    currentTime.value = new Date();
  }, 1000);
});

onUnmounted(() => {
  console.log('HelloVue3 component unmounted!');
  if (timer) {
    clearInterval(timer);
  }
});
</script>

<style scoped>
.hello-vue3 {
  max-width: 600px;
  margin: 2rem auto;
}

.gap-3 {
  gap: 1rem;
}

code {
  background-color: #f4f4f4;
  padding: 2px 4px;
  border-radius: 3px;
}

/* Vue 3's :deep() syntax instead of ::v-deep */
:deep(.btn) {
  min-width: 40px;
}
</style>