<template>
  <div class="filter-list">
    <div class="checkbox-inline" v-for="option in options" :key="option.type">
      <div class="custom-control custom-checkbox mr-4">
        <input type="checkbox" :value="option.type" v-model="selectedTypes" class="custom-control-input" :id="option.type">
        <label class="custom-control-label" :for="option.type">{{ option.text }}</label>
      </div>
    </div>
    <button class="btn btn-primary" type="submit" @click="applyFilter">表示変更</button>
  </div>
</template>
<script>
import { mapMutations } from 'vuex';

export default {
  data() {
    return {
      options: [
        { type: 'image', text: '画像' },
        { type: 'audio', text: '音声' },
        { type: 'video', text: '動画' },
        { type: 'richmenu', text: 'メニュー画像' }
      ],
      selectedTypes: ['image', 'audio', 'video', 'richmenu']
    };
  },
  methods: {
    ...mapMutations('media', [
      'setFilter'
    ]),

    applyFilter() {
      this.setFilter(this.selectedTypes);
      this.$emit('filterChanged');
    }
  }
};
</script>
<style lang="scss" scoped>
.form-check-label {
  margin-bottom: 0px!important;
  font-size: 16px!important;
}

.filter-list {
  display: inline-flex;
  align-items: center;
}

.btn-default {
  margin-left: 10px;
}

@media(max-width: 600px) {
  .filter-list {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
