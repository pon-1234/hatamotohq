<template>
  <div :id="id ? id : 'confirmModal'" class="modal fade" role="dialog">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
      <div class="modal-content">
        <div class="modal-header align-items-center">
          <label class="m-0">{{ title || '本当に削除してよろしいですか？'  }}</label>
          <button type="button" class="close" data-dismiss="modal">×</button>
        </div>
        <div class="modal-body">
          <slot name="content"></slot>
        </div>
        <div class="modal-footer">
          <div class="btn btn-danger" data-dismiss="modal" @click="confirm"> {{ type === 'delete' ? '削除' : 'はい' }}</div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  props: {
    id: {
      type: String,
      required: false
    },
    title: {
      type: String,
      required: false
    },
    type: {
      type: String,
      required: false,
      default: 'delete'
    }
  },
  methods: {
    confirm() {
      this.$emit('confirm');
    }
  }
};
</script>
