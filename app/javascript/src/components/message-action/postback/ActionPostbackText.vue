<template>
  <div>
    <label>本文<required-mark /></label>
    <textarea
      :name="name + '_postback_text'"
      placeholder="本文を入力してください"
      type="text"
      rows="4"
      v-model="content.text"
      class="form-control"
      @keyup="changeValue($event)"
      maxlength="1001"
      v-validate="'required|max:1000'"
      data-vv-as="本文"
    />
    <error-message :message="errors.first(name + '_postback_text')"></error-message>
  </div>
</template>
<script>
export default {
  props: {
    value: {
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
      content: _.cloneDeep(this.value)
    };
  },

  watch: {
    value: {
      handler(val) {
        // eslint-disable-next-line no-undef
        this.content = _.cloneDeep(this.value);
      },
      deep: true
    }
  },

  created() {
    this.$validator = this.parentValidator;
  },

  methods: {
    changeValue($event) {
      this.$emit('input', { text: $event.target.value });
    }
  }
};
</script>
