<template>
  <div class="input-group">
    <input type="text" class="form-control" :value="text" disabled>
    <div class="input-group-append">
      <button class="btn btn-outline-secondary" type="button" @click="copy()"><i class="fa fa-copy"></i></button>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    text: {
      type: String,
      required: false
    }
  },

  methods: {
    copy() {
      navigator.clipboard.writeText(this.text);
      window.toastr.success('コピーしました。');
    }
  }
};
</script>