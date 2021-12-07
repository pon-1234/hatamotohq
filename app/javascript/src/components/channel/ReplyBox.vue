<template>
  <div class="border rounded">
    <div class="comment-area-box">
      <textarea
        :disabled="!isEnabled"
        rows="4"
        class="form-control border-0 resize-none"
        v-model="message"
        name="message"
        @keydown.enter.shift.exact.prevent
        @keydown.enter.shift.exact="sendTextMessage"
        placeholder="Enterで改行、Shift+Enterで送信"
        data-vv-as="メッセージ"
        maxlength="5001"
        v-validate="'max:5000'"
      >
      </textarea>
      <error-message :message="errors.first('message')" class="ml-2" v-if="errors.first('message')"></error-message>
      <div class="p-2 bg-light d-flex justify-content-between align-items-center">
        <div>
          <a
            data-toggle="modal"
            data-target="#modalSelectSticker"
            @click="showStickerModal()"
            class="btn btn-sm px-2 font-16 btn-light"
            ><i class="uil uil-smile"></i
          ></a>
          <a data-toggle="modal" data-target="#modalSendMedia" class="btn btn-sm px-2 font-16 btn-light"
            ><i class="uil uil-file"></i
          ></a>
          <div class="btn-group dropup">
            <button
              type="button"
              class="btn btn-sm px-2 font-16 btn-light dropdown-toggle"
              data-toggle="dropdown"
              aria-haspopup="true"
              aria-expanded="false"
            >
              <i class="uil-plus"></i>
            </button>
            <div class="dropdown-menu">
              <div role="button" class="dropdown-item" data-toggle="modal" data-target="#modalSendTemplate">
                テンプレート配信
              </div>
              <div class="dropdown-divider"></div>
              <div role="button" class="dropdown-item" data-toggle="modal" data-target="#modalSendScenario">
                シナリオ配信
              </div>
            </div>
          </div>
        </div>
        <button class="btn btn-sm btn-success" @click="sendTextMessage" :disabled="!isEnabled || !message.trim()">
          <i class="uil uil-message mr-1"></i>送信
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import ErrorMessage from '../common/ErrorMessage.vue';
export default {
  components: { ErrorMessage },
  data() {
    return {
      message: ''
    };
  },

  computed: {
    ...mapState('channel', {
      activeChannel: state => state.activeChannel
    }),

    isEnabled() {
      return this.activeChannel;
    }
  },

  methods: {
    clearInput() {
      this.message = '';
    },

    sendTextMessage() {
      this.$emit('sendTextMessage', this.message);
      this.clearInput();
    },

    showStickerModal() {
      if (this.isEnabled) {
        this.$emit('resetModalSticker', true);
      }
    }
  }
};
</script>

<style>
</style>