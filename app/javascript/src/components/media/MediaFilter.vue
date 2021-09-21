<template>
  <div class="filter-list">
    <div class="checkbox-inline" v-for="option in options" :key="option.type">
      <label class="form-check-label mr-4">
        <input type="checkbox" :value="option.type" v-model="selectedTypes" class="form-check-input"> {{option.text}}
      </label>
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
        { type: 'menu', text: 'メニュー画像' },
        { type: 'video', text: '動画' }
      ],
      selectedTypes: []
    };
  },
  methods: {
    ...mapMutations('media', [
      'setFilter'
    ]),

    applyFilter() {
      this.setFilter(this.selectedTypes.map(_ => _.type));
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
