<template>
  <section>
    <label class="w-100 mt20">
      内容
      <required-mark/>
    </label>
    <textarea :name="name+'_postback_text'"
      placeholder="テキストを入力してください"
      type="text" rows="4"
      v-model="content.text" class="w-100 form-control"
      @keyup="changeValue($event)" v-validate="'required'"/>

    <span  v-if="errors.first(name+'_postback_text')"  class="is-validate-label">内容は必須です</span>
  </section>
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

<style scoped>

</style>
