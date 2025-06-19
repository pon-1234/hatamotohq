<template>
  <div class="d-inline p-0 m-0">
    <button
      type="submit"
      :class="`btn btn-success ${classes}`"
      :disabled="submitted || disabled"
      @click="$emit('click')"
    >
      <span v-if="submitted">
        <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
        <span v-if="object">{{ object }}を</span><span>{{ action }}中</span>
      </span>
      <span v-else>
        <span v-if="object">{{ object }}を</span><span>{{ action }}</span>
      </span>
    </button>
  </div>
</template>

<script setup>
defineProps({
  object: {
    type: String,
    default: ''
  },
  action: {
    type: String,
    default: ''
  },
  submitted: {
    type: Boolean,
    default: false
  },
  disabled: {
    type: Boolean,
    default: false
  },
  classes: {
    type: String,
    default: ''
  }
});

defineEmits(['click']);
</script>