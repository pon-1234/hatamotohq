<template>
  <div :id="id ? id : 'confirmModal'" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="info-header-modalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title" id="info-header-modalLabel">{{ title || 'お知らせ'  }}</h4>
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        </div>
        <div class="modal-body">
          <slot name="content"></slot>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-light" data-dismiss="modal">キャンセル</button>
          <button type="button" class="btn btn-info" data-dismiss="modal" @click="confirm" v-if="type === 'confirm'">確認</button>
          <button type="button" class="btn btn-danger" data-dismiss="modal" @click="confirm" v-if="type === 'delete'">削除</button>
        </div>
      </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
  </div><!-- /.modal -->
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
