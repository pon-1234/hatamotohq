<template>
  <div class="filter-list">
    <div class="checkbox-inline" v-for="mt in MediaType" :key="mt.type">
      <label class="form-check-label mr-4">
        <input type="checkbox" :value="mt.type" v-model="checked" class="form-check-input"> {{mt.text}}
      </label>
    </div>
    <button class="btn btn-default" type="submit" @click="filter">表示変更</button>
  </div>
</template>
<script>

export default {
  data() {
    return {
      MediaType: [
        { type: 'image', text: '画像' },
        { type: 'audio', text: '音声' },
        { type: 'richmenu', text: 'メニュー画像' },
        { type: 'video', text: '動画' }
      ],
      checked: []
    };
  },
  methods: {
    filter() {
      this.$emit('input', this.arrayFilter());
    },
    arrayFilter() {
      let temp = [];
      if (this.checked.includes('image')) {
        temp = temp.concat(this.ImageType);
      }

      if (this.checked.includes('video')) {
        temp = temp.concat(this.VideoType);
      }

      if (this.checked.includes('audio')) {
        temp = temp.concat(this.AudioType);
      }

      if (this.checked.includes('richmenu')) {
        temp = temp.concat('richmenu');
      }
      return temp;
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
