<template>
  <div>
    <div class="border" v-if="packageId && stickerId">
      <div class="figure figure-grid figure-grid-sm mr-3 mb-3 position-relative">
        <img
          :src="`https://stickershop.line-scdn.net/stickershop/v1/sticker/${stickerId}/PC/sticker.png`"
          alt="tabImage"
        />
        <button type="button" class="position-absolute close" style="top: 10px; right: 0px" @click="removeSticker">
          <i class="mdi mdi-close-outline"></i>
          <!-- <i class="fas fa-times"></i> -->
        </button>
      </div>
    </div>
    <div v-else>
      <div class="border text-center" :class="errors.first('sticker-id' + index) ? 'invalid-box' : ''">
        <div class="figure figure-grid-sm my-4">
          <a
            class="text-primary"
            href="#"
            data-toggle="modal"
            :data-target="`#stickerModalCenter${index}`"
            @click="showStickerModal()"
            >スタンプを選択
          </a>
          <div class="text-muted opacity-30">
            <i class="mdi mdi-sticker-emoji mdi-3x"></i>
          </div>
        </div>
      </div>
      <error-message :message="errors.first('sticker-id' + index)"></error-message>
    </div>
    <!-- Modal -->
    <modal-select-sticker :ref="`modalSticker${index}`" :id="`stickerModalCenter${index}`" @input="selectSticker" />
    <input
      type="hidden"
      v-model="stickerId"
      :name="'sticker-id' + index"
      v-validate="'required'"
      data-vv-as="スタンプ"
    />
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
    },
    showStickerModal() {
      this.$refs[`modalSticker${this.index}`].reset();
    }
  }
};
</script>
