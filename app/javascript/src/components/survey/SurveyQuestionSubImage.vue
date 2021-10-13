<template>
    <div class="form-group clearfix">
        <label class="col-sm-3">画像</label>
        <div class="col-sm-9 border-bottom">
            <img style="width: 150px; margin-bottom: 10px; height: 150px; object-fit: contain"
                :src="url"
                v-if="url"
            >
            <div>
              <input type="hidden" v-model="url">
              <button type="button" class="btn btn-upload"
                  @click="openAddFileModal()">
                  <i class="fa fa-upload"></i> ファイルをアップロード
              </button>
              <button type="button" class="btn btn-cancel"
                  @click="removeImage()">
                  <i class="fa fa-trash"></i> Remove
              </button>
            </div>
        </div>
        <media-modal :data="media_data" :id="name" @input="uploadedImg"/>
    </div>
</template>
<script>
export default {
  props: ['data', 'name'],
  data() {
    return {
      url: this.data || null,
      media_data: {
        type: this.MessageType.Image,
        originalContentUrl: this.data || '',
        previewImageUrl: ''
      }
    };
  },
  methods: {
    openAddFileModal() {
      $('#' + this.name).modal('show');
    },
    uploadedImg(value) {
      console.log(value);
      this.url = value.originalContentUrl;
      this.$emit('input', value.originalContentUrl);
    },
    removeImage() {
      this.url = null;
      this.media_data.originalContentUrl = null;
      this.$emit('input', this.media_data.originalContentUrl);
    }
  }
};
</script>

<style scoped>
    .btn-upload {
        color: #ea5516;
        background: #fff;
        border: 1px solid #ccc;
    }
</style>
