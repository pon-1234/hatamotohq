<template>
  <div>
    <!-- <action-postback :showTitle="showTitle" v-bind:value="data" v-if="data.type === 'postback'" @input="changeAction" :type="type" :name="name" :labelRequired="labelRequired"/> -->
    <action-object-survey :showTitle="showTitle" v-bind:value="data" v-if="data.type === 'survey'" @input="changeAction"
                         :name="name" :labelRequired="labelRequired"/>
    <action-send-message :showTitle="showTitle" v-bind:value="data" v-if="data.type === 'message'" @input="changeAction"
                         :name="name" :labelRequired="labelRequired"/>
    <action-open-url :showTitle="showTitle" v-bind:value="data" v-if="data.type === 'uri' && regexUrl"
                     @input="changeAction" :name="name" :labelRequired="labelRequired"/>
    <action-open-tel :showTitle="showTitle" v-bind:value="data" v-if="data.type === 'uri' && regexUri"
                     @input="changeAction" :name="name" :labelRequired="labelRequired"/>
    <action-datetime-picker :showTitle="showTitle" v-bind:value="data" v-if="data.type === 'datetimepicker'"
                            @input="changeAction" :name="name" :labelRequired="labelRequired"/>
    <action-default :showTitle="showTitle" v-bind:value="data"
                    v-if="data.type === 'camera' || data.type === 'cameraRoll' || data.type === 'location'"
                    @input="changeAction" :name="name" :labelRequired="labelRequired"/>
  </div>
</template>
<script>
import Util from '../../core/util';

export default {
  props: {
    showTitle: {
      type: Boolean,
      default: true
    },
    data: Object,
    name: String,
    type: String,
    labelRequired: {
      type: Boolean,
      default: true
    }
  },

  computed: {
    regexUrl() {
      return this.data.id ? this.data.id === 1 : Util.validateUrl(this.data.uri);
    },

    regexUri() {
      return this.data.id ? this.data.id === 2 : !Util.validateUrl(this.data.uri);
    }
  },
  methods: {
    changeAction(value) {
      this.$emit('input', value);
    }
  }
};
</script>
