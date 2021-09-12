<template>
  <section>
    <div v-if="showTitle" style="display: contents">
      <label class="mt-4">ラベル<required-mark v-if="labelRequired"/></label>
      <div>
        <input
          :name="name + '_label'"
          placeholder="ラベルを入力してください"
          type="text"
          maxlength="12"
          v-model="value.label"
          class="w-100 form-control"
          @keyup="changeValue"
          v-validate="{ required: labelRequired && showTitle }"
          data-vv-as="ラベル"
        />
        <error-message :message="errors.first(name + '_label')"></error-message>
      </div>
    </div>

    <label class="w-100 mt20">
      コンテンツ
      <required-mark />
    </label>

    <div class="btn-template mb20 fz14">
      <a
        data-toggle="modal"
        :data-target="'#' + name"
        class="btn-block"
        v-if="currentTemplate.code"
      >
        <span>{{ currentTemplate.name }}</span>
      </a>

      <a data-toggle="modal" :data-target="'#' + name" class="btn-block" v-else
        >テンプレートから作成</a
      >
      <input
        type="hidden"
        v-model="currentTemplate.code"
        :name="name + '_survey_code'"
        v-validate="'required'"
      />
      <span v-if="errors.first(name + '_survey_code')" class="invalid-box-label"
        >テンプレートは必須です</span
      >
    </div>

    <modal-select-survey-template
      @setTemplate="selectTemplate"
      :id="name"
    ></modal-select-survey-template>
  </section>
</template>
<script>
import ErrorMessage from '../common/ErrorMessage.vue';
export default {
  components: { ErrorMessage },
  props: {
    value: Object,
    showTitle: {
      type: Boolean,
      default: true
    },
    name: {
      type: String,
      default: 'action'
    },
    labelRequired: {
      type: Boolean,
      default: true
    }
  },
  inject: ['parentValidator'],

  data() {
    return {
      currentTemplate: this.value
    };
  },

  created() {
    this.$validator = this.parentValidator;

    if (this.value.content) {
      this.currentTemplate = this.value.content;
    }
  },

  watch: {
    currentTemplate: {
      handler(survey) {
        this.value.content = {
          name: survey.name,
          code: survey.code
        };
        this.$emit('input', this.value);
      },
      deep: true
    }
  },

  methods: {
    changeValue() {
      this.$emit('input', this.value);
    },

    selectTemplate(survey) {
      this.currentTemplate = { code: survey.code, ...survey };
      this.value.content = {
        code: survey.code,
        name: survey.name
      };
      this.$emit('input', this.value);
    }
  }
};
</script>

<style scoped>
.btn-block {
  cursor: pointer;
}
</style>
