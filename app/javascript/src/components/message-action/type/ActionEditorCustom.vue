<template>
  <div>
    <div v-if="showTitle">
      <label class="w-100">
        ラベル
        <required-mark v-if="labelRequired" />
      </label>
      <div class="w-100">
        <input
          type="text"
          :name="name + '_label'"
          placeholder="ラベルを入力してください"
          maxlength="21"
          v-model.trim="label"
          class="w-100 form-control"
          v-validate="{ required: labelRequired && showTitle, max: 20 }"
          data-vv-as="ラベル"
          @keyup="changeLabel"
        />
        <div class="w-100 mt-1 font-12 text-muted">10文字を超える場合、文が途中で途切れる場合があります。</div>
        <error-message class="w-100" :message="errors.first(name + '_label')"></error-message>
      </div>
    </div>

    <div class="form-group mt-2" v-if="showLaunchMessage">
      <label>選択時のメッセージ</label>
      <input
        type="text"
        placeholder="選択時のメッセージを入力してください"
        v-model.trim="displayText"
        class="w-100 form-control"
        :name="name + '_display_text'"
        maxlength="301"
        v-validate="'max:300'"
        data-vv-as="選択時のメッセージ"
        @keyup="changeDisplayText($event)"
      />
      <error-message class="w-100" :message="errors.first(name + '_display_text')"></error-message>
    </div>

    <div>
      <label>選択後の挙動</label>
      <div class="card border-warning border" v-for="(action, index) in actions" :key="index">
        <div class="card-header">
          <div class="d-flex align-items-center">
            <span class="flex-1 text-nowrap">アクション{{ index + 1 }}</span>
            <div class="ml-auto" v-if="actions.length > 1">
              <div @click="moveUp(index)" class="btn btn-sm btn-light" v-if="index > 0">
                <i class="dripicons-chevron-up"></i>
              </div>
              <div
                type="button"
                @click="moveDown(index)"
                class="btn btn-sm btn-light"
                v-if="index < actions.length - 1"
              >
                <i class="dripicons-chevron-down"></i>
              </div>
              <div @click="remove(index)" v-if="actions.length > 1" class="btn btn-sm btn-light">
                <i class="dripicons-minus"></i>
              </div>
            </div>
          </div>
        </div>
        <div class="card-body">
          <action-postback
            :showTitle="false"
            :value="action"
            :name="name + '_postback_' + index"
            :labelRequired="false"
            @input="changeActionType(index, $event)"
          >
          </action-postback>
        </div>
      </div>
    </div>

    <div class="text-center mt-2" v-if="actions.length < limit">
      <div class="btn btn-warning" role="button" @click="addAction()"><i class="uil-plus"></i> アクションの追加</div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    value: Object,
    labelRequired: Boolean,
    showTitle: Boolean,
    name: String,
    limit: {
      type: Number,
      default: 3
    },

    showLaunchMessage: {
      default: true,
      type: Boolean
    }
  },

  data() {
    return {
      data: {},
      label: null,
      displayText: null,
      actions: [
        {
          type: 'none'
        }
      ]
    };
  },
  inject: ['parentValidator'],

  created() {
    this.$validator = this.parentValidator;
    this.setup();
  },

  methods: {
    setup() {
      if (!this.value) return;
      const data = this.value.data;
      this.label = this.value.label || null;
      this.actions = data.actions;
      this.displayText = this.value.displayText || null;
    },

    changeActionType(index, action) {
      this.$set(this.actions, index, action);
      this.updateData();
    },

    addAction() {
      this.actions.push({
        type: 'none'
      });

      this.updateData();
    },

    remove(index) {
      this.actions.splice(index, 1);
      this.updateData();
    },

    moveUp(index) {
      if (index > 0) {
        const to = index - 1;
        this.actions.splice(to, 0, this.actions.splice(index, 1)[0]);
        this.updateData();
      }
    },

    moveDown(index) {
      if (index < this.actions.length) {
        const to = index + 1;
        this.actions.splice(to, 0, this.actions.splice(index, 1)[0]);
        this.updateData();
      }
    },

    changeLabel() {
      this.updateData();
    },

    changeDisplayText($event) {
      this.displayText = $event.target.value.trim();
      this.updateData();
    },

    updateData() {
      this.$emit('input', {
        type: 'postback',
        label: this.label,
        displayText: this.displayText,
        data: {
          displayText: this.displayText,
          actions: this.actions
        }
      });
    }
  }
};
</script>

<style type="text/scss" scoped>
  .d-flex-auto {
    flex-direction: column;
  }

  .tag-content {
    border: 1px solid #cecece;
    padding: 10px 20px;
    border-radius: 5px;
  }

  .tag {
    vertical-align: middle;
    flex: 1;
    width: calc(100% - 117px);
    display: inline-block;
  }

  @media (max-width: 1290px) {
    .d-flex-auto {
      flex-direction: row;
      margin-top: 10px;
    }

    .d-flex-auto > label {
      width: 100% !important;
    }
    .tag {
      width: 100%;
    }
  }

  .mt-4 {
    margin-top: 10px;
  }

  .btn-default {
    font-size: 10px;
  }

  .btn-add {
    width: 200px;
    border: 1px solid #ededed;
    background: white;
    color: #1b1b1b;
  }

  .btn-add:hover {
    background: white;
    color: #1b1b1b;
  }
</style>
