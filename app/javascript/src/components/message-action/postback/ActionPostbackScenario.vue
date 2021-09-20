<template>
  <section>
    <label class="w-100 mt20">
      シナリオ配信
    </label>

    <div class="btn-template mb20 fz14">
      <div data-toggle="modal" :data-target="'#'+ name" class="btn btn-secondary btn-block">{{currentTemplate.title}}</div>
      <input type="hidden" v-model="currentTemplate.scenario_id" :name="name+'_scenario_id'"  v-validate="'required'" data-vv-as="シナリオ配信" />
      <error-message :message="errors.first(name+'_scenario_id')"></error-message>
    </div>

    <modal-select-scenario @selectScenario="onSelectScenario" :id="name" type="normal"></modal-select-scenario>
  </section>

</template>
<script>
export default {
  props: {
    value: {
      type: Object,
      default: () => {
        return {
          scenario_id: null,
          title: 'シナリオ配信一覧から選択'
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
      scenarios: [],
      currentTemplate: {
        scenario_id: null,
        title: null
      },
      current_page_scenario: 0,
      total_scenario: 0,
      per_page_scenario: 10,
      isScenarioLoading: false
    };
  },

  created() {
    this.$validator = this.parentValidator;

    this.currentTemplate = {
      scenario_id: this.value.scenario_id,
      title: this.value.scenario_id == null ? 'シナリオ配信一覧から選択' : this.value.title
    };
  },

  watch: {
    currentTemplate: {
      handler(val) {
        if (this.value.scenario_id) {
          this.$emit('input', {
            title: val.title,
            scenario_id: this.value.scenario_id
          });
        }
      },
      deep: true
    }
  },

  methods: {
    onSelectScenario(scenario) {
      this.currentTemplate = { scenario_id: scenario.id, ...scenario };
      this.$emit('input', {
        title: scenario.title,
        scenario_id: scenario.id
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
