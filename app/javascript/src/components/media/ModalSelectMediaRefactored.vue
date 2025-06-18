<template>
  <base-modal
    :id="modalId"
    ref="modal"
    title="メディア"
    size="xl"
    hide-footer
    @show="handleShow"
    @hide="handleHide"
  >
    <template v-if="visible">
      <b-tabs content-class="mt-3">
        <b-tab title="新規アップロード" active>
          <media-upload
            ref="mediaUpload"
            :types="types"
            @upload="selectMedia"
          />
        </b-tab>
        <b-tab title="メディア一覧">
          <media-index
            ref="modalMediaIndex"
            mode="read"
            :filterable="filterable"
            :types="types"
            @select="selectMedia"
          />
        </b-tab>
      </b-tabs>
    </template>
  </base-modal>
</template>

<script>
import { mapActions } from 'vuex';
import BaseModal from '../base/BaseModal.vue';
import MediaUpload from './MediaUpload.vue';
import MediaIndex from './MediaIndex.vue';

export default {
  name: 'ModalSelectMediaRefactored',
  components: {
    BaseModal,
    MediaUpload,
    MediaIndex
  },
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
      type: String,
      default: 'modal-select-media'
    }
  },
  data() {
    return {
      visible: false
    };
  },
  computed: {
    modalId() {
      return this.id || 'modal-select-media';
    }
  },
  methods: {
    ...mapActions('media', ['uploadMedia', 'uploadRichMenu', 'uploadImageMap']),

    show() {
      this.$refs.modal.show();
    },

    hide() {
      this.$refs.modal.hide();
    },

    selectMedia(media) {
      this.$emit('select', media);
      this.hide();
    },

    handleShow() {
      this.visible = true;
    },

    handleHide() {
      this.visible = false;
    }
  }
};
</script>

<style scoped>
:deep(.modal-body) {
  min-height: 70vh;
}

:deep(.tab-content) {
  padding: 1rem 0;
}

:deep(.nav-tabs) {
  border-bottom: 2px solid #dee2e6;
}

:deep(.nav-link.active) {
  border-color: #dee2e6 #dee2e6 #fff;
  border-bottom: 2px solid #fff;
  margin-bottom: -2px;
}
</style>