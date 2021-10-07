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
          name="datetime-label"
          placeholder="ラベルを入力してください"
          maxlength="12"
          v-model="data.label"
          class="w-100 form-control"
          @keyup="changeValue"
          v-validate="{ required: labelRequired && showTitle }"
          data-vv-as="ラベル"
        />
        <error-message
          :message="errors.first('datetime-label')"
        ></error-message>
      </div>
    </div>
    <label class="w-100 mt20"> モード </label>
    <div class="w-100">
      <select
        v-model="data.mode"
        class="form-control w-100 form-control"
        @change="changeValue"
      >
        <option v-for="(item, index) in modes" :key="index" :value="item.value">
          {{ item.text }}
        </option>
      </select>
    </div>
  </div>
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
    labelRequired: {
      type: Boolean,
      default: true
    }
  },
  inject: ['parentValidator'],
  data() {
    return {
      modes: [
        { text: '日付', value: 'date' },
        { text: '時間', value: 'time' },
        { text: '日付時刻', value: 'datetime' }
      ],
      data: this.value
    };
  },
  created() {
    this.$validator = this.parentValidator;
    this.value.data = 'eyJ0eXBlIjoiZGF0ZXRpbWUifQ==';
  },
  watch: {
    value: {
      handler(val) {
        this.data = val;
      },
      deep: true
    }
  },
  methods: {
    changeValue() {
      this.$emit('input', this.data);
    }
  }
};
</script>

<style lang="scss" scoped></style>
