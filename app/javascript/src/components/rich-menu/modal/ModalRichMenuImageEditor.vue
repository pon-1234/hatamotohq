<template>
  <div tabindex="-1" role="dialog" aria-hidden="true" class="modal d-block"
        id="modalRichmenuImageEditor" style="background: rgba(0, 0, 0, 0.4);">
    <div class="modal-dialog modal-xl" role="document"
          >
      <div class="modal-content">
        <div class="modal-header flex-shrink-0"><h5 class="mb-0"><span v-if="editor === 'richmenu'">リッチメニュー</span><span v-else>画像を作成</span></h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close" data-toggle="modal" data-target="#modalConfirmCloseEditor"><span
            aria-hidden="true">&times;</span></button>
        </div>
        <div class="modal-body mh-100 overflow-y-auto">
          <rich-menu-image-editor :templateId="templateId" :editor="editor" @save="saveImage"></rich-menu-image-editor>
        </div>
      </div>
    </div>
    <modal-confirm id="modalConfirmCloseEditor" type="confirm" title="確認" @confirm="closeEditor()">
      <template v-slot:content>
        画像は保存されません。よろしいでしょうか。
      </template>
    </modal-confirm>
  </div>
</template>

<script setup>
import { onMounted, onUnmounted } from 'vue'

const props = defineProps(['templateId', 'editor'])
const emit = defineEmits(['close', 'input', 'deInit'])

onMounted(() => {
  $('body').css('overflow', 'hidden')
})

onUnmounted(() => {
  $('body').css('overflow', 'initial')
})

const closeEditor = () => {
  $('body').css('overflow', 'initial')
  emit('close')
}

const saveImage = (data) => {
  emit('input', data)
  emit('deInit')
  closeEditor()
}
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
