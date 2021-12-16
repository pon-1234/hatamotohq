<template>
  <div>
    <label>アクション</label>
    <div>
      <select
        type="text"
        maxlength="12"
        v-model="curPostbackType"
        class="w-100 form-control"
        @change="changeActionType"
      >
        <option v-for="(val, key) of types" :key="key" :value="key">{{ val }}</option>
      </select>
    </div>
    <div class="mt-2">
      <action-postback-text v-if="curPostbackType === 'text'" :value="content" :name="name" @input="updateContent">
      </action-postback-text>

      <action-postback-template
        v-if="curPostbackType === 'template'"
        :value="content"
        @input="updateContent"
        :name="name"
      >
      </action-postback-template>

      <action-postback-scenario
        v-if="curPostbackType === 'scenario'"
        :value="content"
        :name="name"
        @input="updateContent"
      >
      </action-postback-scenario>

      <action-post-back-type-flex-message
        v-if="curPostbackType === 'flexMessage'"
        :value="content"
        :name="name"
        @input="updateContent"
      />

      <action-postback-email v-if="curPostbackType === 'email'" :value="content" :name="name" @input="updateContent">
      </action-postback-email>

      <action-postback-tag v-if="curPostbackType === 'tag'" :value="content" :name="name" @input="updateContent">
      </action-postback-tag>

      <action-postback-reminder
        v-if="curPostbackType === 'reminder'"
        :action-data="content"
        :name="name"
        @input="updateContent"
      ></action-postback-reminder>

      <action-post-back-reservation
        v-if="curPostbackType === 'reservation'"
        :value="content"
        :name="name"
        @input="updateContent"
      >
      </action-post-back-reservation>
    </div>
  </div>
</template>
<script>
export default {
  props: {
    value: String,
    name: {
      type: String,
      default: 'action'
    },
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
      types: this.PostbackTypes,
      curPostbackType: null,
      content: null
    };
  },

  watch: {
    value: {
      handler(val) {
        this.setupData();
      },
      deep: true
    }
  },

  created() {
    this.$validator = this.parentValidator;
    this.setupData();
  },

  methods: {
    updateContent(content) {
      this.content = content;
      this.emitData();
    },

    emitData() {
      this.$emit('input', {
        type: this.curPostbackType,
        content: this.content
      });
    },

    changeActionType() {
      this.content = undefined;
      this.emitData();
    },

    setupData() {
      if (this.value) {
        const data = this.value;
        this.content = data.content;
        this.curPostbackType = data.type || 'none';
      } else {
        this.curPostbackType = 'none';
      }
    }
  }
};
</script>
