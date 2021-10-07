<template>
  <div
    class="modal fade"
    :id="id ? id : 'modalSelectMedia'"
    tabindex="-1"
    role="dialog"
    aria-labelledby="myModalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog modal-xl">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">メディア</h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close" ref="close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body overflow-hidden" :key="contentKey">
          <ul class="nav nav-tabs mb-3">
            <li class="nav-item">
              <a href="#uploadMedia" data-toggle="tab" aria-expanded="true" class="nav-link active">
                <i class="mdi mdi-home-variant d-md-none d-block"></i>
                <span class="d-none d-md-block">新規アップロード</span>
              </a>
            </li>
            <li class="nav-item">
              <a href="#selectMedia" data-toggle="tab" aria-expanded="false" class="nav-link">
                <i class="mdi mdi-account-circle d-md-none d-block"></i>
                <span class="d-none d-md-block">メディア一覧</span>
              </a>
            </li>
          </ul>
          <div class="tab-content">
            <div class="tab-pane show active" id="uploadMedia">
              <media-upload :types="types" @upload="selectMedia($event)"></media-upload>
            </div>
            <div class="tab-pane" id="selectMedia">
              <media-index
                mode="read"
                @select="selectMedia($event)"
                :filterable="filterable"
                :types="types"
              ></media-index>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { mapActions } from 'vuex';

export default {
  props: {
    types: {
      type: Array,
      default: () => ['image', 'audio', 'video']
    },
    filterable: {
      type: Boolean,
      default: true
    },
    id: {
      type: String
    }
  },

  data() {
    return {
      contentKey: 0
    };
  },

  methods: {
    ...mapActions('media', [
      'uploadMedia',
      'uploadRichMenu',
      'uploadImageMap'
    ]),

    forceRerender() {
      this.contentKey++;
    },

    selectMedia(media) {
      this.$emit('select', media);
      this.$refs.close.click();
    }
  }
};
</script>

<style  lang="scss"  scoped>
  ::v-deep {
    .hidden {
      display: none !important;
    }

    .modal-body {
      min-height: 70vh;
    }

    .custom-file {
      position: relative;
      display: inline-block;
      height: 40px;
      margin-bottom: 0;
    }

    input {
      overflow: visible;
    }

    .custom-file-input {
      position: relative;
      z-index: 2;
      margin: 0;
      opacity: 0;
    }

    .custom-file-label {
      position: absolute;
      top: 0;
      right: 0;
      left: 0;
      z-index: 1;
      height: 40px;
      color: #495057;
      background-color: #fff;
      border: 1px solid #cfd4da;
      border-radius: 2px;
      display: flex;
      align-items: center;
      padding-left: 10px;
      font-weight: 200;
      font-size: 15px;
    }

    .custom-file-label::after {
      position: absolute;
      top: 0;
      right: 0;
      bottom: 0;
      z-index: 3;
      display: flex;
      align-items: center;
      height: 38px;
      color: #495057;
      content: "+";
      background-color: #f8f9fa;
      border-left: 1px solid #cfd4da;
      border-radius: 0 2px 2px 0;
      padding-left: 10px;
      padding-right: 10px;
    }

    .text-muted {
      color: #adb5bd !important;
      display: block;
      font-size: 10px;
    }

    .text-center {
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
    }

    .error {
      color: red !important;
      font-size: 16px !important;
    }

    .h-fix-360 {
      border-top: none !important;
    }

    .nav-tabs .nav-link.active {
      color: #495057;
      background-color: #fff;
      border-color: #dee2e6 #dee2e6 #fff;
    }

    .nav-tabs > li {
      margin-bottom: -2px !important;
      width: 50%;
      text-align: center;
      a {
        margin-right: 0px !important;
      }
    }

    .thumb-item {
      margin: 0 auto 5px;
      cursor: pointer;
      display: inline-block;
    }
    .thumb-item:hover {
      .thumbnail-item {
        border: 2px solid #00b900;
        box-shadow: 0 0 2px 2px #e6ab92;
      }
      .chat-item-voice {
        border: 2px solid #00b900;
        box-shadow: 0 0 2px 2px #e6ab92;
      }
    }

    .modal-body {
      min-height: 550px !important;
    }

    .medias-content {
      padding: 10px 10px;
      min-height: 380px !important;
      height: 380px !important;
      overflow-y: auto;
      overflow-x: hidden;
      margin: 0px !important;
    }

    .tab-media {
      border-top: none !important;
    }
  }
</style>
