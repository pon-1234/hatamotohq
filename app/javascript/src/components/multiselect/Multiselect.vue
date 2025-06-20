<template>
  <VueformMultiselect
    v-model="localValue"
    :options="computedOptions"
    :multiple="multiple"
    :track-by="trackBy"
    :label="label"
    :searchable="searchable"
    :close-on-select="closeOnSelect"
    :show-labels="showLabels"
    :placeholder="placeholder"
    :allow-empty="allowEmpty"
    :disabled="disabled"
    :max="max"
    :taggable="taggable"
    :tag-placeholder="tagPlaceholder"
    :hide-selected="hideSelected"
    :loading="loading"
    :internal-search="internalSearch"
    :limit="limit"
    :max-height="maxHeight"
    :open-direction="openDirection"
    :show-no-results="showNoResults"
    :show-no-options="showNoOptions"
    :group-values="groupValues"
    :group-label="groupLabel"
    :group-select="groupSelect"
    :block-keys="blockKeys"
    :preserve-search="preserveSearch"
    @change="handleChange"
    @search-change="$emit('search-change', $event)"
    @tag="$emit('tag', $event)"
    @open="$emit('open')"
    @close="$emit('close')"
    @select="$emit('select', $event)"
    @remove="$emit('remove', $event)"
  >
    <template v-for="(_, slot) of $slots" v-slot:[slot]="scope">
      <slot :name="slot" v-bind="scope" />
    </template>
  </VueformMultiselect>
</template>

<script>
import VueformMultiselect from '@vueform/multiselect';
import '@vueform/multiselect/themes/default.css';
import { computed, ref, watch } from 'vue';

export default {
  name: 'Multiselect',
  compatConfig: { MODE: 3 },
  components: { VueformMultiselect },
  props: {
    // v-model support
    modelValue: {
      type: [String, Number, Array, Object],
      default: null
    },
    value: {
      type: [String, Number, Array, Object],
      default: null
    },
    // Options
    options: {
      type: Array,
      required: true
    },
    multiple: {
      type: Boolean,
      default: false
    },
    trackBy: {
      type: String,
      default: null
    },
    label: {
      type: String,
      default: null
    },
    searchable: {
      type: Boolean,
      default: true
    },
    closeOnSelect: {
      type: Boolean,
      default: true
    },
    showLabels: {
      type: Boolean,
      default: true
    },
    placeholder: {
      type: String,
      default: 'Select option'
    },
    allowEmpty: {
      type: Boolean,
      default: true
    },
    disabled: {
      type: Boolean,
      default: false
    },
    max: {
      type: [Number, Boolean],
      default: false
    },
    taggable: {
      type: Boolean,
      default: false
    },
    tagPlaceholder: {
      type: String,
      default: 'Press enter to create a tag'
    },
    hideSelected: {
      type: Boolean,
      default: false
    },
    loading: {
      type: Boolean,
      default: false
    },
    internalSearch: {
      type: Boolean,
      default: true
    },
    limit: {
      type: Number,
      default: 99999
    },
    maxHeight: {
      type: Number,
      default: 300
    },
    openDirection: {
      type: String,
      default: ''
    },
    showNoResults: {
      type: Boolean,
      default: true
    },
    showNoOptions: {
      type: Boolean,
      default: true
    },
    groupValues: {
      type: String,
      default: null
    },
    groupLabel: {
      type: String,
      default: null
    },
    groupSelect: {
      type: Boolean,
      default: false
    },
    blockKeys: {
      type: Array,
      default: () => []
    },
    preserveSearch: {
      type: Boolean,
      default: false
    }
  },
  emits: ['update:modelValue', 'input', 'change', 'search-change', 'tag', 'open', 'close', 'select', 'remove'],
  setup(props, { emit }) {
    const localValue = ref(props.modelValue || props.value);
    
    const computedOptions = computed(() => {
      // Handle object options format from vue-multiselect
      if (props.options.length > 0 && typeof props.options[0] === 'object' && !props.trackBy && !props.label) {
        // Convert to simple array if no trackBy/label specified
        return props.options.map(opt => opt.value || opt);
      }
      return props.options;
    });
    
    watch(() => props.modelValue, (newVal) => {
      localValue.value = newVal;
    });
    
    watch(() => props.value, (newVal) => {
      if (!props.modelValue) {
        localValue.value = newVal;
      }
    });
    
    const handleChange = (value) => {
      emit('update:modelValue', value);
      emit('input', value); // For v-model compatibility
      emit('change', value);
    };
    
    return {
      localValue,
      computedOptions,
      handleChange
    };
  }
};
</script>

<style>
/* Override styles to match vue-multiselect appearance */
.multiselect {
  min-height: 40px;
}

.multiselect-tags {
  min-height: 40px;
  padding: 8px 8px 0;
}

.multiselect-tag {
  background: #41b883;
  color: white;
  font-size: 14px;
  padding: 5px 26px 5px 10px;
  margin-right: 8px;
  margin-bottom: 8px;
}

.multiselect-tag-remove {
  background: transparent;
  color: white;
}

.multiselect-tag-remove:hover {
  background: rgba(0, 0, 0, 0.2);
}
</style>