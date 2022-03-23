<template>
  <section>
    <div>
      <div class="d-flex align-items-center">
        <div
          class="btn btn-secondary mw-300 mr-2 mb-auto"
          data-toggle="modal"
          :data-target="`#${name}-modal-select-variable`"
        >
          {{ content.variable.name || "友だち情報を選択" }}
        </div>
        <div>
          <input
            type="number"
            :name="name + '_postback_score'"
            placeholder="スコアを入力してください"
            v-model="content.value"
            class="form-control mw-200"
            v-validate="'required'"
            data-vv-as="スコア"
          />
          <error-message :message="errors.first(name + '_postback_score')"></error-message>
        </div>

        <span class="px-2 mb-auto mt-1">を</span>
        <select class="fw-120 form-control mb-auto" v-model="content.operation">
          <option value="set">← (代入)</option>
          <option value="add">＋ (加算)</option>
          <option value="minus">－ (減算)</option>
          <option value="unset">X (消去)</option>
        </select>
        <span class="text-nowrap pl-2 mr-auto mb-auto mt-1">する</span>
      </div>
    </div>
    <modal-select-variable type="text" :id="`${name}-modal-select-variable`" @selectVariable="selectVariable($event)">
    </modal-select-variable>
  </section>
</template>

<script>
const SCORING_DEFAULT_ACTION_DATA = {
  operation: 'set', // 'set', 'add', 'minus', 'unset',
  value: 0,
  variable: {
    id: null,
    name: null
  }
};
export default {
  props: {
    actionData: {
      type: Array,
      default: () => {
        return SCORING_DEFAULT_ACTION_DATA;
      }
    },
    name: {
      type: String,
      default: 'postback_action'
    }
  },

  data() {
    return {
      content: SCORING_DEFAULT_ACTION_DATA
    };
  },

  inject: ['parentValidator'],

  created() {
    this.$validator = this.parentValidator;
    this.content = this.actionData;
  },

  watch: {
    content: {
      handler(val) {
        this.$emit('input', val);
      },
      deep: true
    }
  },

  methods: {
    onDataChanged() {
      this.$emit('input', this.content);
    },

    selectVariable(variable) {
      this.content.variable = {
        id: variable.id,
        name: variable.name
      };
    }
  }
};
</script>