<template>
  <div>
    <staff-selection @select="changeValue" :selected="actionData.staff_id"></staff-selection>
    <input
      :name="name + '_postback_staff_id'"
      v-model="content.staff_id"
      class="d-none"
      v-validate="'required'"
      data-vv-as="担当者"
    />
    <error-message :message="errors.first(name + '_postback_staff_id')"></error-message>
  </div>
</template>
<script>

export default {
  props: {
    actionData: {
      type: Object,
      default: () => {
        return {
          text: ''
        };
      }
    },
    name: {
      type: String,
      default: 'postback_action'
    }
  },
  inject: ['parentValidator'],
  data() {
    return {
      content: { staff_id: null, ...(_.cloneDeep(this.actionData)) }
    };
  },

  watch: {
    actionData: {
      handler(val) {
        this.content = _.cloneDeep(this.actionData);
      },
      deep: true
    }
  },

  created() {
    this.$validator = this.parentValidator;
  },

  methods: {
    changeValue(staffId) {
      this.content.staff_id = staffId;
      this.$emit('input', { staff_id: staffId });
    }
  }
};
</script>

<style lang="scss" scoped>
::v-deep {
  li.multiselect__element {
    display: block;
  }
}
</style>