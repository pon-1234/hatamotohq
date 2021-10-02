<template>
  <div class="border rounded">
    <div class="comment-area-box">
      <textarea rows="4"
        class="form-control border-0 resize-none"
        v-model="message"
        @keydown.enter.shift.exact.prevent
        @keydown.enter.shift.exact="sendTextMessage"
        placeholder="Enterで改行、Shift+Enterで送信">
      </textarea>
      <div class="p-2 bg-light d-flex justify-content-between align-items-center">
        <div>
          <a data-toggle="modal" data-target="#modalSelectSticker" @click="showStickerModal()" class="btn btn-sm px-2 font-16 btn-light"><i class="uil uil-smile"></i></a>
          <a data-toggle="modal" data-target="#modalSendMedia" class="btn btn-sm px-2 font-16 btn-light"><i class="uil uil-scenery"></i></a>
          <div class="btn-group dropup">
            <button type="button" class="btn btn-sm px-2 font-16 btn-light dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="uil-plus"></i></button>
            <div class="dropdown-menu">
              <a role="button" class="dropdown-item" data-toggle="modal" data-target="#modalSendTemplate">テンプレート配信</a>
              <div class="dropdown-divider"></div>
              <a role="button" class="dropdown-item" data-toggle="modal" data-target="#modalSendScenario">シナリオ配信</a>
            </div>
          </div>
        </div>
        <button class="btn btn-sm btn-success" @click="sendTextMessage"><i class="uil uil-message mr-1"></i>送信</button>
      </div>
    </div>
    <div class="mt-auto" hidden>
      <div class="mt-2 bg-light p-3 rounded">
        <div class="row">
          <div class="col mb-2 mb-sm-0">
            <input type="text" class="form-control border-0"
              :placeholder="!isMobile? 'Enterで改行、Shift+Enterで送信': ''"
              v-model="message"
              @keydown.enter.shift.exact.prevent
              @keydown.enter.shift.exact="sendTextMessage"
              required="">
            <div class="invalid-feedback">
              メッセージを入力してください
            </div>
          </div>
          <div class="col-sm-auto">
            <div class="btn-group">
              <div class="btn btn-light" data-toggle="modal" data-target="#modalSendMedia"><i class="uil uil-paperclip"></i></div>
              <div class="btn btn-light" data-toggle="modal" data-target="#modalSelectSticker" @click="showStickerModal()"> <i class='uil uil-smile'></i></div>
              <button type="submit" class="btn btn-success chat-send btn-block" @click="sendTextMessage"><i
                  class='uil uil-message'></i></button>
            </div>
          </div> <!-- end col -->
        </div> <!-- end row-->
      </div>
    </div>
    <template v-if="activeChannel">
      <modal-select-media id="modalSendMedia" :types="['image','audio','video']" @select="sendMediaMessage($event)"></modal-select-media>
      <modal-send-template @sendTemplate="sendTemplate"></modal-send-template>
      <modal-send-scenario @selectScenario="sendScenario"></modal-send-scenario>
      <modal-select-sticker ref="modalSticker" name="modalSelectSticker" @input="sendStickerMessage"></modal-select-sticker>
    </template>
  </div>
</template>

<script>
import { mapState } from 'vuex';
export default {
  data() {
    return {
      message: ''
    };
  },

  computed: {
    ...mapState('channel', {
      activeChannel: state => state.activeChannel
    })
  },

  methods: {
    clearInput() {
      this.message = '';
    },

    sendTextMessage() {
      this.$emit('sendTextMessage', this.message);
      this.clearInput();
    },

    sendStickerMessage(sticker) {
      this.$emit('sendStickerMessage', sticker);
    },

    sendMediaMessage(media) {
      const payload = _.cloneDeep(media);
      // convert media type if need
      if (payload.type === 'richmenu') {
        payload.type = 'image';
      }
      this.$emit('sendMediaMessage', payload);
    },

    sendTemplate(template) {
      const payload = {
        channel_id: this.activeChannel.id,
        template_id: template.id
      };
      this.$emit('sendTemplate', payload);
    },

    sendScenario(scenario) {
      const payload = {
        channel_id: this.activeChannel.id,
        scenario_id: scenario.id
      };
      this.$emit('sendScenario', payload);
    },

    showStickerModal() {
      this.$refs.modalSticker.reset();
    }
  }
};
</script>

<style>

</style>