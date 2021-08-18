<template>
  <div >
    <div class="border" v-if="packageId && stickerId">
      <div class="figure figure-grid figure-grid-sm mr-3 mb-3 position-relative">
        <img
          :src="'https://stickershop.line-scdn.net/stickershop/v1/sticker/'+ stickerId+'/PC/sticker.png'"
          alt="tabImage"
        />
        <button
          type="button"
          class="position-absolute close"
          style="top: 10px; right: 10px;"
          @click="removeSticker"
        >
          <i class="fas fa-times"></i>
        </button>
      </div>
    </div>
    <div v-else>
      <div class="border text-center" :class="errors.first('sticker-id' + index)?'is-validate':'' ">
        <div class="figure figure-grid-sm my-4">
          <a
            class="select-sticker"
            href="#"
            data-toggle="modal"
            data-target="#stickerModalCenter"
          >スタンプを選択</a>
          <div class="text-muted opacity-30">
            <i class="fas fa-smile fa-3x"></i>
          </div>
        </div>
      </div>
      <span v-if="errors.first('sticker-id' + index)" class="is-validate-label">スタンプは必須です</span>

      <!-- Modal -->
      <sticker-modal name="stickerModalCenter" @input="selectSticker" />
    </div>
    <input type="hidden" v-model="stickerId" :name="'sticker-id' + index" v-validate="'required'" />
  </div>
</template>
<script>

export default {
  props: ['packageId', 'stickerId', 'index'],
  inject: ['parentValidator'],
  created() {
    this.$validator = this.parentValidator;
  },
  methods: {
    removeSticker() {
      this.$emit('input', { packageId: null, stickerId: null });
    },
    selectSticker(sticker) {
      this.$emit('input', sticker);
    }
  }
};
</script>
<style  lang="scss"  scoped>
::v-deep {
  .select-sticker {
    color: #00b900 !important;
    text-decoration: none !important;
    background-color: transparent !important;
  }
}
</style>
