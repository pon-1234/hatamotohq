<template>
  <section>
    <label class="w-100 mt20">
      宛先
    </label>
    <input type="text" :value="form.emails" :name="name+'_postback_email'" v-validate="'required'" style="height: 0px !important; width: 0px !important; opacity: 0; display: block">

    <b-form-tags
            :aria-invalid="errors.first(name+'_postback_email')? true: false"
            class="w-100 form-control" input-id="tags-basic"
                 v-model="form.emails"
                 :tag-validator="tagValidator"
                 :add-button-text="'追加'"
                 :invalid-tag-text="null"
                 :duplicate-tag-text="'宛先が重複しています。'"
                 :limit-tags-text="'Limit'"
                 placeholder="メールアドレスを入力してください。"
                 separator=" ,;" >
    </b-form-tags>
    <span v-if="errors.first(name+'_postback_email')"  class="invalid-box-label">宛先が必須です。</span>

    <label class="w-100 mt20">
      内容
    </label>

    <textarea class="form-control w-100"  :name="name+'_postback_text_email'"  rows="4" v-model="form.text" placeholder="入力してください" v-validate="'required'"></textarea>
    <span v-if="errors.first(name+'_postback_text_email')" class="invalid-box-label">内容は必須です</span>

    <label class="w-100 mt20">
      注意
    </label>
    <div style="font-size: 80%">
      <p class="m-0">{name}：お客様の名前</p>
    </div>
  </section>
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
      return /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(tag);
    }
  }
};
</script>

<style scoped  lang="scss">
  ::v-deep{
    #tags-basic {
      background-color: rgba(255, 255, 255, 0)!important;
      border-radius: 5px;
      border: 1px solid #ededed;
      padding: 5px 10px !important;
    }
    div[aria-invalid="true"]{
      box-shadow: initial !important;
      border-color: red !important;
    }
  }

</style>
