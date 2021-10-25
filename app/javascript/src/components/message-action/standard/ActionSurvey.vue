<template>
  <section>
    <div v-if="showTitle" style="display: contents">
      <label class="mt-2">ラベル<required-mark v-if="labelRequired" /></label>
      <div>
        <input
          :name="name + '_label'"
          placeholder="ラベルを入力してください"
          type="text"
          maxlength="12"
          v-model="actionData.label"
          class="w-100 form-control"
          @keyup="changeValue"
          v-validate="{ required: labelRequired && showTitle, max: 12 }"
          data-vv-as="ラベル"
        />
        <error-message :message="errors.first(name + '_label')"></error-message>
      </div>
    </div>

    <label class="w-100 mt-2">
      回答フォーム
      <required-mark></required-mark>
    </label>

    <div>
      <div data-toggle="modal" :data-target="'#' + name" class="btn btn-secondary" v-if="actionData.content.id">
        <span>{{ actionData.content.name }}</span>
      </div>

      <div data-toggle="modal" :data-target="'#' + name" class="btn btn-secondary" v-else>回答フォームを選択する</div>
      <input
        type="hidden"
        v-model="actionData.content.id"
        :name="name + '_survey_code'"
        v-validate="'required'"
        data-vv-as="回答フォーム"
      />
      <error-message :message="errors.first(name + '_survey_code')"></error-message>
    </div>
    <modal-select-survey @selectSurvey="selectSurvey($event)" :id="name"></modal-select-survey>
  </section>
</template>
<script>
export default {
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
      actionData: {
        type: 'survey',
        label: null,
        content: {
          id: null,
          name: null
        }
      }
    };
  },

  created() {
    this.$validator = this.parentValidator;
    this.actionData = _.cloneDeep(this.value);
  },

  methods: {
    changeValue() {
      this.$emit('input', this.actionData);
    },

    selectSurvey(survey) {
      if (!survey) return;
      this.actionData.content = _.pick(survey, ['id', 'name']);
      this.$emit('input', this.actionData);
    }
  }
};
</script>