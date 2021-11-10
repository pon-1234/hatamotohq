<template>
  <div>
    <div class="btn btn-secondary mw-200" data-toggle="modal" :data-target="`#${name}-modal-select-profile-variable`">
      {{ this.variable_name || "友だち情報を選択" }}
    </div>
    <modal-select-profile-variable
      :type="type"
      :id="`${name}-modal-select-profile-variable`"
      @selectVariable="selectVariable($event)"
    >
    </modal-select-profile-variable>
  </div>
</template>
<script>
export default {
  props: {
    name: {
      default: 'text',
      type: String
    },
    field: {
      default: null,
      type: String
    },
    type: {
      default: null,
      type: String
    }
  },
  data() {
    return {
      variable_name: this.field
    };
  },
  methods: {
    selectVariable(variable) {
      this.variable_name = variable.name;
      this.$emit('input', {
        id: variable.id,
        name: variable.name
      });
    }
  }
};
</script>
