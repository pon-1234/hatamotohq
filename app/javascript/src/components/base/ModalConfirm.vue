<template>
  <div class="modal fade modal-delete modal-common01" :id="id ? id: 'modal-confirm'" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content p-0">
        <div class="modal-body">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <p class="mb10 fz14">{{title}}</p>
        </div>
        <div class="modal-footer flex center">
          <button type="button" v-if="type ==='confirm'" class="btn btn-common01 btn-modal-confirm" data-dismiss="modal" @click="confirm">はい</button>
          <button type="button" v-if="type ==='delete'" class="btn btn-common01 btn-modal-delete" data-dismiss="modal" @click="confirm">削除</button>
          <button type="button" class="btn btn-common01 btn-modal-cancel" data-dismiss="modal">キャンセル</button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['title', 'type', 'id'],
  methods: {
    confirm() {
      this.$emit('input');
    }
  }
};
</script>
