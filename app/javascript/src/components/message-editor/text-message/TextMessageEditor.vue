<template>
  <div class="pos">
    <span class="title-editor">絵文字</span>
    <ValidationProvider name="テキスト" rules="required|max:10" v-slot="{ errors }">
      <textarea
        ref='textarea'
        class='form-control'
        rows='5'
        placeholder='テキストを入力してください'
        v-model='input_value'
      ></textarea>
      <span class="error-explanation">{{ errors[0] }}</span>
    </ValidationProvider>
  </div>
</template>
<script>

export default {
  props: ['value', 'index'],
  inject: ['parentValidator'],
  created() {
    this.$validator = this.parentValidator;
  },
  mounted() {
    var _this = this;
    $(this.$refs.textarea).emojioneArea({
      template: '<editor/><filters/><tabs/>',
      autocomplete: 'off',
      autocorrect: 'off',
      autocapitalize: 'off',
      placeholder: null,
      container: null,
      hideSource: true,
      autoHideFilters: true,
      useSprite: true,
      shortnames: true,
      searchPosition: 'bottom',
      pickerPosition: 'bottom',
      events: {
        keyup(editor, event) {
          _this.$emit('input', this.getText());
        },
        emojibtn_click(editor, event) {
          _this.$emit('input', this.getText());
        }
      }
    });
  },
  computed: {
    input_value: {
      get() {
        return this.value;
      }
    }
  }
};
</script>

<style lang="scss" scoped>
::v-deep{
  .emojionearea-button {
    left: -4px!important;
    top: -26px!important;
  }

  .emojionearea-picker-position-bottom {
    left: -20px!important;
    top: 10px!important;
  }

  .emojionearea-wrapper::after {
    left: 20px!important;
  }
}

.title-editor {
  margin-left: 30px;
  font-size: 12px;
}
</style>
