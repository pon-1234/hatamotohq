<template>
  <div>
    <action-object-selector
      :title="'Action Type'"
      :data="action"
      :supports="supports"
      @input="changeAction"
      :isNone="isNone"
      class="form-group"
    />

    <action-object-value
      :data="action"
      :name="'message_action_' + name"
      :requiredLabel="requiredLabel"
      :showTitle="showTitle"
      @input="changeAction"
    />
  </div>
</template>

<script>
export default {
  props: ['value', 'name', 'supports', 'requiredLabel', 'isNone', 'showTitle'],
  data() {
    return {
      type: 'basic',
      action: { type: 'none' }
    };
  },

  created() {
    // eslint-disable-next-line no-undef
    this.action = _.cloneDeep(this.value);
  },

  methods: {
    changeType(type) {
      this.type = type;
    },

    changeAction(value) {
      this.action = value;
      this.$emit('input', value);
    }
  }
};
</script>
