<template>
  <div>
    <div class="radio-group">
      <label v-if="isSupportPostback">
        <input type="radio" :name="name+'_message_action_type'" value="default" :checked="type==='default'" @change="changeType('default')"> カスタムアクション
      </label>
      <label v-if="isSupportPostback">
        <input type="radio" :name="name+'_message_action_type'" value="basic" :checked="type==='basic'" @change="changeType('basic')"> 基本アクション
      </label>
    </div>

    <div>
      <message-action-type-default v-if="type==='default' && isSupportPostback"
        :name="name"
        :value="data"
        :labelRequired="labelRequired"
        :showTitle="showTitle"
        @input="updateAction"
      />

      <message-action-type-basic v-if="type==='basic' "
        :value="data"
        :name="name"
        :supports="supports"
        :isNone="isNone"
        :showTitle="showTitle"
        :labelRequired="labelRequired"
        @input="updateAction"
      />
    </div>
  </div>
</template>

<script>

export default {
  props: {
    index: {
      type: Number,
      default: 0
    },
    name: String,
    supports: Array,
    labelRequired: {
      type: Boolean,
      default: true
    },
    isNone: {
      type: Boolean,
      default: false
    },
    showTitle: {
      type: Boolean,
      default: true
    },
    value: Object
  },
  inject: ['parentValidator'],

  data() {
    return {
      type: 'default',
      isSupportPostback: true,
      data: this.ActionMessage.default,
      tempData: {
        default: null,
        basic: null
      }
    };
  },

  watch: {
    value: {
      deep: true,
      handler(val) {
        if (val) {
          this.setupData();
        }
      }
    }
  },

  created() {
    this.$validator = this.parentValidator;
    this.tempData.default = this.ActionMessage.default;

    this.tempData.basic = this.isNone ? { type: 'none' } : {
      id: 1,
      type: this.ActionObjectsType.Uri,
      label: '',
      uri: '',
      linkUri: ''
    };
    if (!this.value) {
      return;
    }

    this.setupData();

    if (this.supports && !this.supports.includes('postback')) {
      this.type = 'basic';
      this.isSupportPostback = false;
    }
  },

  methods: {
    updateAction(action) {
      this.$emit('input', action);
    },

    changeType(type) {
      // if (type === 'default') {
      //   this.data = this.ActionMessage.default;
      // } else {
      //   this.data = this.isNone ? { type: 'none' } : {
      //     id: 1,
      //     type: this.ActionObjectsType.Uri,
      //     label: '',
      //     uri: '',
      //     linkUri: ''
      //   };
      // }
      this.data = this.tempData[type];
      this.type = type;

      this.$emit('input', this.data);
    },

    setupData() {
    // eslint-disable-next-line no-undef
      this.data = _.cloneDeep(this.value);
      if (this.data.type === 'postback') {
        this.type = 'default';
      } else {
        this.type = 'basic';
      }
      // eslint-disable-next-line no-undef
      this.tempData[this.type] = _.cloneDeep(this.value);
    }
  }
};
</script>
