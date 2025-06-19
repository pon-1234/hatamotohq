<template>
  <div>
    <div v-if="showTitle">
      <label class="w-100">
        ラベル
        <RequiredMark v-if="requiredLabel" />
      </label>
      <div class="w-100">
        <input
          type="text"
          :name="name + '_label'"
          placeholder="ラベルを入力してください"
          maxlength="13"
          v-model.trim="label"
          class="w-100 form-control"
          :required="requiredLabel && showTitle"
          @keyup="changeLabel"
        />
        <div class="w-100 mt-1 font-12 text-muted">10文字を超える場合、文が途中で途切れる場合があります。</div>
        <ErrorMessage v-if="labelError" class="w-100" :message="labelError" />
      </div>
    </div>

    <div class="form-group mt-2" v-if="showLaunchMessage">
      <label>選択時のメッセージ<RequiredMark v-if="requiredLabel" /></label>
      <input
        type="text"
        placeholder="選択時のメッセージを入力してください"
        v-model.trim="displayText"
        class="w-100 form-control"
        :name="name + '_display_text'"
        maxlength="301"
        :required="requiredLabel"
        @keyup="changeDisplayText($event)"
      />
      <ErrorMessage v-if="displayTextError" class="w-100" :message="displayTextError" />
    </div>

    <div>
      <label>選択後の挙動</label>
      <div class="card border-warning border" v-for="(action, index) in actions" :key="index">
        <div class="card-header">
          <div class="d-flex align-items-center">
            <span class="flex-1 text-nowrap">アクション{{ index + 1 }}</span>
            <div class="ms-auto" v-if="actions.length > 1">
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
          <ActionPostback
            :show-title="false"
            :model-value="action"
            :name="name + '_postback_' + index"
            :required-label="false"
            @update:model-value="changeActionType(index, $event)"
          />
        </div>
      </div>
    </div>

    <div class="text-center mt-2" v-if="actions.length < limit">
      <div class="btn btn-warning" role="button" @click="addAction()"><i class="uil-plus"></i> アクションの追加</div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import RequiredMark from '../../common/RequiredMark.vue';
import ErrorMessage from '../../common/ErrorMessage.vue';
import ActionPostback from '../postback/ActionPostback.vue';

// Props
const props = defineProps({
  modelValue: {
    type: Object,
    default: () => ({})
  },
  requiredLabel: {
    type: Boolean,
    default: false
  },
  showTitle: {
    type: Boolean,
    default: true
  },
  name: {
    type: String,
    required: true
  },
  limit: {
    type: Number,
    default: 3
  },
  showLaunchMessage: {
    type: Boolean,
    default: true
  }
});

// Emits
const emit = defineEmits(['update:modelValue']);

// State
const data = ref({});
const label = ref(null);
const displayText = ref(null);
const actions = ref([{ type: 'none' }]);

// Computed
const labelError = computed(() => {
  if (props.requiredLabel && props.showTitle && !label.value) {
    return 'ラベルは必須です';
  }
  if (label.value && label.value.length > 12) {
    return 'ラベルは12文字以内で入力してください';
  }
  return null;
});

const displayTextError = computed(() => {
  if (props.requiredLabel && !displayText.value) {
    return '選択時のメッセージは必須です';
  }
  if (displayText.value && displayText.value.length > 300) {
    return '選択時のメッセージは300文字以内で入力してください';
  }
  return null;
});

// Methods
const setup = () => {
  if (!props.modelValue) return;
  const data = props.modelValue.data;
  label.value = props.modelValue.label || null;
  actions.value = data.actions || [{ type: 'none' }];
  displayText.value = props.modelValue.displayText || null;
};

const changeActionType = (index, action) => {
  actions.value[index] = action;
  updateData();
};

const addAction = () => {
  actions.value.push({
    type: 'none'
  });
  updateData();
};

const remove = (index) => {
  actions.value.splice(index, 1);
  updateData();
};

const moveUp = (index) => {
  if (index > 0) {
    const to = index - 1;
    actions.value.splice(to, 0, actions.value.splice(index, 1)[0]);
    updateData();
  }
};

const moveDown = (index) => {
  if (index < actions.value.length) {
    const to = index + 1;
    actions.value.splice(to, 0, actions.value.splice(index, 1)[0]);
    updateData();
  }
};

const changeLabel = () => {
  updateData();
};

const changeDisplayText = (event) => {
  displayText.value = event.target.value.trim();
  updateData();
};

const updateData = () => {
  emit('update:modelValue', {
    type: 'postback',
    label: label.value,
    displayText: displayText.value,
    data: {
      displayText: displayText.value,
      actions: actions.value
    }
  });
};

// Lifecycle
onMounted(() => {
  setup();
});
</script>

<style lang="scss" scoped>
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
