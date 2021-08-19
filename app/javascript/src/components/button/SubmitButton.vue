<template>
  <div class="d-inline p-0 m-0">
    <button :class="`btn btn-success ${classes}`" :disabled="submitted || disabled" type="submit" @click="$emit('click')">
      <span v-if="submitted">
        <b-spinner small></b-spinner>
        <span v-if="object">{{object}}を</span><span>{{action}}中</span>
      </span>
      <span v-else>
        <span v-if="object">{{object}}を</span><span>{{action}}</span>
      </span>
    </button>
  </div>
</template>

<script>
export default {
  props: ['object', 'action', 'submitted', 'disabled', 'classes']
};
</script>