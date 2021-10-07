<template>
  <div
    class="modal fade modal-template modal-common01"
    :id="id"
    tabindex="-1"
    role="dialog"
    aria-labelledby="myModalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">スタンプを選択</h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body mh-100 overflow-hidden">
          <div class="bg-light sticker-picker m-n3">
            <div class="w-100">
              <sticker-select-package ref="stickerSelected" @input="changePackageId"></sticker-select-package>
            </div>
            <div class="bg-white" style="height: 400px">
              <div
                class="h-100 overflow-y-scroll overflow-auto-shadow overflow-scroll-touch start"
                style="height: 100%"
              >
                <div class="sticker-list">
                  <div class="d-flex" style="margin: 0px auto; flex-wrap: wrap; width: 540px">
                    <!-- Todo -->
                    <sticker
                      v-for="(sticker, index) in stickers"
                      v-bind:sticker="sticker"
                      v-bind:animation="animation"
                      :key="index"
                      @input="selectSticker"
                    />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { mapState, mapActions } from 'vuex';

export default {
  props: ['id'],
  data() {
    return {
      animation: false
    };
  },
  computed: {
    ...mapState('global', {
      stickers: state => state.stickers
    })
  },
  methods: {
    ...mapActions('global', ['getStickers']),

    changePackageId(option) {
      this.animation = option.animation;
      this.getStickers({ packageId: option.packageId });
    },

    selectSticker(sticker) {
      // emit sticker
      const data = {
        packageId: sticker.package_id,
        stickerId: sticker.line_emoji_id
      };
      this.$emit('input', data);
    },

    reset() {
      this.$refs.stickerSelected.defaultActive();
      this.getStickers({ packageId: null });
    }
  }
};
</script>

<style  lang="scss"  scoped>
  ::v-deep {
    .sticker-picker {
      margin: -15px !important;
    }

    .modal-body {
      padding: 15px !important;
    }

    #user_loading {
      margin-top: calc(50% - 150px) !important;
    }

    .modal-dialog.modal-rg {
      width: 600px !important;
    }

    .stickers-default {
      width: 100%;
    }

    @media (min-width: 576px) {
      .modal-dialog {
        max-width: 600px !important;
      }
    }

    .overflow-auto-shadow.overflow-y-scroll > div {
      position: absolute;
      width: 100%;
      top: 0;
      left: 0;
    }

    .overflow-auto-shadow {
      position: relative;
    }

    .overflow-auto-shadow.overflow-y-scroll {
      overflow-x: hidden;
    }

    .sticker-list {
      display: flex;
      flex-wrap: wrap;
    }
  }
</style>
