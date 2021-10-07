<template>
  <div>
    <div v-if="showTitle">
      <label class="w-100 mt-2">
        ラベル
        <required-mark v-if="labelRequired" />
      </label>
      <div class="w-100">
        <input
          type="text"
          :name="name + '_label'"
          placeholder="ラベルを入力してください"
          maxlength="12"
          v-model="label"
          class="w-100 form-control"
          v-validate="{ required: labelRequired && showTitle }"
          data-vv-as="ラベル"
          @keyup="changeLabel"
        />
        <error-message :message="errors.first(name + '_label')"></error-message>
      </div>
    </div>

    <div class="form-group mt-2" v-if="showLaunchMesasge">
      <label>選択時のメッセージ</label>
      <input
        type="text"
        placeholder="選択時のメッセージを入力してください"
        v-model="displayText"
        class="w-100 form-control"
        @keyup="changeDisplayText($event)"
      />
    </div>

    <div class="card border-warning border" v-for="(action, index) in actions" :key="index">
      <div class="card-header">
        <div class="d-flex align-items-center">
          <span class="flex-1 text-nowrap">アクション{{ index + 1 }}</span>
          <div class="ml-auto" v-if="actions.length > 1">
            <div @click="moveActionUp(index)" class="btn btn-sm btn-light" v-if="index > 0">
              <i class="dripicons-chevron-up"></i>
            </div>
            <div
              type="button"
              @click="moveActionDown(index)"
              class="btn btn-sm btn-light"
              v-if="index < actions.length - 1"
            >
              <i class="dripicons-chevron-down"></i>
            </div>
            <div @click="removeAction(index)" v-if="actions.length > 1" class="btn btn-sm btn-light">
              <i class="mdi mdi-delete"></i>
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
          @input="changeAction(index, $event)"
        >
        </action-postback>
      </div>
    </div>
    <div class="text-center mt-2" v-if="actions.length < 3">
      <div class="btn btn-warning" role="button" @click="addAction()"><i class="uil-plus"></i> アクションの追加</div>
    </div>
    <divider></divider>
    <div>
      <label class="w-100 mt-2"> タグ設定 </label>
      <div class="row m-0">
        <div class="col-md-6 d-flex-auto p-0">
          <span>タグを追加</span>
          <action-postback-tag
            class="mt-2"
            :value="assignTagsData.tags"
            :name="name + '_tag'"
            @input="onAssignTagsDataChanged"
          >
          </action-postback-tag>
        </div>

        <div class="col-md-6 d-flex-auto">
          <span>タグをはずす</span>
          <action-postback-tag
            class="mt-2"
            :value="unassignTagsData.tags"
            :name="name + '_tag_delete'"
            @input="onUnassignTagsDataChanged"
          >
          </action-postback-tag>
        </div>
      </div>
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

    showLaunchMesasge: {
      default: true,
      type: Boolean
    }
  },

  data() {
    return {
      data: {},
      label: null,
      displayText: null,
      assignTagsData: { type: 'assign', tags: [] },
      unassignTagsData: { type: 'unassign', tags: [] },
      actions: [
        {
          type: 'no-action'
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
      const tagActions = data.tag;
      if (tagActions) {
        this.assignTagsData = tagActions.find((_) => _.type === 'assign') || {
          type: 'assign',
          tags: []
        };
        this.unassignTagsData = tagActions.find(
          (_) => _.type === 'unassign'
        ) || { type: 'unassign', tags: [] };
      }
    },
    onAssignTagsDataChanged(tags) {
      this.assignTagsData = {
        type: 'assign',
        tags: tags
      };

      this.updateData();
    },

    onUnassignTagsDataChanged(tags) {
      this.unassignTagsData = {
        type: 'unassign',
        tags: tags
      };

      this.updateData();
    },

    changeAction(index, action) {
      this.$set(this.actions, index, action);
      this.updateData();
    },

    addAction() {
      this.actions.push({
        type: 'no-action'
      });

      this.updateData();
    },

    removeAction(index) {
      this.actions.splice(index, 1);
      this.updateData();
    },

    moveActionUp(index) {
      if (index > 0) {
        const to = index - 1;
        this.actions.splice(to, 0, this.actions.splice(index, 1)[0]);
        this.updateData();
      }
    },

    moveActionDown(index) {
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
      this.displayText = $event.target.value;
      this.updateData();
    },

    updateData() {
      this.$emit('input', {
        type: 'postback',
        label: this.label,
        displayText: this.displayText,
        data: {
          displayText: this.displayText,
          actions: this.actions,
          tag: [this.assignTagsData, this.unassignTagsData]
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
