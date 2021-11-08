<template>
  <div class="mt-2">
    <span class="title-editor ml-3">絵文字</span>
    <textarea
      ref="textarea"
      class="form-control"
      rows="5"
      placeholder="本文を入力してください"
      maxlength="5001"
      v-model="input_value"
    ></textarea>
    <input
      type="hidden"
      v-model="input_value"
      data-vv-as="本文"
      v-validate="'required|max:5000'"
      :name="'message-editor' + index"
    />
    <error-message :message="errors.first('message-editor' + index)"></error-message>
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
  ::v-deep {
    .emojionearea-button {
      left: -4px !important;
      top: -26px !important;
    }

    .emojionearea-picker-position-bottom {
      left: -20px !important;
      top: 10px !important;
    }

    .emojionearea-wrapper::after {
      left: 20px !important;
    }
  }

  .title-editor {
    display: flex;
    font-size: 12px;
    padding-bottom: 3px !important;
  }
</style>
