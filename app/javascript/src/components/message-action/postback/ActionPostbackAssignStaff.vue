<template>
  <div>
    <staff-selection @select="changeValue" :selected="actionData.staff_id"></staff-selection>
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
      // eslint-disable-next-line no-undef
      content: _.cloneDeep(this.actionData)
    };
  },

  watch: {
    actionData: {
      handler(val) {
        // eslint-disable-next-line no-undef
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
      // console.log($event);
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