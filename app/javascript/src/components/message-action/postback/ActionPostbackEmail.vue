<template>
  <div>
    <div>
      <label> 宛先 </label>
      <input
        type="text"
        :value="form.emails"
        :name="name + '_postback_email'"
        v-validate="'required'"
        class="d-none"
        data-vv-as="宛先"
      />
      <b-form-tags
        :aria-invalid="errors.first(name + '_postback_email') ? true : false"
        class="form-control d-flex"
        input-id="tags-basic"
        v-model.trim="form.emails"
        :tag-validator="tagValidator"
        :add-button-text="'追加'"
        :invalid-tag-text="null"
        :duplicate-tag-text="'宛先が重複しています。'"
        :limit-tags-text="'宛先の最大数に達しました'"
        placeholder="メールアドレスを入力してください。"
        separator=" ,;"
      >
      </b-form-tags>
      <error-message :message="errors.first(name + '_postback_email')"></error-message>
    </div>

    <div class="mt-4">
      <label>本文</label>
      <textarea
        class="form-control"
        :name="name + '_postback_text_email'"
        rows="4"
        v-model.trim="form.text"
        placeholder="入力してください"
        v-validate="'required'"
        data-vv-as="本文"
      ></textarea>
      <div class="text-sm">
        <p class="m-0">{name}：お客様の名前</p>
      </div>
      <error-message :message="errors.first(name + '_postback_text_email')"></error-message>
    </div>
  </div>
</template>
<script>
export default {
  props: {
    value: {
      type: Object,
      default: () => {
        return {
          emails: [],
          text: null
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
      form: null
    };
  },
  created() {
    this.$validator = this.parentValidator;

    this.form = {
      emails: this.value.emails || [],
      text: this.value.text
    };
  },
  watch: {
    form: {
      handler(val) {
        this.$emit('input', val);
      },
      deep: true
    }
  },

  methods: {
    tagValidator(tag) {
      // eslint-disable-next-line
      return /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(
        tag
      );
    }
  }
};
</script>

<style scoped  lang="scss">
  ::v-deep {
    #tags-basic {
      background-color: rgba(255, 255, 255, 0) !important;
      border-radius: 5px;
      border: 1px solid #ededed;
      padding: 5px 10px !important;
    }
    div[aria-invalid="true"] {
      box-shadow: initial !important;
      border-color: red !important;
    }
  }
</style>
