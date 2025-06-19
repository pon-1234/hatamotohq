<template>
  <div class="input-wrapper" ref="wrapperRef">
    <input
      v-model.trim="currentValue"
      :class="classes"
      :type="type"
      :placeholder="placeholder"
      @focus="handleFocus"
      @blur="handleBlur"
      @keyup="showSuggest"
      @change="change"
      :name="name"
    />
    <transition name="fade">
      <div
        class="recent-contents"
        v-if="show || onFocus"
      >
        <div class="recent-contents-list">
          <span
            class="content suggest-contents"
            v-for="(v, i) in suggestList"
            @mousedown.prevent="inputFromSuggest(v)"
            :key="i"
          >
            {{ v }}
          </span>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted, onUnmounted } from 'vue';

// Props
const props = defineProps({
  modelValue: {
    type: String,
    default: ''
  },
  name: {
    type: String,
    default: 'default_name'
  },
  list: {
    type: Array,
    required: true
  },
  placeholder: {
    type: String,
    default: 'pxまたはキーワード'
  },
  classes: {
    type: String,
    default: ''
  },
  type: {
    type: String,
    default: 'text'
  }
});

// Emits
const emit = defineEmits(['update:modelValue', 'change']);

// Refs
const wrapperRef = ref(null);

// State
const show = ref(false);
const onFocus = ref(false);
const currentValue = ref(props.modelValue);
const suggestList = ref([]);

// Methods
const hideSuggest = () => {
  if (!onFocus.value) {
    show.value = false;
  }
};

const inputFromSuggest = (v) => {
  currentValue.value = v;
  hideSuggest();
  change();
};

const showSuggest = () => {
  const temp = currentValue.value.trim();
  if (temp === '') {
    suggestList.value = props.list;
  } else {
    suggestList.value = props.list.filter((item) => {
      return item.toLowerCase().indexOf(temp.toLowerCase()) !== -1;
    });
  }
  show.value = suggestList.value.length > 0;
};

const change = () => {
  emit('update:modelValue', currentValue.value);
  emit('change', currentValue.value);
};

const handleFocus = () => {
  onFocus.value = true;
  showSuggest();
};

const handleBlur = () => {
  onFocus.value = false;
  // Delay hiding to allow click on suggestion
  setTimeout(() => {
    hideSuggest();
  }, 200);
};

// Handle click outside
const handleClickOutside = (event) => {
  if (wrapperRef.value && !wrapperRef.value.contains(event.target)) {
    hideSuggest();
  }
};

// Watch for external value changes
watch(() => props.modelValue, (newValue) => {
  currentValue.value = newValue;
});

// Lifecycle
onMounted(() => {
  document.addEventListener('click', handleClickOutside);
});

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside);
});
</script>

<style lang="scss" scoped>
.input-wrapper {
  position: relative;
  display: inline-block;
  width: 100%;

  .recent-contents {
    padding: 8px 10px;
    font-size: 14px;
    letter-spacing: 0;
    max-height: 200px;
    overflow-y: auto;
    background-color: #ffffff;
    position: absolute;
    border: 1px solid #ccd0d2;
    border-radius: 5px;
    z-index: 1;
    width: 100%;
    left: 0;
    top: 40px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);

    .recent-contents-list {
      .suggest-contents {
        cursor: pointer;
        padding: 4px 0;
        display: block;
        
        &:hover {
          background-color: #f5f5f5;
          margin: 0 -10px;
          padding: 4px 10px;
        }
      }
    }
  }

  .content {
    display: flex;
    &:not(:last-child) {
      margin-bottom: 8px;
    }
  }

  .fade-enter-active,
  .fade-leave-active {
    transition: opacity 0.3s;
  }
  
  .fade-enter-from,
  .fade-leave-to {
  .fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
    opacity: 0;
  }
}
</style>
