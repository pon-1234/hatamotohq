<template>
  <div>
    <div tabindex="-1" role="dialog" aria-hidden="true" class="modal modal-common01"
         style="display: block;background: rgb(0 0 0 / 28%);"
         id="modalRichmenuImageEditor">
      <div class="modal-dialog modal-dialog-centered modal-md modal-rg" role="document"
           style="min-width: 80%; max-height: 100%; overflow-y: auto; top: 0">
        <div class="modal-content h-100 p-0" style="width: 100%">
          <div class="modal-header flex-shrink-0"><h5 class="mb-0"><span v-if="editor === 'richmenu'">リッチメニュー</span><span v-else>画像を作成</span></h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close" @click="confirmModal()"><span
              aria-hidden="true">&times;</span></button>
          </div>
          <div class="modal-body mh-100 overflow-y-auto">
            <richmenu-image-editor :templateId="templateId" :editor="editor" @save="saveImage"></richmenu-image-editor>
          </div>
        </div>
      </div>
    </div>
    <modal-confirm id="modalConfirmCloseEditor" type="confirm" title="画像は保存されません。よろしいでしょうか。"
                   @input="closeEditor()"></modal-confirm>
  </div>
</template>

<script>
export default {
  props: ['templateId', 'editor'],
  data() {
    return {};
  },

  created() {
    $('body').css('overflow', 'hidden');
  },
  methods: {
    confirmModal() {
      $('#modalConfirmCloseEditor').modal('show');
    },

    closeEditor() {
      $('body').css('overflow', 'initial');
      this.$emit('close');
    },
    saveImage(data) {
      this.$emit('input', data);
      this.$emit('deInit');
      this.closeEditor();
    }
  }
};
</script>
<style lang="scss" scoped>
  .figure {
    border: 2px solid transparent;
    display: inline-block;
    width: fit-content;
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
  }

  @media(max-width: 991px) {
    .figure {
      width: 19vw;
    }
    .figure img {
      max-width: 100%;
    }
    .modal-dialog {
      position: relative;
      width: auto;
      margin: auto;
      max-width: initial !important;
    }
  }

</style>
