<template>
  <div tabindex="-1" role="dialog" aria-hidden="true" class="modal fade modal-common01" :id="id">
    <div class="modal-dialog modal-dialog-centered modal-md modal-rg" role="document">
      <div class="modal-content h-100 p-0">
        <div class="modal-header flex-shrink-0 d-flex">
          <h5 class="mb-0 title">{{model.name}}</h5>
          <button class="close" data-dismiss="modal">×</button>
        </div>
        <div class="modal-body mh-100 overflow-hidden">
          <div class="preview">
            <div v-html="model.html_template"></div>
          </div>
        </div>
        <div class=" modal-footer" style="text-align: center">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">キャンセル</button>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
const props = defineProps(['id', 'model'])
</script>
<style lang="scss" scoped>

  :deep() {
    .title {
      flex: 1 1 0%;
      margin: 0px;
      width: calc(100% - 10px);
      text-overflow: ellipsis;
      white-space: nowrap;
      overflow: hidden;
      line-height: 2em;
    }

    .flex-error {
      border: 0px solid red !important;
    }
    .flex-editor {
      border: 0px solid transparent;
    }

    .flex-editor:hover {
      border: 0px solid #0a90eb;
    }

    .preview *::-webkit-scrollbar {
      display: inherit !important;
      color: inherit;

      height: 8px;
      margin-top: 2px;

    }
    .preview ::-webkit-scrollbar-thumb { /* leave most bars alone */
      background-color: grey;
      border-radius: 6px;
    }

    .preview {
      flex: 1;
      background: #ededed;
      display: flex;
      overflow: auto;

    }

    .preview > div {
      margin: 10px auto;
      justify-content: center;
      min-width: 300px;
    }

    .preview > div > div {
      width: 100%;
    }
    .modal-body {
      padding: 20px;
      background: #ededed;
    }

  }

  .alert {
    padding: 10px;
    margin-bottom: 10px;
    border: 1px solid transparent;
    border-radius: 4px;
  }

  .figure {
    border: 2px solid transparent;
    display: inline-block;
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

  .custom-file {
    position: relative;
    display: inline-block;
    width: 60%;
    margin-bottom: 0;
  }

  .custom-file-input {
    position: relative;
    z-index: 2;
    width: 100%;
    height: 100%;
    margin: 0;
    opacity: 0;
  }

  .file-input-wrapper input {
    cursor: pointer;
    max-width: 100%;
    min-height: 100%;
  }

  .custom-file-label {
    position: absolute;
    top: 0;
    right: 0;
    left: 0;
    z-index: 1;
    padding: 0.375rem 0.75rem;
    line-height: 1.5;
    color: #495057;
    background-color: #fff;
    border: 1px solid #cfd4da;
    border-radius: 2px;
    margin: 0;
  }

  .custom-file-label::after {
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    z-index: 3;
    display: block;
    padding: 0.375rem 0.75rem;
    line-height: 1.5;
    color: #495057;
    content: "+";
    background-color: #f8f9fa;
    border-left: 1px solid #cfd4da;
    border-radius: 0 2px 2px 0;
  }

  @media (max-width: 767px) {

    .preview > div {
      min-width: initial;
      width: 100%;
      display: contents;
    }
    form {
      height: 60vw;
    }
  }

</style>
