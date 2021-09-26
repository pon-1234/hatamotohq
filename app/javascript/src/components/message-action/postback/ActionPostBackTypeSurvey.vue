<template>
  <section>
    <label class="w-100">
      コンテンツ
      <required-mark/>
    </label>

    <div class="btn-template mb20 fz14">
      <a data-toggle="modal" :data-target="'#'+ name" class="btn-block" v-if="currentTemplate.code">
        <span >{{currentTemplate.name}}</span>
      </a>

      <a data-toggle="modal" :data-target="'#'+ name" class="btn-block" v-else>テンプレートから作成</a>
      <input type="hidden" v-model="currentTemplate.code" :name="name+'_survey_code'" v-validate="'required'"/>
      <span v-if="errors.first(name+'_survey_code')" class="invalid-box-label">テンプレートは必須です</span>
    </div>

    <modal-select-survey-template @selectTemplate="selectTemplate" :id="name"></modal-select-survey-template>
  </section>
</template>
<script>
export default {
  props: {
    value: {
      type: Object,
      default: () => {
        return {
          code: null,
          name: 'テンプレートから作成'
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
      currentTemplate: this.value || {
        code: null,
        name: null
      }
    };
  },

  created() {
    this.$validator = this.parentValidator;

    if (this.value.code) {
      this.currentTemplate = {
        code: this.value.code,
        name: this.value.name
      };
    }
  },

  watch: {
    currentTemplate: {
      handler(survey) {
        if (this.value.template_id) {
          this.$emit('input', {
            name: survey.name,
            code: survey.code
          });
        }
      },
      deep: true
    }
  },

  methods: {
    selectTemplate(survey) {
      this.currentTemplate = { code: survey.code, ...survey };
      this.$emit('input', {
        name: survey.name,
        code: survey.code
      });
    }
  }
};
</script>

<style scoped>
  .btn-block {
    cursor: pointer;
  }
</style>
