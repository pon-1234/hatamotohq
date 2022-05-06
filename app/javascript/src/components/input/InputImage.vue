<template>
  <div class="d-flex">
    <div v-bind:style="{ backgroundImage: `url(${imageUrl}` }" v-if="imageUrl" class="banner mr-2"></div>
    <div v-if="!imageUrl">
      <div class="btn btn-outline-primary mt-auto" data-toggle="modal" :data-target="`#imagemapModalUploadImage`">
        {{ buttonTitle || "画像をアップロード" }}
      </div>
    </div>
    <div class="d-flex mt-auto flex-column" v-else>
      <div class="btn btn-outline-danger" @click="setImageUrl(null)">削除</div>
      <div class="btn btn-outline-primary mt-1" data-toggle="modal" :data-target="`#imagemapModalUploadImage`">
        変更
      </div>
    </div>
    <modal-select-media @select="onSelectMedia" :types="['image']" :filterable="false" :id="`imagemapModalUploadImage`">
    </modal-select-media>
  </div>
</template>
<script>
export default {
  props: {
    buttonTitle: {
      type: String,
      required: false
    },
    imageUrl: {
      type: String,
      required: false
    }
  },

  methods: {
    onSelectMedia(data) {
      if (data) {
        this.setImageUrl(data.url);
      }
    },

    setImageUrl(url) {
      this.imageUrl = url;
      this.$emit('update:imageUrl', this.imageUrl);
    }
  }
};
</script>

<style scoped>
  .banner {
    width: 300px;
    height: 150px;
    background-size: cover;
  }
</style>
