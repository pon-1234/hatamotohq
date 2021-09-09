<template>
  <div>
    <div tabindex="-1" role="dialog" aria-hidden="true" class="modal modal-common01" :id="id">
      <div class="modal-dialog modal-dialog-centered modal-md modal-rg" role="document">
        <div class="modal-content h-100 p-0">
          <div class="modal-header flex-shrink-0"><h5 class="mb-0">テンプレートを選択</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
              aria-hidden="true">&times;</span></button>
          </div>
          <div class="modal-body mh-100 overflow-y-auto">
            <div>
              <div class="d-flex flex-wrap prevent-user-select" style="flex-direction: row;    justify-content: center;">
                <figure data-type="RICH_MENU_TEMPLATE_201"
                        @click="selectTemplate(201, 6)"
                        :class="{
                                          'figure': true,
                                          'mx-2': true ,
                                          'my-2': true,
                                          'active': selectId == 201
                                      }"><img
                  src="data:image/png;base64,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"
                  width="120"></figure>
                <figure data-type="RICH_MENU_TEMPLATE_202"
                        @click="selectTemplate(202, 4)"
                        :class="{
                                          'figure': true,
                                          'mx-2': true ,
                                          'my-2': true,
                                          'active': selectId == 202
                                      }"><img
                  src="data:image/png;base64,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"
                  width="120"></figure>
                <figure data-type="RICH_MENU_TEMPLATE_203"
                        @click="selectTemplate(203, 3)"
                        :class="{
                                          'figure': true,
                                          'mx-2': true ,
                                          'my-2': true,
                                          'active': selectId == 203
                                      }"><img
                  src="data:image/png;base64,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"
                  width="120"></figure>
                <figure data-type="RICH_MENU_TEMPLATE_204"
                        @click="selectTemplate(204, 3)"
                        :class="{
                                          'figure': true,
                                          'mx-2': true ,
                                          'my-2': true,
                                          'active': selectId == 204
                                      }"><img
                  src="data:image/png;base64,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"
                  width="120"></figure>
                  <figure data-type="RICH_MENU_TEMPLATE_204"
                        @click="selectTemplate(208, 3)"
                        :class="{
                                          'figure': true,
                                          'mx-2': true ,
                                          'my-2': true,
                                          'active': selectId == 208
                                      }"><img
                  src="data:image/png;base64,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"
                  width="120"></figure>
                <figure data-type="RICH_MENU_TEMPLATE_205"
                        @click="selectTemplate(205, 2)"
                        :class="{
                                          'figure': true,
                                          'mx-2': true ,
                                          'my-2': true,
                                          'active': selectId == 205
                                      }"><img
                  src="data:image/png;base64,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"
                  width="120"></figure>
                <figure data-type="RICH_MENU_TEMPLATE_206"
                        @click="selectTemplate(206, 2)"
                        :class="{
                                          'figure': true,
                                          'mx-2': true ,
                                          'my-2': true,
                                          'active': selectId == 206
                                      }"><img
                  src="data:image/png;base64,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"
                  width="120"></figure>
                <figure data-type="RICH_MENU_TEMPLATE_207"
                        @click="selectTemplate(207, 1)"
                        :class="{
                                          'figure': true,
                                          'mx-2': true ,
                                          'my-2': true,
                                          'active': selectId == 207
                                      }"><img
                  src="data:image/png;base64,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"
                  width="120"></figure>
              </div>
            </div>
          </div>
          <div class="d-flex-sm flex-shrink-0 modal-footer flex-row-reverse "
              style="text-align: center;     justify-content: center;">
            <button type="button" class="btn btn-submit" @click="acceptAction" data-dismiss="modal">選択
            </button>
            <button type="button" class="btn btn-secondary" data-dismiss="modal">キャンセル</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  props: {
    id: String,
    isShow: {
      type: Boolean,
      default: false
    },
    selectionId: {
      type: Number,
      default: 201
    },
    value: {
      type: Number,
      default: 6
    }
  },
  data() {
    return {
      showModal: this.isShow,
      selectId: this.selectionId,
      selectValue: this.value
    };
  },
  methods: {
    acceptAction() {
      this.$emit('accept', {
        id: this.selectId,
        value: this.selectValue
      });
    },

    selectTemplate(id, value) {
      this.selectId = id;
      this.selectValue = value;
    }
  }
};
</script>

<style lang="scss" scoped>
  .figure {
    border: 2px solid transparent;
    display: inline-block;
    width: fit-content;
    cursor: pointer;
  }

  .figure img {
    max-width: initial;
  }

  h5, .h5 {
    display: inline;
  }

  .active {
    border: 2px solid #14b81a;
    filter: contrast(0.8);
    border-radius: 7px;
  }

  @media(max-width: 767px) {
    .figure {
      width: 19vw;
    }
    .figure img {
      max-width: 100%;
    }
  }
</style>
