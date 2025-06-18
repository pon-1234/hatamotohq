<template>
  <b-modal
    :id="id"
    :ref="id"
    :title="title"
    :size="size"
    :hide-footer="hideFooter"
    :hide-header="hideHeader"
    :no-close-on-backdrop="noCloseOnBackdrop"
    :no-close-on-esc="noCloseOnEsc"
    :centered="centered"
    @show="onShow"
    @shown="onShown"
    @hide="onHide"
    @hidden="onHidden"
    @ok="onOk"
    @cancel="onCancel"
  >
    <!-- Header Slot -->
    <template v-if="!hideHeader && $slots.header" #modal-header>
      <slot name="header" />
    </template>

    <!-- Default Body Slot -->
    <slot />

    <!-- Footer Slot -->
    <template v-if="!hideFooter" #modal-footer="{ ok, cancel }">
      <slot name="footer" :ok="ok" :cancel="cancel">
        <!-- Default Footer Buttons -->
        <b-button
          v-if="showCancelButton"
          variant="secondary"
          @click="cancel()"
        >
          {{ cancelText }}
        </b-button>
        <b-button
          v-if="showOkButton"
          :variant="okVariant"
          :disabled="okDisabled"
          @click="ok()"
        >
          {{ okText }}
        </b-button>
      </slot>
    </template>
  </b-modal>
</template>

<script>
export default {
  name: 'BaseModal',
  props: {
    id: {
      type: String,
      required: true
    },
    title: {
      type: String,
      default: ''
    },
    size: {
      type: String,
      default: 'md',
      validator: (value) => ['sm', 'md', 'lg', 'xl'].includes(value)
    },
    hideFooter: {
      type: Boolean,
      default: false
    },
    hideHeader: {
      type: Boolean,
      default: false
    },
    noCloseOnBackdrop: {
      type: Boolean,
      default: false
    },
    noCloseOnEsc: {
      type: Boolean,
      default: false
    },
    centered: {
      type: Boolean,
      default: true
    },
    showCancelButton: {
      type: Boolean,
      default: true
    },
    showOkButton: {
      type: Boolean,
      default: true
    },
    cancelText: {
      type: String,
      default: 'キャンセル'
    },
    okText: {
      type: String,
      default: 'OK'
    },
    okVariant: {
      type: String,
      default: 'primary'
    },
    okDisabled: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    show() {
      this.$refs[this.id].show();
    },
    hide() {
      this.$refs[this.id].hide();
    },
    onShow() {
      this.$emit('show');
    },
    onShown() {
      this.$emit('shown');
    },
    onHide(evt) {
      this.$emit('hide', evt);
    },
    onHidden(evt) {
      this.$emit('hidden', evt);
    },
    onOk(evt) {
      this.$emit('ok', evt);
    },
    onCancel(evt) {
      this.$emit('cancel', evt);
    }
  }
};
</script>