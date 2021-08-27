<template>
  <div class="modal fade modal-delete modal-common01" :id="id ? id: 'modal-alert'" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content p-0">
        <div class="modal-body">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <p class="mb10 fz14">{{title}}</p>
        </div>
        <div class="modal-footer flex center">
          <button type="button" class="btn btn-common01 btn-modal-cancel" data-dismiss="modal" @click="ok">OK</button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['title', 'id'],
  methods: {
    ok() {
      this.$emit('input');
    }
  }
};
</script>
