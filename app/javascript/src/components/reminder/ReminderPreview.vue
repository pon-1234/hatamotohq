<template>
  <div class="message-preview-el">
    <div class="card" :style="isHidden ? 'margin-bottom: -50vh;' : 'margin-bottom: 0px;'">
      <div class="card-header bg-dark d-flex justify-content-between align-items-center">
        <div role="button" class="text-white" @click="changePreview">
          <i :class="isHidden ? 'fas mr-2 fa-caret-up' : 'fas mr-2 fa-caret-down'"></i>プレビュー
        </div>
        <i id="gijvq97" class="lar la-question-circle text-white"></i>
      </div>
      <div class="card-body bg-white overflow-x-hidden p-0 cursor-not-allowed no-select preview-container">
        <div class="bg-white preview-content">
          <survey-form-content :survey="survey" :preview="true"></survey-form-content>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import Util from '@/core/util';

export default {
  props: ['survey'],

  data() {
    return {
      isHidden: false
    };
  },

  mounted() {
    if (Util.isMobile()) {
      this.isHidden = true;
    }
  },

  methods: {
    changePreview() {
      this.isHidden = !this.isHidden;
    }
  }
};
</script>
