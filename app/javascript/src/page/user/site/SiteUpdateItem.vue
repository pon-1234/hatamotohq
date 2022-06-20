<template>
  <ValidationObserver ref="observer" v-slot="{ validate }">
    <ValidationProvider
      :name="'サイト名'"
      :rules="'required|max:255'"
      v-slot="{ errors }"
    >
      <div class="input-group d-flex">
        <input
          type="text"
          placeholder="サイト名"
          class="form-control"
          v-model.trim="siteName"
          @click.stop
          @keyup.enter="enterSubmitChangeName"
          name="site_name"
          maxlength="255"
          data-vv-as="サイト名"
        />
        <span class="ml-auto">
          <div class="btn btn-default" @click.prevent="validate().then(submitChangeName)" ref="buttonChange">決定</div>
        </span>
      </div>
      <span class="error-explanation">{{ errors[0] }}</span>
    </ValidationProvider>
  </ValidationObserver>
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
        } else {
          this.$emit('editSite', { id: this.data.id, name: this.siteName, notChange: true });
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
