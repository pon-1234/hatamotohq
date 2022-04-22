<template>
  <div class="input-group d-flex">
  <input
    type="text"
    placeholder="フォルダー名"
    class="form-control"
    v-model.trim="siteName"
    @click.stop
    @keyup.enter="enterSubmitChangeName"
    ref="folderName"
    name="folder_name"
    maxlength="254"
    data-vv-as="フォルダー名"
    v-validate="'required|max:254'"
  />
  <span class="ml-auto">
    <div class="btn btn-default" @click="submitChangeName" ref="buttonChange">決定</div>
  </span>
</div>
</template>
<script>

export default {
  props: ['data'],
  data() {
    return {
      isEdit: false,
      siteName: ''
    };
  },

  created() {
    this.siteName = this.data.name;
  },

  methods: {
    submitChangeName() {
      this.$validator.validateAll().then(passed => {
        if (!passed) {
          return;
        }
        this.isEdit = false;
        if (this.siteName !== this.data.name) {
          this.$emit('editSite', { id: this.data.id, name: this.siteName });
        }
      });
    },
    enterSubmitChangeName(e) {
      if (!this.isEnter) {
        this.isEnter = true;
        return;
      }
      this.$refs.buttonChange.click();
    }
  }
};
</script>
